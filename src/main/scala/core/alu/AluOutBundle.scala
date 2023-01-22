package core.alu
import chisel3._
import common.Defines

class AluOutBundle extends Bundle {
  val memReadEnable = Output(Bool())
  val memReadType = Output(UInt(3.W))
  val memWriteType = Output(UInt(3.W))
  val memWriteEnable = Output(Bool())
  val regWriteEnable = Output(Bool())
  val regWriteSource = Output(UInt(3.W))
  val regWriteDest = Output(UInt(Defines.regAddrWidth))
  // val csrAddr_out = Output(UInt(Defines.csrAddrWidth))
  val csrWriteEnable = Output(UInt(Defines.dataWidth))
  val aluResult = Output(UInt(Defines.dataWidth))
  val rs2Data = Output(UInt(Defines.dataWidth))
}
