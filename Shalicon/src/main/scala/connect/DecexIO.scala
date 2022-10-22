package connect
import chisel3._
import common.Defines._
class DecexIO extends Module {
  val id_pc_reg = Output(UInt(WORD_LEN_WIDTH))

  val imm_i_sext = Output(UInt(WORD_LEN_WIDTH))
  val imm_s_sext = Output(UInt(WORD_LEN_WIDTH))
  val imm_b_sext = Output(UInt(WORD_LEN_WIDTH))
  val imm_u_shifted = Output(UInt(WORD_LEN_WIDTH))
  val imm_z_uext = Output(UInt(WORD_LEN_WIDTH))
  val op1_data = Output(UInt(WORD_LEN_WIDTH))
  val op2_data = Output(UInt(WORD_LEN_WIDTH))
  val rs2_data = Output(UInt(WORD_LEN_WIDTH))

  val wb_addr = Output(UInt(REG_ADDR_WIDTH))

  val exe_fun = Output(UInt(EXE_FUN_LEN))
  val mem_wen = Output(UInt(MEN_LEN))
  val reg_wen = Output(UInt(REN_LEN))
  val wb_sel = Output(UInt(WB_SEL_LEN))
  val csr_cmd = Output(UInt(CSR_LEN))

  val csr_addr = Output(UInt(CSR_REG_WIDTH))
}
