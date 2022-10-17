package fetch
import chisel3.util.{Cat, Fill, MuxCase, ListLookup}
import chisel3._
import common.Defines._
import common.Instructions._
import connect.{InstIO, WbIO}
class Core extends Module {
  val io = IO(new Bundle() {
    val imem = Flipped(new InstIO)
    val wbio = Flipped(new WbIO)
    val ce = Output(Bool())
  })
  val registers = Mem(32, UInt(WORD_LEN_WIDTH))
  // Control and Status Registers
  val csr_register = Mem(4096, UInt(WORD_LEN_WIDTH))
  // Instruction Fetch (IF) Stage
  val pc_reg = RegInit(START_ADDR)
  // pc_reg := pc_reg + 4.U(WORD_LEN_WIDTH)
  io.imem.inst_addr := pc_reg
  val inst = io.imem.inst_o
  val alu_out = Wire(UInt(WORD_LEN_WIDTH))
  val br_flag = Wire(Bool())
  val br_target = Wire(UInt(WORD_LEN_WIDTH))
  val pc_next = MuxCase(pc_reg+4.U(32.W), Seq(
    (inst === J_JAL)    -> alu_out,
    (inst === I_JALR)   -> alu_out,
    (inst === CSR_ECALL)-> csr_register(0x305),
    (br_flag === true.asBool) -> br_target
  ))
  pc_reg := pc_next
  io.ce := (inst === 0x13136f97.U(WORD_LEN_WIDTH))

  // Instruction Decode (ID) Stage
  val rs1_addr = inst(19, 15)
  val rs2_addr = inst(24, 20)
  val wb_addr = inst(11, 7)
  val rs1_data = Mux(rs1_addr =/= 0.U(WORD_LEN.U), registers(rs1_addr), 0.U(WORD_LEN.W))
  val rs2_data = Mux(rs2_addr =/= 0.U(WORD_LEN.U), registers(rs2_addr), 0.U(WORD_LEN.W))
  val imm_i = inst(31, 20)
  val imm_i_sext = Cat(Fill(20, imm_i(11)), imm_i)
  val imm_s = Cat(inst(31, 25), inst(11, 7))
  val imm_s_sext = Cat(Fill(20, imm_s(11)), imm_s)
  val imm_b = Cat(inst(31), inst(7), inst(30, 25), inst(11, 8))
  val imm_b_sext = Cat(Fill(19, imm_b(11)), imm_b, 0.U(1.U))
  val imm_j = Cat(inst(31), inst(19, 12), inst(20), inst(30, 21))
  val imm_j_sext = Cat(Fill(11, imm_j(19)), imm_j, 0.U(1.U))
  val imm_u = inst(31, 12)
  val imm_u_shifted = Cat(imm_u, Fill(12, 0.U))
  val imm_z = inst(19, 15)
  val imm_z_uext = Cat(Fill(27, 0.U), imm_z)

