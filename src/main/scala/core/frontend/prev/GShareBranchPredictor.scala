package core.frontend

import chisel3._
import chisel3.util.Cat

class GShareBranchPredictor(historyBits: Int, tableSize: Int) extends Module {
  val io = IO(new Bundle {
    val pc = Input(UInt(32.W))
    val branch = Input(Bool())
    val taken = Output(Bool())
  })

  val historyReg = RegInit(0.U(historyBits.W))
  val globalHistory = historyReg(historyBits - 1, 0)

  val historyIndex = globalHistory ^ io.pc(1, 0)
  val table = RegInit(VecInit(Seq.fill(tableSize)(false.B)))

  val prediction = table(historyIndex)

  when(io.branch) {
    when(prediction === io.taken) {
      table(historyIndex) := prediction
    }.otherwise {
      table(historyIndex) := io.taken
    }
    historyReg := Cat(globalHistory, io.taken)
  }

  io.taken := prediction
}

