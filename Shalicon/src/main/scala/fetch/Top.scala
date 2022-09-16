package fetch
import chisel3._
import chisel3.stage.ChiselStage
import common.Defines._
class Top extends Module {
  val io = IO(new Bundle() {
    val ce = Output(Bool())
  })
  val CORE = Module(new Core)
  val MEM = Module(new Memory)
  CORE.io.imem <> MEM.io.imem
  CORE.io.wbio <> MEM.io.wbio
  io.ce := CORE.io.ce
}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}