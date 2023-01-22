package core.hazard
import chisel3._
object HazardType {
  val NoneForward = 0.U(2.W)
  val ForwardFromMem = 1.U(2.W)
  val ForwardFromWb = 2.U(2.W)
  val stall = 3.U(2.W)
}
