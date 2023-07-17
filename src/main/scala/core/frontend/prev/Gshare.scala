package core.frontend
import chisel3._
import chisel3.util.{Cat, Decoupled, DecoupledIO, MuxLookup}
import common.{CoreConfig, MilkyBundle, MilkyModule}
import core.CoreModule

class Fetch2Gshare extends MilkyBundle {
  val instaddr = Output(UInt(xlen))
}
class Gshare2Fetch extends MilkyBundle {
  val bpout = Output(Bool())
}
class GshareBackward extends MilkyBundle {
  val pc = Output(UInt(xlen))
  val branchResult = Output(Bool())
}
class Gshare(historyBits: Int = 10, tableSize: Int = 1024) extends CoreModule with CoreConfig {
  val io = IO(new Bundle() {
    val fetch2gshare = Flipped(Decoupled(new Fetch2Gshare))
    val gshare2fetch = Decoupled(new Gshare2Fetch)
    val backward = Flipped(Decoupled(new GshareBackward))
  })

  val history = RegInit(0.U(historyBits.W))
  val lookupDir = RegInit(Vec(tableSize, 0.U))
  val index = history ^ io.fetch2gshare.bits.instaddr(9, 0)
  val bpres = lookupDir(index)

  io.gshare2fetch.bits := MuxLookup(bpres, false.B, IndexedSeq(
    2 -> true.B,
    3 -> true.B,
  ))

  /** If backward is valid, renew the result */
  history := Mux(io.backward.valid, (history << 1).asUInt + io.backward.bits.branchResult.asUInt, history)
  val backwardIndex = history ^ io.backward.bits.pc(9, 0)
  lookupDir(backwardIndex) := Mux(io.backward.valid, MuxLookup(backwardIndex, lookupDir(backwardIndex), IndexedSeq(
    0.U -> 1.U,
    1.U -> 2.U,
    2.U -> 1.U,
    3.U -> 2.U
  )), lookupDir(backwardIndex))
}
