package core.clint
import chisel3._

object InterruptStatus {
  val none = 0x0.U(8.W)
  val timer0 = 0x1.U(8.W)
  val ret = 0xff.U(8.W)
}
