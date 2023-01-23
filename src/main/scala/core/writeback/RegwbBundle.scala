package core.writeback
import chisel3._
import common.Defines

class RegwbBundle extends Bundle {
  val regWriteAddr = Output(UInt(Defines.regAddrWidth))
  val regWriteEnable = Output(Bool())
  val regWriteData = Output(UInt(Defines.dataWidth))
}
