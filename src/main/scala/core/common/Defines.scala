package core.common
import chisel3._
object Defines {
  val instAddrWidth = 64.W
  val instructionWidth = 32.W
  val dataWidth = 64.W
  val dataAddrWidth = 64.W
  val wordWidth = 32.W
  val regAddrWidth = 5.W
  val csrAddrWidth = 12.W
  val aluopTypeWidth = 5.W
}
