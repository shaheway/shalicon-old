package core.backend.funcU

import chisel3._


object AluopType {
  val nop = 0x0.U
  val add = 0x1.U
  val sub = 0x2.U
  val or = 0x3.U
  val xor = 0x4.U
  val and = 0x5.U
  val sll = 0x6.U
  val srl = 0x7.U
  val sra = 0x8.U
  val slt = 0x9.U
  val sltu = 0xa.U
  val copy = 0xb.U
  val inc = 0xc.U
  val addw = 0xd.U
  val subw = 0xe.U
  val sllw = 0xf.U
  val srlw = 0x10.U
  val sraw = 0x11.U
}
