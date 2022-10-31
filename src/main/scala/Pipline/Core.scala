package Pipline
import chisel3.util.{Cat, Fill, MuxCase, ListLookup}
import chisel3._
import common.Defines._
import common.Instructions._
import connect.{InstIO, WbIO}
class Core extends Module {
  val io = IO(new Bundle() {
    val imem = Flipped(new InstIO)
    val wbio = Flipped(new WbIO)
    val gp = Output(Bool())
    val exit = Output(Bool())
  })


  // 通用寄存器和状态寄存器

  // Control and Status Registers
  val csr_register = Mem(4096, UInt(WORD_LEN_WIDTH))


  // Pipline registers

  // Pipeline: IF/ID
  val id_reg_inst = RegInit(0.U(WORD_LEN_WIDTH))
  val id_reg_pc = RegInit(0.U(WORD_LEN_WIDTH))

  // Pipeline: ID/EX
  val exe_reg_pc = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_wb_addr = RegInit(0.U(REG_ADDR_WIDTH))
  val exe_reg_op1_data = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_op2_data = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_rs2_data = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_exe_fun = RegInit(0.U(EXE_FUN_LEN))
  val exe_reg_mem_wen = RegInit(0.U(MEN_LEN))
  val exe_reg_rf_wen = RegInit(0.U(REN_LEN))
  val exe_reg_wb_sel = RegInit(0.U(WB_SEL_LEN))
  val exe_reg_csr_addr = RegInit(0.U(CSR_REG_LEN))
  val exe_reg_csr_cmd = RegInit(0.U(CSR_LEN))
  val exe_reg_imm_i_sext = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_imm_s_sext = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_imm_b_sext = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_imm_u_shifted = RegInit(0.U(WORD_LEN_WIDTH))
  val exe_reg_imm_z_uext = RegInit(0.U(WORD_LEN_WIDTH))

  // Pipeline: EX/MEM
  val mem_reg_pc = RegInit(0.U(WORD_LEN_WIDTH))
  val mem_reg_wb_addr = RegInit(0.U(REG_ADDR_WIDTH))
  val mem_reg_op1_data = RegInit(0.U(WORD_LEN_WIDTH))
  val mem_reg_rs2_data = RegInit(0.U(WORD_LEN_WIDTH))
  val mem_reg_mem_wen = RegInit(0.U(MEN_LEN))
  val mem_reg_rf_wen = RegInit(0.U(REN_LEN))
  val mem_reg_wb_sel = RegInit(0.U(WB_SEL_LEN))
  val mem_reg_csr_addr = RegInit(0.U(CSR_REG_LEN))
  val mem_reg_csr_cmd = RegInit(0.U(CSR_LEN))
  val mem_reg_imm_z_uext = RegInit(0.U(WORD_LEN_WIDTH))
  val mem_reg_alu_out = RegInit(0.U(WORD_LEN_WIDTH))

  // Pipeline: MEM/WB
  val wb_reg_wb_addr = RegInit(0.U(REG_ADDR_WIDTH))
  val wb_reg_rf_wen = RegInit(0.U(REN_LEN))
  val wb_reg_wb_data = RegInit(0.U(WORD_LEN_WIDTH))

  // Instruction Fetch (IF) Stage
  val if_pc_reg = RegInit(START_ADDR)
  io.imem.inst_addr := if_pc_reg
  val if_inst = io.imem.inst_o
  val alu_out = Wire(UInt(WORD_LEN_WIDTH))
  val br_flag = Wire(Bool())
  val br_target = Wire(UInt(WORD_LEN_WIDTH))
  val jmp_flag = Wire(Bool())
  val pc_next = MuxCase(if_pc_reg+4.U(WORD_LEN_WIDTH), Seq(
    br_flag    -> br_target,
    jmp_flag   -> alu_out,
    (if_inst === CSR_ECALL)-> csr_register(0x305),
  ))
  if_pc_reg := pc_next
  // io.ce := (if_inst === 0x13136f97.U(WORD_LEN_WIDTH))

  // 连接寄存器两边
  id_reg_pc := if_pc_reg
  id_reg_inst := if_inst

