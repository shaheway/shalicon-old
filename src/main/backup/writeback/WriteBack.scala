package core.writeback

import chisel3._
import common.Defines
import core.mem.MemOutBundle

class WriteBack extends Module{
  val io = IO(new Bundle() {
//    val regWriteEnable_in = Input(Bool())
//    val regWriteData_in = Input(UInt(Defines.dataWidth))
//    val regWriteDest_in = Input(UInt(Defines.regAddrWidth))
//    val regWriteAddr = Output(UInt(Defines.regAddrWidth))
//    val regWriteData = Output(UInt(Defines.dataWidth))
//    val regWriteEnable = Output(Bool())
    val in = Flipped(new MemOutBundle)
    val regBundle = new RegwbBundle
    val csrBundle = new CSRwbBundle
  })

  io.regBundle.regWriteAddr := io.in.regWriteDest
  io.regBundle.regWriteData := io.in.regWriteData
  io.regBundle.regWriteEnable := io.in.regWriteEnable

  io.csrBundle.csrWriteEnable := io.in.csrWriteEnable
  io.csrBundle.csrWriteAddr := io.in.csrWriteAddr
  io.csrBundle.csrWriteData := io.in.csrWriteData
}
