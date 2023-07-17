package core.frontend
import chisel3._
import chisel3.util.{BitPat, ListLookup}
import common.ScalaOpConstants._
import common.FUConstants._
import common.DestRegType._
import common.ImmExtSelect.{Btype, Utype, Xtype, immTypeLen}
import common.MemMaskType.{maskD, maskW, maskWU, maskX}
import common.MemOpConstants.{memCommandLen, memX, memXRD, memXWR}
import common.{CSR, ImmExtSelect, Instructions}
import common.SourceOpType.srcTypeLen

abstract trait DecodeConsts {
  def decode_default: List[BitPat] = {
    List(N, N, X, uopX, FU_X, RT_X, BitPat.dontCare(2), BitPat.dontCare(2), X, ImmExtSelect.Xtype, X, X, X, X, N, memX, maskX, BitPat.dontCare(2), X, X, X, X, N, X, CSR.X)
  }

  val table: Array[(BitPat, List[BitPat])]
}

class ControlSignals extends Bundle {
  val legal = Output(Bool())
  val fpVal = Output(Bool())
  val fpSingle = Output(Bool())
  val uop = Output(UInt(uopLen))
  val fuType = Output(UInt(functionSize))
  val destType = Output(UInt(destTypeLen))
  val rs1Type = Output(UInt(srcTypeLen))
  val rs2Type = Output(UInt(srcTypeLen))
  val frs3_en = Output(Bool()) // todo: DontKnow
  val immSel = Output(UInt(immTypeLen))
  val isLoad = Output(Bool())
  val isStore = Output(Bool())
  val isamo = Output(Bool())
  val isFence = Output(Bool())
  val isFenceI = Output(Bool()) // todo: DontKnow
  val memCommand = Output(UInt(memCommandLen))
  val memType = Output(UInt(memCommandLen))
  val wakeupDelay = Output(UInt(2.W)) // todo: DontKnow
  val bypassable = Output(Bool())
  val branchOrJump = Output(Bool())
  val isJAL = Output(Bool())
  val allocateBrtag = Output(Bool()) // todo: DontKnow
  val instUnique = Output(Bool())
  val flushOnCommit = Output(Bool())
  val csrCommand = UInt(CSR.size)
  val rocc = Output(Bool()) // todo: DontKnow
}

