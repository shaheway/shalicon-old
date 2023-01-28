package core.frontend
import chisel3.{Mux, _}
import chisel3.util.{Cat, Decoupled, Fill, MuxCase, MuxLookup}
import common.{CtrlFlowIO, DecodeOutIO, Defines}
import core.CoreConfig
import core.alu.AluopType

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

class Decoder extends Module with CoreConfig{
  val io = IO(new Bundle() {
    val in = Flipped(Decoupled(new CtrlFlowIO))
    val out = Decoupled(new DecodeOutIO)
    val isBranch = Output(Bool())
  })

  val instruction = io.in.bits.instruction
  val pc = io.in.bits.pc
  val opcode = instruction(6, 0)
  val rd = instruction(11, 7)
  val funct3 = instruction(14, 12)
  val rs1 = instruction(19, 15)
  val rs2 = instruction(24, 20)
  val funct7 = instruction(31, 25)
  val imm_i = Cat(Fill(52, instruction(31)), instruction(31, 20))
  val imm_s = Cat(Fill(52, instruction(31)), instruction(31, 25), instruction(11, 8), instruction(7))
  val imm_b = Cat(Fill(52, instruction(31)), instruction(7), instruction(30, 25), instruction(11, 8), 0.U(1.W))
  val imm_u = Cat(Fill(32, instruction(31)), instruction(31, 12), 0.U(12.W))
  val imm_j = Cat(Fill(32, instruction(31)), instruction(31), instruction(19, 12), instruction(20), instruction(30, 21), 0.U(1.W))
  val imm_z = Cat(0.U(59.W), instruction(19, 15))

  val immediate = MuxLookup(
    opcode,
    Cat(Fill(52, instruction(31)), instruction(31, 20)),
    IndexedSeq(
      InstructionType.I -> imm_i,
      InstructionType.IW -> imm_i,
      InstructionType.S -> imm_s,
      InstructionType.B -> imm_b,
      InstructionType.lui -> imm_u,
      InstructionType.auipc -> imm_u,
      InstructionType.jal -> imm_j,
      InstructionType.jalr -> imm_j,
      InstructionType.csr -> imm_z
    )
  )

  val regWriteSource = MuxLookup(
    opcode,
    RegWriteSource.nop,
    IndexedSeq(
      InstructionType.R -> RegWriteSource.alu,
      InstructionType.RW -> RegWriteSource.alu,
      InstructionType.I -> RegWriteSource.alu,
      InstructionType.IW -> RegWriteSource.alu,
      InstructionType.L -> RegWriteSource.mem,
      InstructionType.B -> RegWriteSource.nop,
      InstructionType.S -> RegWriteSource.nop,
      InstructionType.jal -> RegWriteSource.nextPC,
      InstructionType.jalr -> RegWriteSource.nextPC,
      InstructionType.lui -> RegWriteSource.alu,
      InstructionType.auipc -> RegWriteSource.alu,
      InstructionType.csr -> RegWriteSource.csr
    )
  )

