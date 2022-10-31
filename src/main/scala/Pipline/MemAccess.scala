package Pipline
import chisel3._
import chisel3.util.MuxCase
import common.Defines._
import connect.{CsrIO, ExMemIO}
class MemAccess extends Module {
  val io = IO(new Bundle() {
    val extend = Flipped(new ExMemIO)
    val csr = Flipped(new CsrIO(CSR_REG_LEN))
  })

  // 连接execute与memory access阶段
  io.wbio.wdata := mem_reg_alu_out
  io.wbio.write_en := mem_reg_mem_wen
  io.wbio.wdata := mem_reg_rs2_data

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
