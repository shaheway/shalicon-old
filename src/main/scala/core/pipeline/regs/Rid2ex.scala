package core.pipeline.regs

import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}
import common.Defines
import core.frontend.decode.DecodeOutBundle
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

  val memWriteEnable = new PipelineReg(width = 1.W)
  memWriteEnable.io.writeEnable := pRegWriteEnable
  memWriteEnable.io.flushEnable := io.flushEnable
  memWriteEnable.io.in := io.in.memWriteEnable
  io.out2ex.bits.memWriteEnable := memWriteEnable.io.out

  val regWriteEnable = new PipelineReg(width = 1.W)
  regWriteEnable.io.writeEnable := pRegWriteEnable
  regWriteEnable.io.flushEnable := io.flushEnable
  regWriteEnable.io.in := io.in.regWriteEnable
  io.out2ex.bits.regWriteEnable := regWriteEnable.io.out

  val regWriteSource = new PipelineReg(width = 3.W)
  regWriteSource.io.writeEnable := pRegWriteEnable
  regWriteSource.io.flushEnable := io.flushEnable
  regWriteSource.io.in := io.in.regWriteSource
  io.out2ex.bits.regWriteSource := regWriteSource.io.out

  val regWriteDest = new PipelineReg(width = Defines.regAddrWidth)
  regWriteDest.io.writeEnable := pRegWriteEnable
  regWriteDest.io.flushEnable := io.flushEnable
  regWriteDest.io.in := io.in.regWriteDest
  io.out2ex.bits.regWriteDest := regWriteDest.io.out

  val op1Data = new PipelineReg(width = Defines.dataWidth)
  op1Data.io.writeEnable := pRegWriteEnable
  op1Data.io.flushEnable := io.flushEnable
  op1Data.io.in := io.in.op1Data
  io.out2ex.bits.op1Data := op1Data.io.out

  val op2Data = new PipelineReg(width = Defines.dataWidth)
  op2Data.io.writeEnable := pRegWriteEnable
  op2Data.io.flushEnable := io.flushEnable
  op2Data.io.in := io.in.op2Data
  io.out2ex.bits.op2Data := op2Data.io.out

  val opType = new PipelineReg(width = Defines.aluopTypeWidth)
  opType.io.writeEnable := pRegWriteEnable
  opType.io.flushEnable := io.flushEnable
  opType.io.in := io.in.opType
  io.out2ex.bits.opType := opType.io.out

  val rs1Addr = new PipelineReg(width = Defines.regAddrWidth)
  rs1Addr.io.writeEnable := pRegWriteEnable
  rs1Addr.io.flushEnable := io.flushEnable
  rs1Addr.io.in := io.in.rs1Addr
  io.out2ex.bits.rs1Addr := rs1Addr.io.out

  val rs2Addr = new PipelineReg(width = Defines.regAddrWidth)
  rs2Addr.io.writeEnable := pRegWriteEnable
  rs2Addr.io.flushEnable := io.flushEnable
  rs2Addr.io.in := io.in.rs2Addr
  io.out2ex.bits.rs2Addr := rs2Addr.io.out

  val rs2Data = new PipelineReg(width = Defines.dataWidth)
  rs2Data.io.writeEnable := pRegWriteEnable
  rs2Data.io.flushEnable := io.flushEnable
  rs2Data.io.in := io.in.rs2Data
  io.out2ex.bits.rs2Data := rs2Data.io.out

}
