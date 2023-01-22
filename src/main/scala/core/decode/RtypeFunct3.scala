package core.decode
import chisel3._

object RtypeFunct3 {
  val add = 0x0.U(3.W)
  val sub = 0x0.U(3.W)
  val xor = 0x4.U(3.W)
  val or = 0x6.U(3.W)
  val and = 0x7.U(3.W)
  val sll = 0x1.U(3.W)
  val srl = 0x5.U(3.W)
  val sra = 0x5.U(3.W)
  val slt = 0x2.U(3.W)
  val sltu = 0x3.U(3.W)
}