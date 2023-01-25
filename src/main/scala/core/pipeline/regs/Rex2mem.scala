package core.pipeline.regs
import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}
import core.alu.AluOutBundle
import core.pipeline.PipelineReg

class Rex2mem extends Module {
  val io = IO(new Bundle() {
    val flushEnable = Input(Bool())
    val in = Flipped(new AluOutBundle)
    val out2mem = Decoupled(new AluOutBundle)
  })

  // Pipeline bus
  val outport = io.out2mem
  val idle :: busy :: Nil = Enum(2)
  val state = RegInit(idle)
  state := MuxLookup(state, idle, IndexedSeq(
    idle -> Mux(outport.valid, busy, idle),
    busy -> Mux(outport.fire, idle, busy) // fire = valid & ready
  ))

  val pRegWriteEnable = MuxLookup(state, false.B, IndexedSeq(
    idle -> true.B,
    busy -> false.B
  ))

  val memReadEnable = new PipelineReg(width = 1.W)
  memReadEnable.io.writeEnable := pRegWriteEnable
  memReadEnable.io.flushEnable := io.flushEnable
  memReadEnable.io.in := io.in.memReadEnable
  io.out2mem.bits.memReadEnable := memReadEnable.io.out


}
