package core.frontend.decode

import chisel3._

object CSRTypeFunct3 {
  val csrrw = 0x1.U(3.W)
  val csrrs = 0x2.U(3.W)
  val csrrc = 0x3.U(3.W)
  val csrrwi = 0x5.U(4.W)
  val csrrsi = 0x6.U(5.W)
  val csrrci = 0x7.U(3.W)
}
