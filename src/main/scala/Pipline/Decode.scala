package Pipline
import chisel3._
import chisel3.util.{Cat, Fill, ListLookup, MuxCase}
import common.Defines._
import common.Instructions._
import connect.{DecexIO, IfidIO, RegReadIO}
class Decode extends Module {
  val io = IO(new Bundle() {
    val extend = Flipped(new IfidIO)
    val regs = Flipped(new RegReadIO(REG_ADDR_LEN))
    val passby = new DecexIO
  })

  // 将InstFetch和Decode连起来
  val id_inst_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val id_pc_reg = RegInit(0.U(WORD_LEN_WIDTH))
  id_inst_reg := io.extend.if_inst
  id_pc_reg := io.extend.if_inst

  // 将Decode和Register连起来
  val rs1_addr = id_inst_reg(19, 15)
  val rs2_addr = id_inst_reg(24, 20)
  io.regs.reg_raddr1 := rs1_addr
  io.regs.reg_raddr2 := rs2_addr

  // 取出register中的内容
  val reg1_data = io.regs.reg_rdata1
  val reg2_data = io.regs.reg_rdata2
  val rs1_data = Mux(rs1_addr =/= 0.U(WORD_LEN_WIDTH), reg1_data, 0.U(WORD_LEN_WIDTH))
  val rs2_data = Mux(rs2_addr =/= 0.U(WORD_LEN_WIDTH), reg2_data, 0.U(WORD_LEN_WIDTH))

  // 取出写回地址
  val wb_addr = id_inst_reg(11, 7)
  // 各种组合的立即数
  val imm_i = id_inst_reg(31, 20)
  val imm_i_sext = Cat(Fill(20, imm_i(11)), imm_i)
  val imm_s = Cat(id_inst_reg(31, 25), id_inst_reg(11, 7))
  val imm_s_sext = Cat(Fill(20, imm_s(11)), imm_s)
  val imm_b = Cat(id_inst_reg(31), id_inst_reg(7), id_inst_reg(30, 25), id_inst_reg(11, 8))
  val imm_b_sext = Cat(Fill(19, imm_b(11)), imm_b, 0.U(1.U))
  val imm_j = Cat(id_inst_reg(31), id_inst_reg(19, 12), id_inst_reg(20), id_inst_reg(30, 21))
  val imm_j_sext = Cat(Fill(11, imm_j(19)), imm_j, 0.U(1.U))
  val imm_u = id_inst_reg(31, 12)
  val imm_u_shifted = Cat(imm_u, Fill(12, 0.U))
  val imm_z = id_inst_reg(19, 15)
  val imm_z_uext = Cat(Fill(27, 0.U), imm_z)

