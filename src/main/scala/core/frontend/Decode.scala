package core.frontend
import chisel3.{Mux, _}
import chisel3.util.{Cat, Decoupled, Fill, MuxCase, MuxLookup}
import common.{CSRTypeFunct3, CtrlFlowIO, DecodeOutIO, FunctUType, IWtypeFunct3, IWtypeFunct7, InstructionType, ItypeFunct3, ItypeFunct7, RWtypeFunct3, RWtypeFunct7, RegWriteSource, RtypeFunct3, RtypeFunct7, SrcType}
import core.CoreConfig
import core.alu.AluopType

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

  val src1Type = MuxLookup(opcode, SrcType.reg, IndexedSeq(
    InstructionType.auipc -> SrcType.pc,
    InstructionType.jal -> SrcType.pc,
    InstructionType.B -> SrcType.pc,
    InstructionType.csr -> Mux(funct3 === CSRTypeFunct3.csrrci || funct3 === CSRTypeFunct3.csrrsi || funct3 === CSRTypeFunct3.csrrwi, SrcType.imm, SrcType.reg)
  ))
  val src2Type = Mux(opcode === InstructionType.R || opcode === InstructionType.RW, SrcType.reg, SrcType.imm)

  io.out.bits.ctrlFlow <> io.in.bits
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

  io.out.bits.ctrlSignal.reg1Addr := rs1
  io.out.bits.ctrlSignal.reg2Addr := rs2
  io.out.bits.ctrlSignal.functU := functU
  io.out.bits.ctrlSignal.functOp := opType
  io.out.bits.ctrlSignal.src1Type := src1Type
  io.out.bits.ctrlSignal.src2Type := src2Type

  io.isBranch := (opcode === InstructionType.B || opcode === InstructionType.jal || opcode === InstructionType.jalr)
}
class Decode extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val in = Vec(2, Flipped(Decoupled(new CtrlFlowIO)))
    val out = Vec(2, Flipped(Decoupled(new DecodeOutIO)))
  })
  val decoder0 = Module(new Decoder)
  val decoder1 = Module(new Decoder)

  io.in(0) <> decoder0.io.in
  io.in(1) <> decoder1.io.in
  io.out(0) <> decoder0.io.out
  io.out(1) <> decoder1.io.out

}
