package core.alu
import chisel3._
import core.common.Defines
object AluopType {
  val nop = 0x0.U(Defines.aluopTypeWidth)
  val add = 0x1.U(Defines.aluopTypeWidth)
  val sub = 0x2.U(Defines.aluopTypeWidth)
  val or = 0x3.U(Defines.aluopTypeWidth)
  val xor = 0x4.U(Defines.aluopTypeWidth)
  val and = 0x5.U(Defines.aluopTypeWidth)
  val sll = 0x6.U(Defines.aluopTypeWidth)
  val srl = 0x7.U(Defines.aluopTypeWidth)
  val sra = 0x8.U(Defines.aluopTypeWidth)
  val slt = 0x9.U(Defines.aluopTypeWidth)
  val sltu = 0xa.U(Defines.aluopTypeWidth)
  val copy = 0xb.U(Defines.aluopTypeWidth)
  val inc = 0xc.U(Defines.aluopTypeWidth)
  val addw = 0xd.U(Defines.aluopTypeWidth)
  val subw = 0xe.U(Defines.aluopTypeWidth)
  val sllw = 0xf.U(Defines.aluopTypeWidth)
  val srlw = 0x10.U(Defines.aluopTypeWidth)
  val sraw = 0x11.U(Defines.aluopTypeWidth)
}
