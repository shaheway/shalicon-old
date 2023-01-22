package peripheral.memory
import chisel3._
import core.common.Defines

class RAMBundle extends Bundle{
  val memAccessAddr = Input(UInt(Defines.dataAddrWidth))
  val dataWriteData = Input(UInt(Defines.dataWidth))
  val dataWriteType = Input(UInt(3.W))
  val memWriteEnable = Input(Bool())
  val dataReadResult = Output(UInt(Defines.dataWidth))
}
