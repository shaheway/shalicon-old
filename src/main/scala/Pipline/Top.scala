package Pipline
import chisel3._
import chisel3.stage.ChiselStage
import common.Defines._
class Top extends Module {
  val module_if = new InstFetch()
}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}