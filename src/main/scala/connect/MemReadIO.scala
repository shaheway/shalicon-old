package connect
import chisel3.{Bool, Bundle, Input, Output, UInt}
import common.Defines.WORD_LEN_WIDTH

class MemReadIO extends Bundle {
  val raddr = Input(UInt(WORD_LEN_WIDTH)) // 读取数据的地址
  val rdata = Output(UInt(WORD_LEN_WIDTH)) // 读出的数据
}