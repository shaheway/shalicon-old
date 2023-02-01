package core.mem
import chisel3._
import common.Defines

class MemOutBundle extends Bundle {
  val regWriteEnable = Output(Bool())
  val regWriteData = Output(UInt(Defines.dataWidth))
  val regWriteDest = Output(UInt(Defines.regAddrWidth))
  //    val csrAddr_out = Output(UInt(Defines.csrAddrWidth))
  val csrWriteEnable = Output(UInt(Defines.dataWidth))
  val csrWriteData = Output(UInt(Defines.dataWidth))
  val csrWriteAddr = Output(UInt(Defines.csrAddrWidth))
}
