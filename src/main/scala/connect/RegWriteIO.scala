package connect
import chisel3._
import common.Defines._
class RegWriteIO(WIDTH: Int) extends Bundle {
  val reg_waddr = Input(UInt(WIDTH.W))
  val reg_wdata = Input(UInt(WORD_LEN_WIDTH))
  val wen = Input(Bool())
}