  // Instruction Decode (ID) Stage
  // 取出立即数
  val rs1_addr = id_reg_inst(19, 15)
  val rs2_addr = id_reg_inst(24, 20)
  val wb_addr = id_reg_inst(11, 7)
  val rs1_data = Mux(rs1_addr =/= 0.U(WORD_LEN_WIDTH), registers(rs1_addr), 0.U(WORD_LEN_WIDTH))
  val rs2_data = Mux(rs2_addr =/= 0.U(WORD_LEN_WIDTH), registers(rs2_addr), 0.U(WORD_LEN_WIDTH))
  val imm_i = id_reg_inst(31, 20)
  val imm_i_sext = Cat(Fill(20, imm_i(11)), imm_i)
  val imm_s = Cat(id_reg_inst(31, 25), id_reg_inst(11, 7))
  val imm_s_sext = Cat(Fill(20, imm_s(11)), imm_s)
  val imm_b = Cat(id_reg_inst(31), id_reg_inst(7), id_reg_inst(30, 25), id_reg_inst(11, 8))
  val imm_b_sext = Cat(Fill(19, imm_b(11)), imm_b, 0.U(1.U))
  val imm_j = Cat(id_reg_inst(31), id_reg_inst(19, 12), id_reg_inst(20), id_reg_inst(30, 21))
  val imm_j_sext = Cat(Fill(11, imm_j(19)), imm_j, 0.U(1.U))
  val imm_u = id_reg_inst(31, 12)
  val imm_u_shifted = Cat(imm_u, Fill(12, 0.U))
  val imm_z = id_reg_inst(19, 15)
  val imm_z_uext = Cat(Fill(27, 0.U), imm_z)

  // 译码，分析指令
  val decoded_inst = ListLookup(id_reg_inst, List(ALU_X, OP1_X, OP2_X, MEN_X, REN_X, WB_X, CSR_X), Array(
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
    CSR_RC_I  -> List(ALU_NOP_CSR, OP1_IM_Z, OP2_X, MEN_X, REN_S, WB_CSR, CSR_C),
    CSR_ECALL -> List(ALU_X,       OP1_X,    OP2_X, MEN_X, REN_X, WB_X,   CSR_E)
  ))
  val exe_fun::op1_sel::op2_sel::mem_wen::rf_wen::wb_sel::csr_cmd::Nil = decoded_inst

  // 操作数1
  val op1_data = MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (op1_sel === OP1_RS)   -> rs1_data,
    (op1_sel === OP1_PC)   -> id_reg_pc,
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

  val csr_addr = Mux(csr_cmd === CSR_E, 0x342.U(CSR_REG_LEN), id_reg_inst(31, 20))

  // 连接两边寄存器
  exe_reg_pc := id_reg_pc
  exe_reg_op1_data := op1_data
  exe_reg_op2_data := op2_data
  exe_reg_rs2_data := rs2_data
  exe_reg_wb_addr := wb_addr
  exe_reg_rf_wen := rf_wen
  exe_reg_exe_fun := exe_fun
  exe_reg_wb_sel := wb_sel
  exe_reg_imm_i_sext := imm_i_sext
  exe_reg_imm_s_sext := imm_s_sext
  exe_reg_imm_b_sext := imm_b_sext
  exe_reg_imm_u_shifted := imm_u_shifted
  exe_reg_imm_z_uext := imm_z_uext
  exe_reg_csr_addr := csr_addr
  exe_reg_csr_cmd := csr_cmd
  exe_reg_mem_wen := mem_wen


  // Excute (EX) Stage
  val inv_one = Cat(Fill(WORD_LEN-1, 1.U(1.W)), 0.U(1.U))

