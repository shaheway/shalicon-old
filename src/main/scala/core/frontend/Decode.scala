package core.frontend
import chisel3.{Mux, _}
import chisel3.util.{Cat, Decoupled, Fill, MuxCase, MuxLookup}
import common.{CSRTypeFunct3, CtrlSignalIO, DecodeOutIO, FunctUType, IWtypeFunct3, IWtypeFunct7, InstructionType, ItypeFunct3, ItypeFunct7, RWtypeFunct3, RWtypeFunct7, RegWriteSource, RtypeFunct3, RtypeFunct7, SrcType}
import core.CoreConfig
import core.backend.funcU.AluopType

class Decoder extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val path = new DecoderIO
    val isBranch = Output(Bool())
  })

  val instruction = io.path.instruction
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

  val src1Type = MuxLookup(opcode, SrcType.reg, IndexedSeq(
    InstructionType.auipc -> SrcType.pc,
    InstructionType.jal -> SrcType.pc,
    InstructionType.B -> SrcType.pc,
    InstructionType.csr -> Mux(funct3 === CSRTypeFunct3.csrrci || funct3 === CSRTypeFunct3.csrrsi || funct3 === CSRTypeFunct3.csrrwi, SrcType.imm, SrcType.reg)
  ))
  val src2Type = Mux(opcode === InstructionType.R || opcode === InstructionType.RW, SrcType.reg, SrcType.imm)

  val functU = MuxLookup(opcode, FunctUType.alu, IndexedSeq(
    // InstructionType.R -> FunctUType.alu,
    // InstructionType.RW -> FunctUType.alu,
    // InstructionType.I -> FunctUType.alu,
    // InstructionType.IW -> FunctUType.alu,
    InstructionType.L -> FunctUType.lsu,
    InstructionType.csr -> FunctUType.csru,
    // InstructionType.lui -> FunctUType.alu,
    // InstructionType.auipc -> FunctUType.alu
    InstructionType.fenceI -> FunctUType.mou,
    InstructionType.E -> FunctUType.csru
  ))

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

  io.path.src1Type := src1Type
  io.path.src2Type := src2Type
  io.path.functU := functU
  io.path.functOp := opType
  io.path.reg1Addr := Mux(src1Type === SrcType.reg, rs1, 0.U)
  io.path.reg2Addr := Mux(src2Type === SrcType.reg, rs2, 0.U)
  io.path.immediate := immediate

  io.isBranch := (opcode === InstructionType.B || opcode === InstructionType.jal || opcode === InstructionType.jalr)
}
class DecoderIO extends Bundle with CoreConfig{
  val instruction = Input(UInt(instwidth))
  val src1Type = Output(UInt(2.W))
  val src2Type = Output(UInt(2.W))
  val functU = Output(UInt(2.W))
  val functOp = Output(UInt(4.W))
  val reg1Addr = Output(UInt(2.W))
  val reg2Addr = Output(UInt(2.W))
  val immediate = Output(UInt(datawidth))
}
class DecoderPath extends Bundle with CoreConfig {
  val src1Type = UInt(2.W)
  val src2Type = UInt(2.W)
  val functU = UInt(2.W)
  val functOp = UInt(4.W)
  val reg1Addr = UInt(2.W)
  val reg2Addr = UInt(2.W)
  val immediate = UInt(datawidth)
}
class DecoderPathIO extends Bundle with CoreConfig {
  val src1Type = Output(UInt(2.W))
  val src2Type = Output(UInt(2.W))
  val functU = Output(UInt(2.W))
  val functOp = Output(UInt(4.W))
  val reg1Addr = Output(UInt(2.W))
  val reg2Addr = Output(UInt(2.W))
  val immediate = Output(UInt(datawidth))
}
class DecoderIOBundle extends Bundle with CoreConfig {
  val pc = UInt(addrwidth)
  val path = new DecoderPath
  val instruction = UInt(instwidth)
}
class DecodeOutIO extends Bundle with CoreConfig {
  val pc = Output(UInt(addrwidth))
  val path = new DecoderPathIO
}
class Decode extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val in = Flipped(Decoupled(new IBuffer2DecodeIO))
    val out = Vec(2, Flipped(Decoupled(new DecodeOutIO)))
  })
  val decoder0 = Module(new Decoder)
  val decoder1 = Module(new Decoder)
  val decoder0IO = Wire(new DecoderIOBundle)
  decoder0IO.pc := io.in.bits.cur_pc
  decoder0IO.instruction := io.in.bits.cur_instruction

  val decoder1IO = Wire(new DecoderIOBundle)
  decoder1IO.pc := io.in.bits.pnext_pc
  decoder1IO.instruction := io.in.bits.pnext_instruction

  decoder0.io.path <> decoder0IO
  decoder1.io.path <> decoder1IO

  io.out(0).bits.pc := decoder0IO.pc
  io.out(0).bits.path <> decoder0IO.path
  io.out(1).bits.pc := decoder1IO.pc
  io.out(1).bits.path <> decoder1IO.path
}
