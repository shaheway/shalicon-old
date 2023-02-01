package core.pipeline

import chisel3._
import chisel3.internal.firrtl.Width
import common.Defines

class Ptest(width: Width = Defines.dataWidth, initVal: UInt = 0.U) extends Module {
  val io = IO(new Bundle() {
    val writeEnable = Input(Bool())
    val flushEnable = Input(Bool())
    val in = Input(UInt(width))
    val out = Output(UInt(width))
  })

  val reg = RegInit(UInt(width), initVal)
  reg := Mux(io.writeEnable, io.in, Mux(io.flushEnable, initVal, reg))
  io.out := reg
}
