package core.regs
import chisel3._
import common.Defines

object IndexedCSR {
  val mstatus = 0x300.U(Defines.csrAddrWidth)
  val mie = 0x304.U(Defines.csrAddrWidth)
  val mtvec = 0x305.U(Defines.csrAddrWidth)
  val mscratch = 0x340.U(Defines.csrAddrWidth)
  val mepc = 0x341.U(Defines.csrAddrWidth)
  val mcause = 0x342.U(Defines.csrAddrWidth)

}
