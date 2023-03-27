package core.frontend
import chisel3._
import chisel3.util
import chisel3.util.Decoupled
import common.{CtrlFlowIO, RedirectIO}
import core.CoreConfig

class Fetch extends Module with CoreConfig {
  // Fetch instructions in order.
  val io = IO(new Bundle() {
    val imem = new bus
    val out = Decoupled(new CtrlFlowIO)
    val redirect = Flipped(new RedirectIO)
  })
  val pc = RegInit(resetVector)
  val pc_update = io.redirect.valid || io.imem.req.fire
  val sequential_nextpc = pc + 4.U

  // predicted next pc
  val bp = Module(new BranchPredict)
  val predicted_nextpc = Mux(bp.io.crosslineJump, sequential_nextpc, bp.io.out.target)
  val nextpc = Mux(io.redirect.valid, io.redirect.target, Mux(bp.io.out.valid, predicted_nextpc, sequential_nextpc))
  pc := nextpc

  io.out.bits.instruction = io.imem.response.bits.rdata
  io.out.bits.pc := pc
  io.out.bits.predict_nextpc := predicted_nextpc
  io.out.valid := io.imem.response.valid

}
