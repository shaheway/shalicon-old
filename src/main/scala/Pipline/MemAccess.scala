package Pipline
import chisel3._
import chisel3.util.MuxCase
import common.Defines._
import connect.{CsrIO, ExMemIO, WbIO}
class MemAccess extends Module {
  val io = IO(new Bundle() {
    val extend = Flipped(new ExMemIO)
    val csr = Flipped(new CsrIO(CSR_REG_LEN))
    val wbio = Flipped(new WbIO)
  })

  // 定义一组寄存器，连接execute与memory access阶段
  val mem_pc_reg = RegInit(0.U(WORD_LEN_WIDTH))
  val wb_addr_reg = RegInit(0.U(REG_ADDR_WIDTH))
  val op1_data_reg = RegInit(UInt(WORD_LEN_WIDTH))
  val rs2_data_reg = RegInit(UInt(WORD_LEN_WIDTH))
  val mem_wen_reg = RegInit(UInt(MEN_LEN))
  val reg_wen_reg = RegInit(UInt(REN_LEN))
  val wb_sel_reg = RegInit(UInt(WB_SEL_LEN))
  val csr_addr_reg = RegInit(UInt(CSR_REG_WIDTH))
  val csr_cmd_reg = RegInit(UInt(CSR_LEN))
  val imm_z_uext_reg = RegInit(UInt(WORD_LEN_WIDTH))
  val alu_out_reg = RegInit(UInt(WORD_LEN_WIDTH))

  mem_pc_reg := io.extend.exe_pc_reg
  wb_addr_reg := io.extend.wb_addr
  op1_data_reg := io.extend.op1_data
  rs2_data_reg := io.extend.rs2_data
  mem_wen_reg := io.extend.mem_wen
  reg_wen_reg := io.extend.reg_wen
  reg_wen_reg := io.extend.reg_wen
  wb_sel_reg := io.extend.wb_sel
  csr_addr_reg := io.extend.csr_addr
  csr_cmd_reg := io.extend.csr_cmd
  imm_z_uext_reg := io.extend.imm_z_uext
  alu_out_reg := io.extend.alu_out

  io.wbio.wdata := alu_out_reg
  io.wbio.write_en := mem_wen_reg
  io.wbio.wdata := rs2_data_reg

  // CSR: 取数和写数
  io.csr.reg_waddr :=
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
    (mem_reg_wb_sel === WB_PC) -> (mem_reg_pc + 4.U(WORD_LEN_WIDTH)),
    (mem_reg_wb_sel === WB_CSR) -> csr_rdata
  ))
}
