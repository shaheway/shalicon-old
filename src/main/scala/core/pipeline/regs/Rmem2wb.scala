package core.pipeline.regs
import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}
import core.mem.MemOutBundle
import core.pipeline.PipelineReg

class Rmem2wb extends Module {
  val io = IO(new Bundle() {
    val flushEnable = Input(Bool())
    val in = Flipped(new MemOutBundle)
    val out2wb = Decoupled(new MemOutBundle)
  })

  // Pipeline bus
  val outport = io.out2wb
  val idle :: busy :: Nil = Enum(2)
  val state = RegInit(idle)
  state := MuxLookup(state, idle, IndexedSeq(
    idle -> Mux(outport.valid, busy, idle),
    busy -> Mux(outport.fire, idle, busy) // fire = valid & ready
  ))
  val valid = RegInit(true.asBool)
  outport.valid := valid

  val pRegWriteEnable = MuxLookup(state, false.asBool, IndexedSeq(
    idle -> true.asBool,
    busy -> false.asBool
  ))

  val regWriteEnable = new PipelineReg(width = 1.W)
  regWriteEnable.io.writeEnable := pRegWriteEnable
  regWriteEnable.io.flushEnable := io.flushEnable
  regWriteEnable.io.in := io.in.regWriteEnable
  io.out2wb.bits.regWriteEnable := regWriteEnable.io.out

}
