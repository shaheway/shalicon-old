package core.alu
import chisel3._
import chisel3.util.{Cat, Fill, MuxLookup}
import common.Defines
import core.decode.DecodeOutBundle
import core.hazard.HazardType

class Alu extends Module {
  val io = IO(new Bundle() {
//    val op1Data = Input(UInt(Defines.dataWidth))
//    val op2Data = Input(UInt(Defines.dataWidth))
//
//    val opType = Input(UInt(Defines.aluopTypeWidth))
//    val rs2Data_in = Input(UInt(Defines.dataWidth))
//    val memReadEnable_in = Input(Bool())
//    val memReadType_in = Input(UInt(3.W))
//    val memWriteType_in = Input(UInt(3.W))
//    val memWriteEnable_in = Input(Bool())
//    val regWriteEnable_in = Input(Bool())
//    val regWriteSource_in = Input(UInt(3.W))
//    val regWriteDest_in = Input(UInt(Defines.regAddrWidth))
//    val csrAddr_in = Input(UInt(Defines.csrAddrWidth))
//    val csrWriteEnable_in = Input(UInt(Defines.dataWidth))
//    val rs2Data = Input(UInt(Defines.dataWidth)) // from register
    val op1ForwardType = Input(Bool())
    val op2ForwardType = Input(Bool())
    val opnFromMem = Input(UInt(Defines.dataWidth))
    val opnFromWb = Input(UInt(Defines.dataWidth))
    val in = Flipped(new DecodeOutBundle)
    val out = new AluOutBundle
  })

  val op1Data = Mux(io.in.allowForward1, MuxLookup(io.op1ForwardType, io.in.op1Data, IndexedSeq(
    HazardType.ForwardFromMem -> io.opnFromMem,
    HazardType.ForwardFromWb -> io.opnFromWb
  )), io.in.op1Data)
  val op2Data = Mux(io.in.allowForward2, MuxLookup(io.op2ForwardType, io.in.op2Data, IndexedSeq(
    HazardType.ForwardFromMem -> io.opnFromMem,
    HazardType.ForwardFromWb -> io.opnFromWb
  )), io.in.op2Data)

  val wops = MuxLookup(io.in.opType, 0.U(Defines.wordWidth), IndexedSeq(
    AluopType.addw -> (op1Data(31, 0) + op2Data(31, 0)),
    AluopType.subw -> (op1Data(31, 0) - op2Data(31, 0)),
    AluopType.sllw -> (op1Data(31, 0) << op2Data(4, 0)).asUInt,
    AluopType.srlw -> (op1Data(31, 0) >> op2Data(4, 0)).asUInt,
    AluopType.sraw -> (op1Data(31, 0).asSInt << op2Data(4, 0)).asUInt
  ))
  val aluResult = MuxLookup(io.in.opType, 0.U(Defines.dataWidth), IndexedSeq(
    AluopType.add -> (op1Data + op2Data),
    AluopType.sub -> (op1Data - op2Data),
    AluopType.or  -> (op1Data | op2Data),
    AluopType.xor -> (op1Data ^ op2Data),
    AluopType.and -> (op1Data & op2Data),
    AluopType.sll -> (op1Data << op2Data(5, 0)).asUInt,
    AluopType.srl -> (op1Data >> op2Data(5, 0)).asUInt,
    AluopType.sra -> (op1Data.asSInt >> op2Data(5, 0)).asUInt,
    AluopType.slt -> (op1Data.asSInt < op2Data.asSInt).asUInt,
    AluopType.sltu -> (op1Data < op2Data).asUInt,
    AluopType.copy -> op1Data,
    AluopType.inc  -> (op1Data + 4.U(Defines.dataWidth)),
    AluopType.addw -> Cat(Fill(32, wops(31)), wops),
    AluopType.subw -> Cat(Fill(32, wops(31)), wops),
    AluopType.sllw -> Cat(Fill(32, wops(31)), wops),
    AluopType.srlw -> Cat(Fill(32, wops(31)), wops),
    AluopType.sraw -> Cat(Fill(32, wops(31)), wops),
  ))

  io.out.memReadEnable := io.in.memReadEnable
  io.out.memReadType := io.in.memReadType
  io.out.memWriteType := io.in.memWriteType
  io.out.memWriteEnable := io.in.memWriteEnable
  io.out.regWriteEnable := io.in.regWriteEnable
  io.out.regWriteSource := io.in.regWriteSource
  io.out.regWriteDest := io.in.regWriteDest
  io.out.csrWriteEnable := io.in.csrWriteEnable
  io.out.aluResult := aluResult
  io.out.rs2Data := Mux(io.in.allowForwardrs2, MuxLookup(io.in.rs2Addr, io.in.rs2Data, IndexedSeq(
    HazardType.ForwardFromMem -> io.opnFromMem,
    HazardType.ForwardFromWb -> io.opnFromWb
  )), io.in.rs2Data) // solved: forward
  io.out.csrType := io.in.csrType
  io.out.csrWriteDest := io.in.csrWriteDest
}
