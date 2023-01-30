package core.frontend
import chisel3._
import chisel3.util.{Decoupled, Queue}
import common.{InstFetchIO, InstFlowIO}
import core.CoreConfig
class IBufferInstInIO extends Bundle with CoreConfig {
  val pc = UInt(addrwidth)
  val instruction = UInt(instwidth)
}
class IBuffer extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val flush = Input(Bool())
    val in = Flipped(Decoupled(new InstFetchIO))
    val out = Vec(2, Decoupled(new InstFlowIO))
    val rob =
  })
//  val instBundle = new Bundle() {
//    val pc = WireInit(0.U(addrwidth))
//    val predict_nextpc = WireInit(0.U(addrwidth))
//    val branchIdx = WireInit(0.U(4.W))
//    val instValid = WireInit(0.U(4.W))
//  }
  val cur_instBundle = Wire(new IBufferInstInIO)
  val pnext_instBundle = Wire(new IBufferInstInIO)

  cur_instBundle.pc := io.in.bits.cur_pc
  cur_instBundle.instruction := io.in.bits.cur_instruction
  pnext_instBundle.pc := io.in.bits.pnext_pc
  pnext_instBundle.instruction := io.in.bits.pnext_instruction

  val instQueue0 = Module(new Queue(new IBufferInstInIO, entries = 8))
  val instQueue1 = Module(new Queue(new IBufferInstInIO, entries = 8))

  instQueue0.io.enq <> cur_instBundle
  instQueue1.io.enq <> pnext_instBundle
  instQueue0.io.deq <> io.out(0)
  instQueue1.io.deq <> io.out(1)
}
