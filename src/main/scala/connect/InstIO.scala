package connect

import chisel3.{Bundle, Input, Output, UInt}
import common.Defines.WORD_LEN_WIDTH

class InstIO extends Bundle {
  val inst_addr = Input(UInt(WORD_LEN_WIDTH)) // 指令地址
  val inst_o = Output(UInt(WORD_LEN_WIDTH)) // 输出指令
}