  val decoded_inst = ListLookup(inst, List(ALU_X, OP1_X, OP2_X, MEN_X, REN_X, WB_X, CSR_X), Array(
    // SW和LW
    S_SW      -> List(ALU_ADD,  OP1_RS, OP2_IM_S, MEN_S, REN_X, WB_X,   CSR_X),
    I_LW      -> List(ALU_ADD,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_MEM, CSR_X),
    // 加减
    R_ADD     -> List(ALU_ADD,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    R_SUB     -> List(ALU_SUB,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_ADDI    -> List(ALU_ADD,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 逻辑
    R_AND     -> List(ALU_AND,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_ANDI    -> List(ALU_AND,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_OR      -> List(ALU_OR,   OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_ORI     -> List(ALU_OR,   OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_XOR     -> List(ALU_XOR,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_XORI    -> List(ALU_OR,   OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 移位
    R_SLL     -> List(ALU_SLL,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SLLI    -> List(ALU_SLL,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_SRL     -> List(ALU_SRL,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SRLI    -> List(ALU_SRL,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_SRA     -> List(ALU_SRA,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SRAI    -> List(ALU_SRA,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 比较
    R_SLT     -> List(ALU_SLT,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SLTI    -> List(ALU_SLT,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    R_SLTU    -> List(ALU_SLT,  OP1_RS, OP2_RS,   MEN_X, REN_S, WB_ALU, CSR_X),
    I_SLTIU   -> List(ALU_SLT,  OP1_RS, OP2_IM_I, MEN_X, REN_S, WB_ALU, CSR_X),
    // 跳转
    J_JAL     -> List(ALU_ADD,  OP1_PC, OP2_IM_J, MEN_X, REN_S, WB_PC,  CSR_X),
    U_LUI     -> List(ALU_ADD,  OP1_X,  OP2_IM_U, MEN_X, REN_S, WB_ALU, CSR_X),
    U_AUIPC   -> List(ALU_ADD,  OP1_PC, OP2_IM_U, MEN_X, REN_S, WB_ALU, CSR_X),
    I_JALR    -> List(ALU_JALR, OP1_PC, OP2_IM_J, MEN_X, REN_S, WB_PC,  CSR_X),
    B_BEQ     -> List(BR_BEQ,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BNE     -> List(BR_BNE,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BLTU    -> List(BR_BLTU,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BGEU    -> List(BR_BGEU,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BLT     -> List(BR_BLT,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    B_BGE     -> List(BR_BGE,   OP1_RS, OP2_RS,   MEN_X, REN_X, WB_X,   CSR_X),
    CSR_RW    -> List(ALU_NOP_CSR, OP1_RS, OP2_X, MEN_X, REN_S, WB_CSR, CSR_W),
    CSR_RW_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X, MEN_X, REN_S, WB_CSR, CSR_W),
    CSR_RS    -> List(ALU_NOP_CSR, OP1_RS, OP2_X, MEN_X, REN_S, WB_CSR, CSR_S),
    CSR_RS_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X, MEN_X, REN_S, WB_CSR, CSR_S),
    CSR_RC    -> List(ALU_NOP_CSR, OP1_RS, OP2_RS, MEN_X, REN_S, WB_CSR, CSR_C),
    CSR_RC_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X, MEN_X, REN_S, WB_CSR, CSR_C)
  ))
  val exe_fun::op1_sel::op2_sel::mem_wen::rf_wen::wb_sel::csr_cmd::Nil = decoded_inst
  val op1_data = MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (op1_sel === OP1_RS)   -> rs1_data,
    (op1_sel === OP1_PC)   -> pc_reg,
    (op1_sel === OP1_IM_Z) -> imm_z_uext
  ))
  val op2_data = MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (op2_sel === OP2_RS)   -> rs2_data,
    (op2_sel === OP2_IM_I) -> imm_i_sext,
    (op2_sel === OP2_IM_S) -> imm_s_sext,
    (op2_sel === OP2_IM_J) -> imm_j_sext,
    (op2_sel === OP2_IM_U) -> imm_u_shifted
  ))

  // Excute (EX) Stage
  val inv_one = Cat(Fill(WORD_LEN-1, 1.U(1.W)), 0.U(1.U))

  alu_out := MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (exe_fun === ALU_ADD)     -> (op1_data + op2_data),
    (exe_fun === ALU_SUB)     -> (op1_data - op2_data),
    (exe_fun === ALU_AND)     -> (op1_data & op2_data),
    (exe_fun === ALU_OR)      -> (op1_data | op2_data),
    (exe_fun === ALU_XOR)     -> (op1_data ^ op2_data),
    (exe_fun === ALU_SLL)     -> (op1_data << op2_data(4, 0)).asUInt,
    (exe_fun === ALU_SRL)     -> (op1_data >> op2_data(4, 0)).asUInt,
    (exe_fun === ALU_SRA)     -> (op1_data.asSInt >> op2_data(4, 0)).asUInt,
    (exe_fun === ALU_SLT)     -> (op1_data.asSInt < op2_data.asSInt).asUInt,
    (exe_fun === ALU_SLTU)    -> (op1_data < op2_data).asUInt,
    (exe_fun === ALU_JALR)    -> ((op1_data + op2_data) & inv_one),
    (exe_fun === ALU_NOP_CSR) -> (op1_data)
  ))
  br_flag := MuxCase(false.asBool, Seq(
    (exe_fun === BR_BEQ)   -> (op1_data === op2_data),
    (exe_fun === BR_BNE)   -> (op1_data =/= op2_data),
    (exe_fun === BR_BLTU)  -> (op1_data < op2_data),
    (exe_fun === BR_BLT)   -> (op1_data.asSInt < op2_data.asSInt),
    (exe_fun === BR_BGEU)  -> (op1_data >= op2_data),
    (exe_fun === BR_BGE)   -> (op1_data.asSInt >= op2_data.asSInt)
  ))

  br_target := pc_reg + imm_b_sext

  // Memory Access Stage
  io.wbio.write_en := MuxCase(false.asBool, Seq(
    (mem_wen === MEN_S) -> false.asBool,
    (mem_wen === MEN_X) -> true.asBool
  ))
  io.wbio.raddr := alu_out // 要从mem读数据/指令的地址
  // CSR: 取数
  val csr_addr = MuxCase(registers(wb_addr), Seq(
    (csr_cmd === CSR_E) -> 0x342.U(CSR_REG_LEN)
  ))
  val csr_rdata = csr_register(csr_addr)
  // CSR: 计算
  val csr_out = MuxCase(csr_rdata, Seq(
    (csr_cmd === CSR_W) -> alu_out,
    (csr_cmd === CSR_S) -> (alu_out & csr_rdata),
    (csr_cmd === CSR_C) -> (alu_out & csr_rdata),
    (csr_cmd === CSR_E) -> 11.U(WORD_LEN_WIDTH)
  ))
  // CSR: 写回CSR寄存器
  when(csr_cmd > 0.U(CSR_LEN)){
    csr_register(wb_addr) := csr_out
  }
  // 注意此处，向mem输入的读和写的地址都在此处
  io.wbio.waddr := alu_out
  io.wbio.wdata := rs2_data

  //  Writeback (WB) Stage
  /*
  when(inst === I_LW) {
    registers(wb_addr) := io.wbio.rdata
  }
   */
  val wb_data = MuxCase(alu_out, Seq(
    (wb_sel === WB_MEM) -> io.wbio.rdata, // 将从mem中读到的数据作为要写入的data
    (wb_sel === WB_PC)  -> (pc_reg + 4.U),
    (wb_sel === WB_CSR) -> csr_rdata
  ))
  when (rf_wen === REN_S){
    registers(wb_addr) := wb_data
  }
}
