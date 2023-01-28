package core.decode

import chisel3._
import common.Defines

class DecodeOutBundle extends Bundle{
  val memReadEnable = Output(Bool())
  val memReadType = Output(UInt(3.W))
  val memWriteType = Output(UInt(3.W))
  val memWriteEnable = Output(Bool())
  val regWriteEnable = Output(Bool())
  val regWriteSource = Output(UInt(3.W))
  val regWriteDest = Output(UInt(Defines.regAddrWidth))
  val op1Data = Output(UInt(Defines.dataWidth))
  val op2Data = Output(UInt(Defines.dataWidth))
  val opType = Output(UInt(Defines.aluopTypeWidth))
  val rs1Addr = Output(UInt(Defines.regAddrWidth)) // for forward use
  val rs2Addr = Output(UInt(Defines.regAddrWidth))
  val rs2Data = Output(UInt(Defines.dataWidth))
  val allowForward1 = Output(Bool())
  val allowForward2 = Output(Bool())
  val allowForwardrs2 = Output(Bool())
  val csrReadData = Output(UInt(Defines.dataWidth))
  val csrWriteEnable = Output(UInt(Defines.dataWidth))
  val csrWriteDest = Output(UInt(Defines.csrAddrWidth))
  val csrType = Output(UInt(3.W))
}
