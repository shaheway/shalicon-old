package connect
import chisel3._
import common.Defines._
class MaWbIO extends Module {
  val reg_wb_addr = Output(UInt(REG_ADDR_WIDTH))
  val reg_wen = Output(UInt(REN_LEN))
  val reg_wb_data = Output(UInt(WORD_LEN_WIDTH))
}
