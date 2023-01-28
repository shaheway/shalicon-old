package core.frontend.decode

import chisel3._

object RWtypeFunct3 {
  val addw = 0x0.U(3.W)
  val subw = 0x0.U(3.W)
  val sllw = 0x1.U(3.W)
  val srlw = 0x5.U(3.W)
  val sraw = 0x5.U(3.W)
}
