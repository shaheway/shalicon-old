package core.clint
import chisel3._
import common.Defines

class PrivilegedCSRBundle extends Bundle {
  val mstatus = Input(UInt(Defines.dataWidth))
  val mepc = Input(UInt(Defines.dataWidth))
  val mcause = Input(UInt(Defines.dataWidth))
  val mtvec = Input(UInt(Defines.dataWidth))

  val mstatusWriteData = Output(UInt(Defines.dataWidth))
  val mepcWriteData = Output(UInt(Defines.dataWidth))
  val mcauseWriteData = Output(UInt(Defines.dataWidth))
  val privilegedFlag = Output(Bool())
}
