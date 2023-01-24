package core.fetch
import chisel3._
import common.Defines

class FetchOutBundle extends Bundle {
  val instruction_address = Output(UInt(Defines.instAddrWidth))
  val instruction_id = Output(UInt(Defines.instructionWidth))
}
