package core.writeback

import chisel3._
import common.Defines

class WriteBack extends Module{
  val io = IO(new Bundle() {
    val regWriteEnable_in = Input(Bool())
    val regWriteData_in = Input(UInt(Defines.dataWidth))
    val regWriteDest_in = Input(UInt(Defines.regAddrWidth))
    val regWriteAddr = Output(UInt(Defines.regAddrWidth))
    val regWriteData = Output(UInt(Defines.dataWidth))
    val regWriteEnable = Output(Bool())
  })
  io.regWriteAddr := io.regWriteDest_in
  io.regWriteData := io.regWriteData_in
  io.regWriteEnable := io.regWriteEnable_in
}
