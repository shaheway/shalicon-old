package connect
import chisel3._
import common.Defines._
class ExIfIO extends Module {
  val alu_out = Output(UInt(WORD_LEN_WIDTH))
  val br_flag = Output(Bool())
  val br_target = Output(UInt(WORD_LEN_WIDTH))
  val jmp_flag = Output(Bool())
}