  // 译码，分析指令
  val decoded_inst = ListLookup(id_inst_reg, List(ALU_X, OP1_X, OP2_X, MEN_X, REN_X, WB_X, CSR_X), Array(
    // SW和LW
    S_SW      -> List(ALU_ADD, OP1_RS, OP2_IM_S, MEN_S, REN_X, WB_X,   CSR_X),
    I_LW      -> List(ALU_ADD, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_MEM, CSR_X),
    // 加减
    R_ADD     -> List(ALU_ADD, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    R_SUB     -> List(ALU_SUB, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_ADDI    -> List(ALU_ADD, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 逻辑
    R_AND     -> List(ALU_AND, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_ANDI    -> List(ALU_AND, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_OR      -> List(ALU_OR, OP1_RS, OP2_RS,    MEN_X, REN_S, WB_ALU, CSR_X),
    I_ORI     -> List(ALU_OR, OP1_RS, OP2_IM_I,  MEN_X, REN_S, WB_ALU, CSR_X),
    R_XOR     -> List(ALU_XOR, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_XORI    -> List(ALU_OR, OP1_RS, OP2_IM_I,  MEN_X, REN_S, WB_ALU, CSR_X),
    // 移位
    R_SLL     -> List(ALU_SLL, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SLLI    -> List(ALU_SLL, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_SRL     -> List(ALU_SRL, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SRLI    -> List(ALU_SRL, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_SRA     -> List(ALU_SRA, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SRAI    -> List(ALU_SRA, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 比较
    R_SLT     -> List(ALU_SLT, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SLTI    -> List(ALU_SLT, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_SLTU    -> List(ALU_SLT, OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SLTIU   -> List(ALU_SLT, OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 跳转
    J_JAL     -> List(ALU_ADD,  OP1_PC, OP2_IM_J, MEN_X, REN_S, WB_PC,  CSR_X),
    U_LUI     -> List(ALU_ADD,  OP1_X,  OP2_IM_U, MEN_X, REN_S, WB_ALU, CSR_X),
    U_AUIPC   -> List(ALU_ADD,  OP1_PC, OP2_IM_U, MEN_X, REN_S, WB_ALU, CSR_X),
    I_JALR    -> List(ALU_JALR, OP1_PC, OP2_IM_J, MEN_X, REN_S, WB_PC,  CSR_X),
    B_BEQ     -> List(BR_BEQ,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BNE     -> List(BR_BNE,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BLTU    -> List(BR_BLTU,  OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BGEU    -> List(BR_BGEU,  OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BLT     -> List(BR_BLT,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BGE     -> List(BR_BGE,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    // CSR相关
    CSR_RW    -> List(ALU_NOP_CSR, OP1_RS,   OP2_X,  MEN_X, REN_S, WB_CSR, CSR_W),
    CSR_RW_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X,  MEN_X, REN_S, WB_CSR, CSR_W),
    CSR_RS    -> List(ALU_NOP_CSR, OP1_RS,   OP2_X,  MEN_X, REN_S, WB_CSR, CSR_S),
    CSR_RS_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X,  MEN_X, REN_S, WB_CSR, CSR_S),
    CSR_RC    -> List(ALU_NOP_CSR, OP1_RS,   OP2_RS, MEN_X, REN_S, WB_CSR, CSR_C),
    CSR_RC_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X,  MEN_X, REN_S, WB_CSR, CSR_C),
    CSR_ECALL -> List(ALU_X,       OP1_X,    OP2_X,  MEN_X, REN_X, WB_X,   CSR_E)
  ))

  val exe_fun :: op1_sel :: op2_sel :: mem_wen :: reg_wen :: wb_sel :: csr_cmd :: Nil = decoded_inst

  // 操作数1
  val op1_data = MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (op1_sel === OP1_RS)   -> rs1_data,
    (op1_sel === OP1_PC)   -> id_pc_reg,
    (op1_sel === OP1_IM_Z) -> imm_z_uext
  ))
  // 操作数2
  val op2_data = MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (op2_sel === OP2_RS)   -> rs2_data,
    (op2_sel === OP2_IM_I) -> imm_i_sext,
    (op2_sel === OP2_IM_S) -> imm_s_sext,
    (op2_sel === OP2_IM_J) -> imm_j_sext,
    (op2_sel === OP2_IM_U) -> imm_u_shifted
  ))

  val csr_addr = Mux(csr_cmd === CSR_E, 0x342.U(CSR_REG_LEN), id_inst_reg(31, 20))

  // 连接执行单元
  io.passby.id_pc_reg := id_pc_reg
  io.passby.imm_i_sext := imm_i_sext
  io.passby.imm_s_sext := imm_s_sext
  io.passby.imm_b_sext := imm_b_sext
  io.passby.imm_u_shifted := imm_u_shifted
  io.passby.imm_z_uext := imm_z_uext
  io.passby.op1_data := op1_data
  io.passby.op2_data := op2_data
  io.passby.rs2_data := rs2_data
  io.passby.wb_addr := wb_addr
  io.passby.exe_fun := exe_fun
  io.passby.mem_wen := mem_wen
  io.passby.reg_wen := reg_wen
  io.passby.wb_sel := wb_sel
  io.passby.csr_cmd := csr_cmd
  io.passby.csr_addr := csr_addr
}
