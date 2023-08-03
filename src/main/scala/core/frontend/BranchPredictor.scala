package core.frontend
import chisel3._
import chisel3.util.MuxLookup
import common.MilkyModule

class BranchPredictor(prebit: Int) extends MilkyModule{
  val io = IO(new Bundle() {
    val instruction = Input(UInt(ilen))
    val out = Output(Bool())
  })

  val history = RegInit(0.U(prebit.W))
  val fsm = RegInit(VecInit(Seq.fill(1<<prebit)(0.U(32.W))))

  val index = history ^ io.instruction(9, 0)

  io.out := MuxLookup(fsm(index), false.B, IndexedSeq(
    2.U -> true.B,
    3.U -> true.B
  ))
}
