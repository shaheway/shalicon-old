package core.decode
import chisel3._

object BtypeFunct3 {
  val beq = 0x0.U(3.W)
  val bne = 0x1.U(3.W)
  val blt = 0x4.U(3.W)
  val bge = 0x5.U(3.W)
  val bltu = 0x6.U(3.W)
  val bgeu = 0x7.U(3.W)
}
