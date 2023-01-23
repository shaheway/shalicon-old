package core.writeback
import chisel3._
import common.Defines

class CSRwbBundle extends Bundle{
  val csrWriteAddr = Output(UInt(Defines.csrAddrWidth))
  val csrWriteEnable = Output(Bool())
  val csrWriteData = Output(UInt(Defines.dataWidth))
}
