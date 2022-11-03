package connect
import chisel3._
import common.Defines._
class RegReadIO(WIDTH: Int) extends Bundle {
  val reg_raddr1 = Input(UInt(WIDTH.W))
  val reg_raddr2 = Input(UInt(WIDTH.W))
  val reg_rdata1 = Output(UInt(WORD_LEN_WIDTH))
  val reg_rdata2 = Output(UInt(WORD_LEN_WIDTH))
}
