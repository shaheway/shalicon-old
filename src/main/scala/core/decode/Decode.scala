package core.decode

import chisel3._
import chisel3.util.{Cat, Fill, MuxLookup, MuxCase}
import common.Defines
import core.alu.AluopType

class Decode extends Module {
  val io = IO(new Bundle() {
    val instruction = Input(UInt(Defines.instructionWidth))
    val instructionAddress = Input(UInt(Defines.instAddrWidth))

    val interruptAssert = Input(Bool())
    val interruptHandlerAddr = Input(UInt(Defines.instAddrWidth))

    val reg1Data = Input(UInt(Defines.dataWidth))
    val reg2Data = Input(UInt(Defines.dataWidth))
    val reg1Addr = Output(UInt(Defines.regAddrWidth))
    val reg2Addr = Output(UInt(Defines.regAddrWidth))

    val csrReadData = Input(UInt(Defines.dataWidth)) // from csr register
    val csrReadAddr = Output(UInt(Defines.csrAddrWidth))

    val jumpFlag = Output(Bool())
    val jumpTarget = Output(UInt(Defines.instAddrWidth))

    val clintJumpAddress = Output(Bool())
    val out2ex = new DecodeOutBundle
  })

  val progCounter = io.instructionAddress
  val instruction = io.instruction
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