  val regWriteEnable = MuxLookup(
    opcode,
    false.B,
    IndexedSeq(
      InstructionType.R -> true.B,
      InstructionType.RW -> true.B,
      InstructionType.I -> true.B,
      InstructionType.IW -> true.B,
      InstructionType.L -> true.B,
      InstructionType.jal -> true.B,
      InstructionType.jalr -> true.B,
      InstructionType.lui -> true.B,
      InstructionType.auipc -> true.B,
      InstructionType.csr -> true.B
    )
  )
  val opType = MuxLookup(
    opcode,
    AluopType.nop,
    IndexedSeq(
      InstructionType.R -> MuxCase(AluopType.nop, Seq(
        (funct3 === RtypeFunct3.add && funct7 === RtypeFunct7.add) -> AluopType.add,
        (funct3 === RtypeFunct3.sub && funct7 === RtypeFunct7.sub) -> AluopType.sub,
        (funct3 === RtypeFunct3.or && funct7 === RtypeFunct7.or) -> AluopType.or,
        (funct3 === RtypeFunct3.xor && funct7 === RtypeFunct7.xor) -> AluopType.xor,
        (funct3 === RtypeFunct3.and && funct7 === RtypeFunct7.and) -> AluopType.and,
        (funct3 === RtypeFunct3.sll && funct7 === RtypeFunct7.sll) -> AluopType.sll,
        (funct3 === RtypeFunct3.slt && funct7 === RtypeFunct7.slt) -> AluopType.slt,
        (funct3 === RtypeFunct3.sltu && funct7 === RtypeFunct7.sltu) -> AluopType.sltu,
        (funct3 === RtypeFunct3.srl && funct7 === RtypeFunct7.srl) -> AluopType.srl,
        (funct3 === RtypeFunct3.sra && funct7 === RtypeFunct7.sra) -> AluopType.sra
      )),
      InstructionType.RW -> MuxCase(AluopType.nop, Seq(
        (funct3 === RWtypeFunct3.addw && funct7 === RWtypeFunct7.addw) -> AluopType.addw,
        (funct3 === RWtypeFunct3.subw && funct7 === RWtypeFunct7.subw) -> AluopType.subw,
        (funct3 === RWtypeFunct3.sllw && funct7 === RWtypeFunct7.sllw) -> AluopType.sllw,
        (funct3 === RWtypeFunct3.srlw && funct7 === RWtypeFunct7.srlw) -> AluopType.srlw,
        (funct3 === RWtypeFunct3.sraw && funct7 === RWtypeFunct7.sraw) -> AluopType.sraw
      )),
      InstructionType.I -> MuxCase(AluopType.nop, Seq(
        (funct3 === ItypeFunct3.addi) -> AluopType.add,
        (funct3 === ItypeFunct3.andi) -> AluopType.and,
        (funct3 === ItypeFunct3.ori) -> AluopType.or,
        (funct3 === ItypeFunct3.xori) -> AluopType.xor,
        (funct3 === ItypeFunct3.slli && funct7(6, 1) === ItypeFunct7.slli) -> AluopType.sll,
        (funct3 === ItypeFunct3.slti) -> AluopType.slt,
        (funct3 === ItypeFunct3.sltiu) -> AluopType.sltu,
        (funct3 === ItypeFunct3.srai && funct7(6, 1) === ItypeFunct7.srai) -> AluopType.sra,
        (funct3 === ItypeFunct3.srli && funct7(6, 1) === ItypeFunct7.srli) -> AluopType.srl
      )),
      InstructionType.IW -> MuxCase(AluopType.nop, Seq(
        (funct3 === IWtypeFunct3.addiw) -> AluopType.addw,
        (funct3 === IWtypeFunct3.slliw && funct7 === IWtypeFunct7.slliw) -> AluopType.sllw,
        (funct3 === IWtypeFunct3.srliw && funct7 === IWtypeFunct7.srliw) -> AluopType.srlw,
        (funct3 === IWtypeFunct3.sraiw && funct7 === IWtypeFunct7.sraiw) -> AluopType.sraw
      )),
      InstructionType.csr -> AluopType.copy,
      InstructionType.S -> AluopType.add,
      InstructionType.L -> AluopType.add,
      InstructionType.jal -> AluopType.inc,
      InstructionType.jalr -> AluopType.inc,
      InstructionType.lui -> AluopType.copy,
      InstructionType.auipc -> AluopType.add
    )
  )
  val memReadEnable = Mux(opcode === InstructionType.L, true.B, false.B)
  val memWriteEnable = Mux(opcode === InstructionType.S, true.B, false.B)

  io.out.bits.ctrlFlow <> io.in.bits
  io.out.bits.ctrlSignal.functU := MuxLookup(opcode, FunctUType.alu, IndexedSeq(
    InstructionType.R -> FunctUType.alu,
    InstructionType.RW -> FunctUType.alu,
    InstructionType.I -> FunctUType.alu,
    InstructionType.IW -> FunctUType.alu,
    InstructionType.L -> FunctUType.lsu,
    InstructionType.csr -> FunctUType.csru,
    InstructionType.lui -> FunctUType.alu,
    InstructionType.auipc -> FunctUType.alu
  ))

  io.out.bits.ctrlSignal.functOp := opType
  io.out.bits.ctrlSignal.reg1Addr := rs1
  io.out.bits.ctrlSignal.reg2Addr := rs2
  io.out.bits.ctrlSignal.src1Type := 
}
class Decode {

}