class InstDecode extends Module {
  val decoded_inst = ListLookup(instruction, List(), Array(
    Instructions.LD -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, maskD, 3.U, N, N, N, N, N, N, CSR.N),
    Instructions.LW -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, maskW, 3.U, N, N, N, N, N, N, CSR.N),
    Instructions.LWU -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, maskWU, 3.U, N, N, N, N, N, N, CSR.N),
    Instructions.LH -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, MSK_H, UInt(3), N, N, N, N, N, N, CSR.N),
    Instructions.LHU -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, MSK_HU, UInt(3), N, N, N, N, N, N, CSR.N),
    Instructions.LB -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, MSK_B, UInt(3), N, N, N, N, N, N, CSR.N),
    Instructions.LBU -> List(Y, N, X, uop_ld, FU_MEM, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, Y, N, N, N, N, memXRD, MSK_BU, UInt(3), N, N, N, N, N, N, CSR.N),

    Instructions.SD -> List(Y, N, X, uop_sta, FU_MEM, RT_X, RT_FIX, RT_FIX, N, ImmExtSelect.Stype, N, Y, N, N, N, memXWR, MSK_D, UInt(0), N, N, N, N, N, N, CSR.N),
    Instructions.SW -> List(Y, N, X, uop_sta, FU_MEM, RT_X, RT_FIX, RT_FIX, N, ImmExtSelect.Stype, N, Y, N, N, N, memXWR, MSK_W, UInt(0), N, N, N, N, N, N, CSR.N),
    Instructions.SH -> List(Y, N, X, uop_sta, FU_MEM, RT_X, RT_FIX, RT_FIX, N, ImmExtSelect.Stype, N, Y, N, N, N, memXWR, MSK_H, UInt(0), N, N, N, N, N, N, CSR.N),
    Instructions.SB -> List(Y, N, X, uop_sta, FU_MEM, RT_X, RT_FIX, RT_FIX, N, ImmExtSelect.Stype, N, Y, N, N, N, memXWR, MSK_B, UInt(0), N, N, N, N, N, N, CSR.N),

    Instructions.LUI -> List(Y, N, X, uop_lui, FU_ALU, RT_FIX, RT_X, RT_X, N, ImmExtSelect.Utype, N, N, N, N, N, memX, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),

    Instructions.ADDI -> List(Y, N, X, uop_addi, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.ANDI -> List(Y, N, X, uop_andi, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.ORI -> List(Y, N, X, uop_ori, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.XORI -> List(Y, N, X, uop_xori, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.SLTI -> List(Y, N, X, uop_slti, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.SLTIU -> List(Y, N, X, uop_sltiu, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.SLLI -> List(Y, N, X, uop_slli, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.SRAI -> List(Y, N, X, uop_srai, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    Instructions.SRLI -> List(Y, N, X, uop_srli, FU_ALU, RT_FIX, RT_FIX, RT_X, N, ImmExtSelect.Itype, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),

    ADDIW -> List(Y, N, X, uopADDIW, FU_ALU, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SLLIW -> List(Y, N, X, uopSLLIW, FU_ALU, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SRAIW -> List(Y, N, X, uopSRAIW, FU_ALU, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SRLIW -> List(Y, N, X, uopSRLIW, FU_ALU, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),

    SLL -> List(Y, N, X, uopSLL, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    ADD -> List(Y, N, X, uopADD, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SUB -> List(Y, N, X, uopSUB, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SLT -> List(Y, N, X, uopSLT, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SLTU -> List(Y, N, X, uopSLTU, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    AND -> List(Y, N, X, uopAND, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    OR -> List(Y, N, X, uopOR, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    XOR -> List(Y, N, X, uopXOR, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SRA -> List(Y, N, X, uopSRA, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SRL -> List(Y, N, X, uopSRL, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),

    ADDW -> List(Y, N, X, uopADDW, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SUBW -> List(Y, N, X, uopSUBW, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SLLW -> List(Y, N, X, uopSLLW, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SRAW -> List(Y, N, X, uopSRAW, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),
    SRLW -> List(Y, N, X, uopSRLW, FU_ALU, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(1), Y, N, N, N, N, N, CSR.N),

    MUL -> List(Y, N, X, uopMUL, FU_MUL, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    MULH -> List(Y, N, X, uopMULH, FU_MUL, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    MULHU -> List(Y, N, X, uopMULHU, FU_MUL, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    MULHSU -> List(Y, N, X, uopMULHSU, FU_MUL, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    MULW -> List(Y, N, X, uopMULW, FU_MUL, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),

    DIV -> List(Y, N, X, uopDIV, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    DIVU -> List(Y, N, X, uopDIVU, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    REM -> List(Y, N, X, uopREM, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    REMU -> List(Y, N, X, uopREMU, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    DIVW -> List(Y, N, X, uopDIVW, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    DIVUW -> List(Y, N, X, uopDIVUW, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    REMW -> List(Y, N, X, uopREMW, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),
    REMUW -> List(Y, N, X, uopREMUW, FU_DIV, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, N, N, CSR.N),

    AUIPC -> List(Y, N, X, uopAUIPC, FU_BRU, RT_FIX, RT_X, RT_X, N, IS_U, N, N, N, N, N, M_X, MSK_X, UInt(1), N, N, N, N, N, N, CSR.N), // use BRU for the PC read
    JAL -> List(Y, N, X, uopJAL, FU_BRU, RT_FIX, RT_X, RT_X, N, IS_J, N, N, N, N, N, M_X, MSK_X, UInt(1), N, Y, Y, N, N, N, CSR.N),
    JALR -> List(Y, N, X, uopJALR, FU_BRU, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(1), N, Y, N, Y, N, N, CSR.N),
    BEQ -> List(Y, N, X, uopBEQ, FU_BRU, RT_X, RT_FIX, RT_FIX, N, IS_B, N, N, N, N, N, M_X, MSK_X, UInt(0), N, Y, N, Y, N, N, CSR.N),
    BNE -> List(Y, N, X, uopBNE, FU_BRU, RT_X, RT_FIX, RT_FIX, N, IS_B, N, N, N, N, N, M_X, MSK_X, UInt(0), N, Y, N, Y, N, N, CSR.N),
    BGE -> List(Y, N, X, uopBGE, FU_BRU, RT_X, RT_FIX, RT_FIX, N, IS_B, N, N, N, N, N, M_X, MSK_X, UInt(0), N, Y, N, Y, N, N, CSR.N),
    BGEU -> List(Y, N, X, uopBGEU, FU_BRU, RT_X, RT_FIX, RT_FIX, N, IS_B, N, N, N, N, N, M_X, MSK_X, UInt(0), N, Y, N, Y, N, N, CSR.N),
    BLT -> List(Y, N, X, uopBLT, FU_BRU, RT_X, RT_FIX, RT_FIX, N, IS_B, N, N, N, N, N, M_X, MSK_X, UInt(0), N, Y, N, Y, N, N, CSR.N),
    BLTU -> List(Y, N, X, uopBLTU, FU_BRU, RT_X, RT_FIX, RT_FIX, N, IS_B, N, N, N, N, N, M_X, MSK_X, UInt(0), N, Y, N, Y, N, N, CSR.N),

    // I-type, the immediate12 holds the CSR register.
    CSRRW -> List(Y, N, X, uopCSRRW, FU_CSR, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.W),
    CSRRS -> List(Y, N, X, uopCSRRS, FU_CSR, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.S),
    CSRRC -> List(Y, N, X, uopCSRRC, FU_CSR, RT_FIX, RT_FIX, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.C),

    CSRRWI -> List(Y, N, X, uopCSRRWI, FU_CSR, RT_FIX, RT_PAS, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.W),
    CSRRSI -> List(Y, N, X, uopCSRRSI, FU_CSR, RT_FIX, RT_PAS, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.S),
    CSRRCI -> List(Y, N, X, uopCSRRCI, FU_CSR, RT_FIX, RT_PAS, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.C),

    SFENCE_VM -> List(Y, N, X, uopSYSTEM, FU_CSR, RT_X, RT_X, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, N, CSR.I),
    SCALL -> List(Y, N, X, uopSYSTEM, FU_CSR, RT_X, RT_X, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, N, CSR.I),
    SBREAK -> List(Y, N, X, uopSYSTEM, FU_CSR, RT_X, RT_X, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, N, CSR.I),
    SRET -> List(Y, N, X, uopSYSTEM, FU_CSR, RT_X, RT_X, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, N, CSR.I),
    MRET -> List(Y, N, X, uopSYSTEM, FU_CSR, RT_X, RT_X, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, N, CSR.I),
    DRET -> List(Y, N, X, uopSYSTEM, FU_CSR, RT_X, RT_X, RT_X, N, IS_I, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, N, CSR.I),

    WFI -> List(Y, N, X, uopNOP, FU_X, RT_X, RT_X, RT_X, N, IS_X, N, N, N, N, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.N), // implemented as a NOP; TODO

    FENCE_I -> List(Y, N, X, uopNOP, FU_X, RT_X, RT_X, RT_X, N, IS_X, N, N, N, N, Y, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.N),
    FENCE -> List(Y, N, X, uopFENCE, FU_MEM, RT_X, RT_X, RT_X, N, IS_X, N, Y, N, Y, N, M_X, MSK_X, UInt(0), N, N, N, N, Y, Y, CSR.N), // TODO PERF make fence higher performance
    // currently serializes pipeline
    // A-type
    AMOADD_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_ADD, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N), // TODO make AMOs higherperformance
    AMOXOR_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_XOR, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOSWAP_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_SWAP, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOAND_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_AND, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOOR_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_OR, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMIN_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MIN, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMINU_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MINU, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMAX_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MAX, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMAXU_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MAXU, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N),

    AMOADD_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_ADD, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOXOR_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_XOR, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOSWAP_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_SWAP, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOAND_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_AND, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOOR_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_OR, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMIN_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MIN, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMINU_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MINU, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMAX_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MAX, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),
    AMOMAXU_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XA_MAXU, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N),

    LR_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XLR, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N), // TODO optimize LR, SC
    LR_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XLR, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N), // note LR generates 2 micro-ops,
    SC_W -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XSC, MSK_W, UInt(0), N, N, N, N, Y, Y, CSR.N), // one which isn't needed
    SC_D -> List(Y, N, X, uopAMO_AG, FU_MEM, RT_FIX, RT_FIX, RT_FIX, N, IS_X, N, Y, Y, N, N, M_XSC, MSK_D, UInt(0), N, N, N, N, Y, Y, CSR.N)
  ))

}

class DecodeUnitIO extends Bundle {

}

class DecodeUnit extends Module {
  val io = new DecodeUnitIO
  val uop = Wire()

  uop := io.enq.uop

  val cs = Wire(new ControlSignals).de
}