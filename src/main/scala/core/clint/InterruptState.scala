package core.clint
import chisel3._

object InterruptState {
  val idle = 0x0.U(2.W)
  val syncEntry = 0x1.U(2.W)
  val asynEntry = 0x2.U(2.W)
  val mret = 0x3.U(2.W)
}