  // 算术逻辑运算
  alu_out := MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (exe_reg_exe_fun === ALU_ADD)     -> (exe_reg_op1_data + exe_reg_op2_data),
    (exe_reg_exe_fun === ALU_SUB)     -> (exe_reg_op1_data - exe_reg_op2_data),
    (exe_reg_exe_fun === ALU_AND)     -> (exe_reg_op1_data & exe_reg_op2_data),
    (exe_reg_exe_fun === ALU_OR)      -> (exe_reg_op1_data | exe_reg_op2_data),
    (exe_reg_exe_fun === ALU_XOR)     -> (exe_reg_op1_data ^ exe_reg_op2_data),
    (exe_reg_exe_fun === ALU_SLL)     -> (exe_reg_op1_data << exe_reg_op2_data(4, 0)).asUInt,
    (exe_reg_exe_fun === ALU_SRL)     -> (exe_reg_op1_data >> exe_reg_op2_data(4, 0)).asUInt,
    (exe_reg_exe_fun === ALU_SRA)     -> (exe_reg_op1_data.asSInt >> exe_reg_op2_data(4, 0)).asUInt,
    (exe_reg_exe_fun === ALU_SLT)     -> (exe_reg_op1_data.asSInt < exe_reg_op2_data.asSInt).asUInt,
    (exe_reg_exe_fun === ALU_SLTU)    -> (exe_reg_op1_data < exe_reg_op2_data).asUInt,
    (exe_reg_exe_fun === ALU_JALR)    -> ((exe_reg_op1_data + exe_reg_op2_data) & inv_one),
    (exe_reg_exe_fun === ALU_NOP_CSR) -> (exe_reg_op1_data)
  ))

  // 跳转相关
  br_flag := MuxCase(false.asBool, Seq(
    (exe_reg_exe_fun === BR_BEQ)   -> (exe_reg_op1_data === exe_reg_op2_data),
    (exe_reg_exe_fun === BR_BNE)   -> (exe_reg_op1_data =/= exe_reg_op2_data),
    (exe_reg_exe_fun === BR_BLTU)  -> (exe_reg_op1_data < exe_reg_op2_data),
    (exe_reg_exe_fun === BR_BLT)   -> (exe_reg_op1_data.asSInt < exe_reg_op2_data.asSInt),
    (exe_reg_exe_fun === BR_BGEU)  -> (exe_reg_op1_data >= exe_reg_op2_data),
    (exe_reg_exe_fun === BR_BGE)   -> (exe_reg_op1_data.asSInt >= exe_reg_op2_data.asSInt)
  ))
  br_target := exe_reg_pc + exe_reg_imm_b_sext

  jmp_flag := (exe_reg_wb_sel === WB_PC)

  // 连接两边的寄存器
  mem_reg_pc := exe_reg_pc
  mem_reg_op1_data := exe_reg_op1_data
  mem_reg_rs2_data := exe_reg_rs2_data
  mem_reg_wb_addr := exe_reg_wb_addr
  mem_reg_alu_out := alu_out
  mem_reg_rf_wen := exe_reg_rf_wen
  mem_reg_wb_sel := exe_reg_wb_sel
  mem_reg_csr_addr := exe_reg_csr_addr
  mem_reg_csr_cmd := exe_reg_csr_cmd
  mem_reg_imm_z_uext := exe_reg_imm_z_uext
  mem_reg_mem_wen := exe_reg_mem_wen


  // Memory Access Stage

  io.wbio.wdata := mem_reg_alu_out
  io.wbio.write_en := mem_reg_mem_wen
  io.wbio.wdata := mem_reg_rs2_data

  // CSR: 取数和写数
  val csr_rdata = csr_register(mem_reg_csr_addr)
  val csr_wdata = MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (mem_reg_csr_cmd === CSR_W) -> mem_reg_op1_data,
    (mem_reg_csr_cmd === CSR_S) -> (mem_reg_op1_data | csr_rdata),
    (mem_reg_csr_cmd === CSR_C) -> ((~mem_reg_op1_data).asUInt & csr_rdata),
    (mem_reg_csr_cmd === CSR_E) -> 11.U(WORD_LEN_WIDTH)
  ))
  when(mem_reg_csr_cmd > 0.U(CSR_LEN)) {
    csr_register(csr_addr) := csr_wdata
  }

  val mem_wb_data = MuxCase(mem_reg_alu_out, Seq(
    (mem_reg_wb_sel === WB_MEM) -> io.wbio.rdata, // 将从mem中读到的数据作为要写入的data
    (mem_reg_wb_sel === WB_PC)  -> (mem_reg_pc + 4.U(WORD_LEN_WIDTH)),
    (mem_reg_wb_sel === WB_CSR) -> csr_rdata
  ))


  // 连接两边的寄存器
  wb_reg_wb_addr := mem_reg_wb_addr
  wb_reg_rf_wen := mem_reg_rf_wen
  wb_reg_wb_data := mem_wb_data


  //  Writeback (WB) Stage

  when (rf_wen === REN_S){
    registers(wb_addr) := wb_reg_wb_data
  }
}
