package Pipline
import chisel3._
import common.Defines._
import connect.{CsrReadIO, CsrWriteIO}
class CSR extends Module {
  val io = IO(new Bundle() {
    val read1IO = new CsrReadIO(CSR_REG_LEN)
    val read2IO = new CsrReadIO(CSR_REG_LEN)
    val writeIO = new CsrWriteIO(CSR_REG_LEN)
  })
  // 状态寄存器
  val csr_register = Mem(4096, UInt(WORD_LEN_WIDTH))
  // 读出寄存器中的数
  io.read1IO.reg_rdata := csr_register(io.read1IO.reg_raddr)
  io.read2IO.reg_rdata := csr_register(io.read2IO.reg_raddr)
  // 写回寄存器
  when(io.writeIO.wen) {
    csr_register(io.writeIO.reg_waddr) := io.writeIO.reg_wdata
  }
}
