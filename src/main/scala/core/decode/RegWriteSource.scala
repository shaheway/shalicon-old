package core.decode

import chisel3._

object RegWriteSource {
  val nop = 0x0.U(3.W)
  val alu = 0x1.U(3.W)
  val mem = 0x2.U(3.W)
  val csr = 0x3.U(3.W)
  val nextPC = 0x4.U(3.W)
}