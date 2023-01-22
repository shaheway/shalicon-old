package core.alu
import chisel3._
import chisel3.util.{MuxLookup, Cat, Fill}
import core.common.Defines

class Alu extends Module {
  val io = IO(new Bundle() {
    val op1Data = Input(UInt(Defines.dataWidth))
    val op2Data = Input(UInt(Defines.dataWidth))

    val opType = Input(UInt(Defines.aluopTypeWidth))
    val rs2Data_in = Input(UInt(Defines.dataWidth))
    val memReadEnable_in = Input(Bool())
    val memReadType_in = Input(UInt(3.W))
    val memWriteType_in = Input(UInt(3.W))
    val memWriteEnable_in = Input(Bool())
    val regWriteEnable_in = Input(Bool())
    val regWriteSource_in = Input(UInt(3.W))
    val regWriteDest_in = Input(UInt(Defines.regAddrWidth))
    val csrAddr_in = Input(UInt(Defines.csrAddrWidth))
    val csrWriteEnable_in = Input(UInt(Defines.dataWidth))
    val memReadEnable_out = Output(Bool())
    val memReadType_out = Output(UInt(3.W))
    val memWriteType_out = Output(UInt(3.W))
    val memWriteEnable_out = Output(Bool())
    val regWriteEnable_out = Output(Bool())
    val regWriteSource_out = Output(UInt(3.W))
    val regWriteDest_out = Output(UInt(Defines.regAddrWidth))
    val csrAddr_out = Output(UInt(Defines.csrAddrWidth))
    val csrWriteEnable_out = Output(UInt(Defines.dataWidth))
    val aluResult_out = Output(UInt(Defines.dataWidth))
    val rs2Data_out = Output(UInt(Defines.dataWidth))
  })
  val op1Data = io.op1Data
  val op2Data = io.op2Data
  val wops = MuxLookup(io.opType, 0.U(Defines.wordWidth), IndexedSeq(
    AluopType.addw -> (op1Data(31, 0) + op2Data(31, 0)),
    AluopType.subw -> (op1Data(31, 0) - op2Data(31, 0)),
    AluopType.sllw -> (op1Data(31, 0) << op2Data(4, 0)).asUInt,
    AluopType.srlw -> (op1Data(31, 0) >> op2Data(4, 0)).asUInt,
    AluopType.sraw -> (op1Data(31, 0).asSInt << op2Data(4, 0)).asUInt
  ))
  val aluResult = MuxLookup(io.opType, 0.U(Defines.dataWidth), IndexedSeq(
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
}
