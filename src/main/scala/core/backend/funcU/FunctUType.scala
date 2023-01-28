package core.backend.funcU
import chisel3._

object FunctUType {
  val functUTypeLen = 2.W
  val alu = 0x0.U(functUTypeLen)
  val csru = 0x1.U(functUTypeLen)
  val lsu = 0x2.U(functUTypeLen)
  val mou = 0x3.U(functUTypeLen)
}
