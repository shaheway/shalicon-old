package core.frontend
import chisel3._
import chisel3.util.{Decoupled, Queue}
import common.{CtrlFlowIO, InstFetchIO}
import core.CoreConfig

class IBuffer extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val flush = Input(Bool())
    val in = Flipped(Decoupled(new InstFetchIO))
    val out = Vec(2, Decoupled(new CtrlFlowIO))
  })
//  val instBundle = new Bundle() {
//    val pc = WireInit(0.U(addrwidth))
//    val predict_nextpc = WireInit(0.U(addrwidth))
//    val branchIdx = WireInit(0.U(4.W))
//    val instValid = WireInit(0.U(4.W))
//  }
  val instBundle = new Bundle() {
    val pc = UInt(addrwidth)
    val predict_nextpc = UInt(addrwidth)
    val branchIdx = UInt(4.W)
    val instValid = UInt(4.W)
  }

  val instQueue = Module(new Queue(instBundle, entries = 8))
  instQueue.io.enq <> io.in
  instQueue.io.deq <> io.out
}
