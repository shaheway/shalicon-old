package core.clint
import chisel3._

object CSRState {
  val idle = 0x0.U(2.W)
  val traping = 0x1.U(2.W)
  val mret = 0x2.U(2.W)
}
