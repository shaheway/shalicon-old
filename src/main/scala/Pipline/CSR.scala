package Pipline
import chisel3._
import common.Defines._
import connect.CsrIO
class CSR extends Module {
  val csrIO = new CsrIO(CSR_REG_LEN)
  // 状态寄存器
  val csr_register = Mem(4096, UInt(WORD_LEN_WIDTH))
  // 读出寄存器中的数
  csrIO.reg_rdata := csr_register(csrIO.reg_raddr)
  // 写回寄存器
  when(csrIO.wen) {
    csr_register(csrIO.reg_waddr) := csrIO.reg_wdata
  }
}
