package core.decode
import chisel3._
import core.common.Defines

object PrivilegedISA {
  val sret = 0x10200073.U(Defines.instructionWidth)
  val mret = 0x30200073.U(Defines.instructionWidth)
}
