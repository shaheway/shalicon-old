package core.backend.funcU
import chisel3._
import chisel3.util.{Cat, Decoupled, Fill, MuxLookup}
import common.Defines
import core.CoreConfig

class AluEntryIO extends Bundle with CoreConfig {
  val op1 = Input(UInt(datawidth))
  val op2 = Input(UInt(datawidth))
  val opType = Input(UInt(4.W))
  val entryid = Input(UInt(3.W))
}

class AluOutIO extends Bundle with CoreConfig {
  val result = Output(UInt(datawidth))
  val entryid = Output(UInt(3.W))
}
class Alu extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val in = Decoupled(Flipped(new AluEntryIO))
    val out = Decoupled(new AluOutIO)
  })

  val op1Data = io.in.bits.op1
  val op2Data = io.in.bits.op2
  val opType = io.in.bits.opType
  val wops = MuxLookup(opType, 0.U(Defines.wordWidth), IndexedSeq(
    AluopType.addw -> (op1Data(31, 0) + op2Data(31, 0)),
    AluopType.subw -> (op1Data(31, 0) - op2Data(31, 0)),
    AluopType.sllw -> (op1Data(31, 0) << op2Data(4, 0)).asUInt,
    AluopType.srlw -> (op1Data(31, 0) >> op2Data(4, 0)).asUInt,
    AluopType.sraw -> (op1Data(31, 0).asSInt << op2Data(4, 0)).asUInt
  ))
  val aluResult = MuxLookup(opType, 0.U(Defines.dataWidth), IndexedSeq(
    AluopType.add -> (op1Data + op2Data),
    AluopType.sub -> (op1Data - op2Data),
    AluopType.or -> (op1Data | op2Data),
    AluopType.xor -> (op1Data ^ op2Data),
    AluopType.and -> (op1Data & op2Data),
    AluopType.sll -> (op1Data << op2Data(5, 0)).asUInt,
    AluopType.srl -> (op1Data >> op2Data(5, 0)).asUInt,
    AluopType.sra -> (op1Data.asSInt >> op2Data(5, 0)).asUInt,
    AluopType.slt -> (op1Data.asSInt < op2Data.asSInt).asUInt,
    AluopType.sltu -> (op1Data < op2Data).asUInt,
    AluopType.copy -> op1Data,
    AluopType.inc -> (op1Data + 4.U(Defines.dataWidth)),
    AluopType.addw -> Cat(Fill(32, wops(31)), wops),
    AluopType.subw -> Cat(Fill(32, wops(31)), wops),
    AluopType.sllw -> Cat(Fill(32, wops(31)), wops),
    AluopType.srlw -> Cat(Fill(32, wops(31)), wops),
    AluopType.sraw -> Cat(Fill(32, wops(31)), wops),
  ))

  io.out.bits.entryid := io.in.bits.entryid
  io.out.bits.result := aluResult
}
