package core.pipeline.regs

import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}
import core.decode.DecodeOutBundle
import core.pipeline.PipelineReg

class Rid2ex extends Module {
  val io = IO(new Bundle() {
    val flushEnable = Input(Bool())
    val in = Flipped(new DecodeOutBundle)
    val out2ex = Decoupled(new DecodeOutBundle)
  })

  // Pipeline bus
  val outport = io.out2ex
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
  io.out2ex.bits.memReadEnable := memReadEnable.io.out

  val memReadType = new PipelineReg(width = 3.W)
  memReadType.io.writeEnable := pRegWriteEnable
  memReadType.io.flushEnable := io.flushEnable
  memReadType.io.in := io.in.memReadType
  io.out2ex.bits.memReadType := memReadType.io.out

  val memWriteType = new PipelineReg(width = 3.W)
  memWriteType.io.writeEnable := pRegWriteEnable
  memWriteType.io.flushEnable := io.flushEnable
  memWriteType.io.in := io.in.memWriteType
  io.out2ex.bits.memWriteType := memWriteType.io.out


}
