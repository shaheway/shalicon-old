package core.frontend
import chisel3._

class MemReq extends Bundle {
  val addr = Input(UInt(32.W))
  val ready = Output(Bool())
  val fetchCount = Input(UInt(2.W))
}

class MemResp extends Bundle {
  val data = Output(Vec(2, UInt(32.W)))
  val valid = Output(Bool())
}

import chisel3._
import chisel3.util._

class RiscvProcessor extends Module {
  val io = IO(new Bundle {
    val memReq = Flipped(new MemReq)
    val memResp = new MemResp
    val decoded = Output(Vec(2, new DecodedInstruction))
  })

  val cache = Module(new Cache)
  val predictor = Module(new GShareBranchPredictor(2, 1024))

  cache.io.addr := io.memReq.addr
  io.memResp.data := cache.io.dataOut

  val pcReg = RegInit(0.U(32.W))
  val pcNext = Mux(predictor.io.taken, pcReg + 4.U, pcReg + 8.U)

  predictor.io.pc := pcReg
  predictor.io.branch := (io.memReq.addr =/= pcNext)

  pcReg := pcNext

  when(io.memReq.ready) {
    when(io.memReq.fetchCount === 0.U) {
      io.memReq.ready := true.B
    }.otherwise {
      io.memReq.ready := false.B
    }
  }.otherwise {
    io.memReq.ready := false.B
  }

  val fetchCountReg = RegInit(0.U(2.W))
  val instructions = Reg(Vec(2, UInt(32.W)))
  val decodedInstructions = Wire(Vec(2, new DecodedInstruction))

  when(io.memReq.ready && io.memResp.valid) {
    fetchCountReg := io.memReq.fetchCount
    instructions(0) := io.memResp.data(0)
    instructions(1) := io.memResp.data(1)
  }.otherwise {
    fetchCountReg := 0.U
  }

  io.memResp.data := instructions
  io.memResp.valid := fetchCountReg =/= 0.U

  // Instruction decoding logic
  for (i <- 0 until 2) {
    val decoded = Module(new InstructionDecoder)
    decoded.io.instruction := instructions(i)
    decodedInstructions(i) := decoded.io.decoded
  }

  io.decoded := decodedInstructions
}
