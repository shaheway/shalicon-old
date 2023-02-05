package core.backend.funcU
import chisel3._

object FunctUType {
  val functUTypeLen = 3.W
  val alu = 0x0.U(functUTypeLen)
  val csru = 0x1.U(functUTypeLen)
  val lsu = 0x2.U(functUTypeLen)
  val mou = 0x3.U(functUTypeLen)
  val fpu = 0x4.U(functUTypeLen)
  val imul = 0x5.U(functUTypeLen)
  val idiv = 0x6.U(functUTypeLen)
}
