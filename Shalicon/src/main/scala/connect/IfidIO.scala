package connect
import chisel3._
import common.Defines._
class IfidIO extends Module {
  val if_pc_reg = Output(UInt(WORD_LEN_WIDTH))
  val if_inst = Output(UInt(WORD_LEN_WIDTH))
}
