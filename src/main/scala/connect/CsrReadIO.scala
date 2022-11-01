package connect
import chisel3._
import common.Defines._
class CsrReadIO(WIDTH: Int) extends Bundle {
  val reg_raddr = Input(UInt(WIDTH.W))
  val reg_rdata = Output(UInt(WORD_LEN_WIDTH))
}