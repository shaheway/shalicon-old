package core.frontend

import chisel3._
import common.CoreConfig
import chisel3.util.{MuxCase, MuxLookup}

class GrenewIO(indicatorLen: Int = 13) extends Bundle {
  val pc_indicator = Input(UInt(indicatorLen.W))
  val actual = Input(Bool())
  val predict = Input(Bool())
}
class GshareIO(indicatorLen: Int = 13) extends Bundle {
  val pc_indicator = Input(UInt(indicatorLen.W))
  val predict = Output(Bool())
  val grenew = new GrenewIO(indicatorLen = indicatorLen)
}

class Gshare extends Module with CoreConfig{
  val io = IO(new Bundle() {
    val gio = new GshareIO(indicatorLen = 13)
  })

  val shift_reg = RegInit(0.U(dataWidth))

  val fsm = VecInit(Seq.fill(dataLength)(0.U(2.W)))

  val fsm_target = io.gio.pc_indicator ^ shift_reg(12, 0)

  val not_taken = false.B
  val taken = true.B

  io.gio.predict := MuxLookup(fsm(fsm_target), not_taken, IndexedSeq(
    /* 0.U(2.W) and 1.U(2.W) is not_taken by default */
    2.U(2.W) -> taken,
    3.U(3.W) -> taken
  ))

  val update_target = io.gio.grenew.pc_indicator ^ shift_reg(12, 0)
  fsm(update_target) := Mux(io.gio.grenew.actual =/= io.gio.grenew.predict, MuxLookup(
    fsm(update_target), 0.U(2.W), IndexedSeq(
      0.U(2.W) -> 1.U(2.W),
      1.U(2.W) -> 2.U(2.W),
      2.U(2.W) -> 1.U(2.W),
      3.U(2.W) -> 2.U(2.W)
    )
  ), fsm(update_target))

}
