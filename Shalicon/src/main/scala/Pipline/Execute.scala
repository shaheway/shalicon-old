package Pipline
import chisel3._
import chisel3.util._
import common.Defines._
import connect.{DecexIO, ExIfIO}

class Execute extends Module {
  val io = IO(new Bundle() {
    val extend = Flipped(new DecexIO)
    val exifIO = new ExIfIO
  })

  // 定义一组寄存器，将Decode和Excute连起来
  val ex_pc_reg = RegInit(0.U((EXE_FUN_LEN)))
  val exe_fun_reg = RegInit(0.U(EXE_FUN_LEN))
  val op1_data_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val op2_data_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val wb_addr_reg = RegInit(0.U(REG_ADDR_WIDTH))
  val mem_wen_reg = RegInit(0.U(MEN_LEN))
  val reg_wen_reg = RegInit(0.U(REN_LEN))
  val wb_sel_reg = RegInit(0.U(WB_SEL_LEN))
  val csr_addr_reg = RegInit(0.U(CSR_REG_LEN))
  val csr_cmd_reg = RegInit(0.U(CSR_LEN))
  val imm_i_sext_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val imm_s_sext_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val imm_b_sext_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val imm_u_shifted_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val imm_z_uext_reg = RegInit(0.U(WORD_LEN_WIDTH))

  // 寄存器连线
  ex_pc_reg := io.extend.id_pc_reg
  exe_fun_reg := io.extend.exe_fun
  op1_data_reg := io.extend.op1_data
  op2_data_reg := io.extend.op2_data
  wb_addr_reg := io.extend.wb_addr
  mem_wen_reg := io.extend.mem_wen
  reg_wen_reg := io.extend.reg_wen
  csr_addr_reg := io.extend.csr_addr
  csr_cmd_reg := io.extend.csr_cmd
  imm_i_sext_reg := io.extend.imm_i_sext
  imm_s_sext_reg := io.extend.imm_s_sext
  imm_b_sext_reg := io.extend.imm_b_sext
  imm_u_shifted_reg := io.extend.imm_u_shifted
  imm_z_uext_reg := io.extend.imm_z_uext

  val alu_out = Wire(UInt(WORD_LEN_WIDTH))
  val br_flag = Wire(Bool())
  val br_target = Wire(UInt(WORD_LEN_WIDTH))
  val jmp_flag = Wire(UInt(WORD_LEN_WIDTH))

  val inv_one = Cat(Fill(WORD_LEN-1, 1.U(1.W)), 0.U(1.U))
  // 算术逻辑运算
  alu_out := MuxCase(0.U(WORD_LEN_WIDTH), Seq(
    (exe_fun_reg === ALU_ADD) -> (op1_data_reg + op2_data_reg),
    (exe_fun_reg === ALU_SUB) -> (op1_data_reg - op2_data_reg),
    (exe_fun_reg === ALU_AND) -> (op1_data_reg & op2_data_reg),
    (exe_fun_reg === ALU_OR) -> (op1_data_reg | op2_data_reg),
    (exe_fun_reg === ALU_XOR) -> (op1_data_reg ^ op2_data_reg),
    (exe_fun_reg === ALU_SLL) -> (op1_data_reg << op2_data_reg(4, 0)).asUInt,
    (exe_fun_reg === ALU_SRL) -> (op1_data_reg >> op2_data_reg(4, 0)).asUInt,
    (exe_fun_reg === ALU_SRA) -> (op1_data_reg.asSInt >> op2_data_reg(4, 0)).asUInt,
    (exe_fun_reg === ALU_SLT) -> (op1_data_reg.asSInt < op2_data_reg.asSInt).asUInt,
    (exe_fun_reg === ALU_SLTU) -> (op1_data_reg < op2_data_reg).asUInt,
    (exe_fun_reg === ALU_JALR) -> ((op1_data_reg + op2_data_reg) & inv_one),
    (exe_fun_reg === ALU_NOP_CSR) -> (op1_data_reg)
  ))

  br_flag := MuxCase(false.asBool, Seq(
    (exe_fun_reg === BR_BEQ) -> (op1_data_reg === op2_data_reg),
    (exe_fun_reg === BR_BNE) -> (op1_data_reg =/= op2_data_reg),
    (exe_fun_reg === BR_BLTU) -> (op1_data_reg < op2_data_reg),
    (exe_fun_reg === BR_BLT) -> (op1_data_reg.asSInt < op2_data_reg.asSInt),
    (exe_fun_reg === BR_BGEU) -> (op1_data_reg >= op2_data_reg),
    (exe_fun_reg === BR_BGE) -> (op1_data_reg.asSInt >= op2_data_reg.asSInt)
  ))
  br_target := ex_pc_reg + imm_b_sext_reg

  jmp_flag := (wb_sel_reg === WB_PC)

  // 出口连线：连向取指
  io.exifIO.alu_out := alu_out
  io.exifIO.br_flag := br_flag
  io.exifIO.br_target := br_target
  io.exifIO.jmp_flag := jmp_flag
}
