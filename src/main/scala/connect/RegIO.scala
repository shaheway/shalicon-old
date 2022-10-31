package connect
import chisel3._
import common.Defines._
class RegIO(WIDTH: Int) extends Module{
  val reg_raddr1 = Input(UInt(WIDTH.W))
  val reg_raddr2 = Input(UInt(WIDTH.W))
  val reg_rdata1 = Output(UInt(WORD_LEN_WIDTH))
  val reg_rdata2 = Output(UInt(WORD_LEN_WIDTH))
  val reg_waddr = Input(UInt(WIDTH.W))
  val reg_wdata = Input(UInt(WORD_LEN_WIDTH))
  val wen = Input(Bool())
}