  io.reg1Addr := rs1
  io.reg2Addr := rs2
  val reg1Data = io.reg1Data
  val reg2Data = io.reg2Data
  val immediate = MuxLookup(
    opcode,
    Cat(Fill(52, instruction(31)), io.instruction(31, 20)),
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
  // _Todo: If data hazard happens, aluop1 should be forwarded with new values._
  val aluop1 = MuxLookup(
    opcode,
    reg1Data,
    IndexedSeq(
      InstructionType.auipc -> progCounter,
      InstructionType.jal -> progCounter,
      InstructionType.B -> progCounter,
      InstructionType.csr -> Mux(funct3 === CSRTypeFunct3.csrrci || funct3 === CSRTypeFunct3.csrrsi || funct3 === CSRTypeFunct3.csrrwi, immediate, reg1Data)
    )
  )
  io.out2ex.op1Data := aluop1
  // _Todo: If data hazard happens, aluop2 should be forwarded with new values._
  val aluop2 = Mux(opcode === InstructionType.R || opcode === InstructionType.RW, reg2Data, immediate)
  io.out2ex.op2Data := aluop2

  io.out2ex.regWriteSource := MuxLookup(
    opcode,
    RegWriteSource.nop,
    IndexedSeq(
      InstructionType.R     -> RegWriteSource.alu,
      InstructionType.RW    -> RegWriteSource.alu,
      InstructionType.I     -> RegWriteSource.alu,
      InstructionType.IW    -> RegWriteSource.alu,
      InstructionType.L     -> RegWriteSource.mem,
      InstructionType.B     -> RegWriteSource.nop,
      InstructionType.S     -> RegWriteSource.nop,
      InstructionType.jal   -> RegWriteSource.nextPC,
      InstructionType.jalr  -> RegWriteSource.nextPC,
      InstructionType.lui   -> RegWriteSource.alu,
      InstructionType.auipc -> RegWriteSource.alu,
      InstructionType.csr   -> RegWriteSource.csr
    )
  )

  io.out2ex.regWriteEnable := MuxLookup(
    opcode,
    false.asBool,
    IndexedSeq(
      InstructionType.R -> true.asBool,
      InstructionType.RW -> true.asBool,
      InstructionType.I -> true.asBool,
      InstructionType.IW -> true.asBool,
      InstructionType.L -> true.asBool,
      InstructionType.jal -> true.asBool,
      InstructionType.jalr -> true.asBool,
      InstructionType.lui -> true.asBool,
      InstructionType.auipc -> true.asBool,
      InstructionType.csr -> true.asBool
    )
  )

  io.out2ex.memReadEnable := Mux(opcode === InstructionType.L, true.asBool, false.asBool)
  io.out2ex.memWriteEnable := Mux(opcode === InstructionType.S, true.asBool, false.asBool)

  io.out2ex.regWriteDest := rd

  val csrAddress = instruction(31, 20)
  io.csrReadAddr := csrAddress
  io.out2ex.csrWriteDest := csrAddress
  io.out2ex.csrReadData := io.csrReadData
  io.out2ex.csrType := funct3
  io.out2ex.csrWriteEnable := Mux(opcode === InstructionType.csr, MuxLookup(
    funct3,
    false.asBool,
    IndexedSeq(
      CSRTypeFunct3.csrrc -> true.asBool,
      CSRTypeFunct3.csrrs -> true.asBool,
      CSRTypeFunct3.csrrw -> true.asBool,
      CSRTypeFunct3.csrrci -> true.asBool,
      CSRTypeFunct3.csrrsi -> true.asBool,
      CSRTypeFunct3.csrrwi -> true.asBool
    )
  ), false.asBool)

  io.out2ex.opType := MuxLookup(
    opcode,
    AluopType.nop,
    IndexedSeq(
      InstructionType.R -> MuxCase(AluopType.nop, Seq(
        (funct3 === RtypeFunct3.add && funct7 === RtypeFunct7.add) -> AluopType.add,
        (funct3 === RtypeFunct3.sub && funct7 === RtypeFunct7.sub) -> AluopType.sub,
        (funct3 === RtypeFunct3.or && funct7 === RtypeFunct7.or)  -> AluopType.or,
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
        (funct3 === ItypeFunct3.ori)  -> AluopType.or,
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

  io.out2ex.rs2Addr := rs2
  io.out2ex.rs1Addr := rs1
  io.out2ex.allowForward1 := Mux(opcode === InstructionType.R || opcode === InstructionType.I || opcode === InstructionType.S || opcode === InstructionType.B || opcode === InstructionType.IW || opcode === InstructionType.RW || opcode === InstructionType.L, true.asBool, false.asBool)
  io.out2ex.allowForward2 := Mux(opcode === InstructionType.R || opcode === InstructionType.RW || opcode === InstructionType.B, true.asBool, false.asBool)
  io.out2ex.allowForwardrs2 := (opcode === InstructionType.S)

  io.out2ex.memReadType := Mux(opcode === InstructionType.L, funct3, 0x7.U(3.W))
  io.out2ex.memWriteType := Mux(opcode === InstructionType.S, funct3, 0x7.U(3.W))

  // Control related
  // todo: support interrupt and csr memory page
  io.jumpFlag := (io.interruptAssert || opcode === InstructionType.jal || opcode === InstructionType.jalr || (opcode === InstructionType.B && MuxLookup(
    funct3,
    false.asBool,
    IndexedSeq(
      BtypeFunct3.beq -> (reg1Data === reg2Data),
      BtypeFunct3.bne -> (reg1Data =/= reg2Data),
      BtypeFunct3.blt -> (reg1Data.asSInt < reg2Data.asSInt),
      BtypeFunct3.bge -> (reg1Data.asSInt >= reg2Data.asSInt),
      BtypeFunct3.bltu -> (reg1Data < reg2Data),
      BtypeFunct3.bgeu -> (reg1Data >= reg2Data)
    )
  )))

  // Todo: If data hazard happens, io.reg1Data should be forwarded with new values.
  val jumpTargetAddr = Mux(io.interruptAssert, io.interruptHandlerAddr, immediate + Mux(opcode === InstructionType.jal, progCounter, io.reg1Data))
  // todo: support interrupt and csr memory page
  io.jumpTarget := jumpTargetAddr

  // clint
  io.clintJumpAddress := immediate + Mux(opcode === InstructionType.jal, progCounter, io.reg1Data)
}
