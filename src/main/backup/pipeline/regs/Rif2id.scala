package core.pipeline.regs
import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}
import common.Defines
import core.fetch.FetchOutBundle
import core.pipeline.{PipeBus, PipelineReg}

class Rif2id extends Module {
  val io = IO(new Bundle() {
    val flushEnable = Input(Bool())
    val in = Flipped(new FetchOutBundle)
    val out2id = Decoupled(new FetchOutBundle)
  })

  // Pipeline bus
  val idle :: busy :: Nil = Enum(2)
  val state = RegInit(idle)
  state := MuxLookup(state, idle, IndexedSeq(
    idle -> Mux(io.out2id.valid, busy, idle),
    busy -> Mux(io.out2id.fire, idle, busy) // fire = valid & ready
  ))

  val pRegWriteEnable = MuxLookup(state, false.asBool, IndexedSeq(
    idle -> true.asBool,
    busy -> false.asBool
  ))

  val instruction_address = new PipelineReg(width = Defines.instAddrWidth)
  instruction_address.io.writeEnable := pRegWriteEnable
  instruction_address.io.flushEnable := io.flushEnable
  instruction_address.io.in := io.in.instruction_address
  io.out2id.bits.instruction_address := instruction_address.io.out

  val instruction2id = new PipelineReg(width = Defines.instructionWidth)
  instruction2id.io.writeEnable := pRegWriteEnable
  instruction2id.io.flushEnable := io.flushEnable
  instruction2id.io.in := io.in.instruction_id
  io.out2id.bits.instruction_id := instruction2id.io.out
}
