package core.decode

import chisel3._
object ItypeFunct3 {
  val addi = 0x0.U(3.W)
  val xori = 0x4.U(3.W)
  val ori = 0x6.U(3.W)
  val andi = 0x7.U(3.W)
  val slli = 0x1.U(3.W)
  val srli = 0x5.U(3.W)
  val srai = 0x5.U(3.W)
  val slti = 0x2.U(3.W)
  val sltiu = 0x3.U(3.W)
}
