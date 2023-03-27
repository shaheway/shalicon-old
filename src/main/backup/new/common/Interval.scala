package common
import chisel3._

object InstructionType {
  val R = "b0110011".U(7.W)
  val I = "b0010011".U(7.W)
  val L = "b0000011".U(7.W)
  val S = "b0100011".U(7.W)
  val B = "b1100011".U(7.W)
  val E = "b1110011".U(7.W)
  val RW = "b0111011".U(7.W)
  val IW = "b0011011".U(7.W)
  val csr = "b1110011".U(7.W)
  val jal = "b1101111".U(7.W)
  val jalr = "b1100111".U(7.W)
  val lui = "b0110111".U(7.W)
  val auipc = "b0010111".U(7.W)
  val fenceI = "b0001111".U(7.W) // todo
}
object BtypeFunct3 {
  val beq = 0x0.U(3.W)
  val bne = 0x1.U(3.W)
  val blt = 0x4.U(3.W)
  val bge = 0x5.U(3.W)
  val bltu = 0x6.U(3.W)
  val bgeu = 0x7.U(3.W)
}
object CSRTypeFunct3 {
  val csrrw = 0x1.U(3.W)
  val csrrs = 0x2.U(3.W)
  val csrrc = 0x3.U(3.W)
  val csrrwi = 0x5.U(4.W)
  val csrrsi = 0x6.U(5.W)
  val csrrci = 0x7.U(3.W)
}
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
object ItypeFunct7 {
  val slli = 0x0.U(6.W)
  val srli = 0x0.U(6.W)
  val srai = 0x10.U(6.W)
}
object IWtypeFunct3 {
  val addiw = 0.U(3.W)
  val slliw = 1.U(3.W)
  val srliw = 5.U(3.W)
  val sraiw = 5.U(3.W)
}
object IWtypeFunct7 {
  val slliw = 0x0.U(7.W)
  val srliw = 0x0.U(7.W)
  val sraiw = 0x20.U(7.W)
}
object LtypeFunct3 {
  val lb = 0x0.U(3.W)
  val lh = 0x1.U(3.W)
  val lw = 0x2.U(3.W)
  val ld = 0x3.U(3.W)
  val lbu = 0x4.U(3.W)
  val lhu = 0x5.U(3.W)
  val lwu = 0x6.U(3.W)
}
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
object RtypeFunct7 {
  val add = 0x0.U(7.W)
  val sub = 0x20.U(7.W)
  val xor = 0x0.U(7.W)
  val or = 0x0.U(7.W)
  val and = 0x0.U(7.W)
  val sll = 0x0.U(7.W)
  val srl = 0x0.U(7.W)
  val sra = 0x20.U(7.W)
  val slt = 0x0.U(7.W)
  val sltu = 0x0.U(7.W)
}
object RWtypeFunct3 {
  val addw = 0x0.U(3.W)
  val subw = 0x0.U(3.W)
  val sllw = 0x1.U(3.W)
  val srlw = 0x5.U(3.W)
  val sraw = 0x5.U(3.W)
}
object RWtypeFunct7 {
  val addw = 0x0.U(7.W)
  val subw = 0x20.U(7.W)
  val sllw = 0x0.U(7.W)
  val srlw = 0x0.U(7.W)
  val sraw = 0x20.U(7.W)
}
object RegWriteSource {
  val nop = 0x0.U(3.W)
  val alu = 0x1.U(3.W)
  val mem = 0x2.U(3.W)
  val csr = 0x3.U(3.W)
  val nextPC = 0x4.U(3.W)
}
object StypeFunct3 {
  val sb = 0x0.U(3.W)
  val sh = 0x1.U(3.W)
  val sw = 0x2.U(3.W)
  val sd = 0x3.U(3.W)
}
object SrcType {
  val reg = 0x0.U(2.W)
  val imm = 0x1.U(2.W)
  val pc = 0x2.U(2.W)
}
object FunctUType {
  val functUTypeLen = 2.W
  val alu = 0x0.U(functUTypeLen)
  val csru = 0x1.U(functUTypeLen)
  val lsu = 0x2.U(functUTypeLen)
  val mou = 0x3.U(functUTypeLen)
}
object PrivilegedISA {
  val sret = 0x10200073.U(Defines.instructionWidth)
  val mret = 0x30200073.U(Defines.instructionWidth)
}
