package connect
import chisel3._
import common.Defines._
class CsrIO(WIDTH: Int) extends Module{
  val reg_raddr = Input(UInt(WIDTH.W))
  val reg_rdata = Output(UInt(WORD_LEN_WIDTH))
  val reg_waddr = Input(UInt(WIDTH.W))
  val reg_wdata = Input(UInt(WORD_LEN_WIDTH))
  val wen = Input(Bool())
}