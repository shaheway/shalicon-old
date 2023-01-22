package core.mem
import chisel3._
import chisel3.util.{MuxLookup, Cat, Fill}
import core.common.Defines
import core.decode.{LtypeFunct3, RegWriteSource}
import peripheral.memory.RAMBundle
class MemoryAccess extends Module {
  val io = IO(new Bundle() {
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
    val aluResult_in = Input(UInt(Defines.dataWidth))
    val memoryBundle = Flipped(new RAMBundle)
    val regWriteEnable_out = Output(Bool())
    val regWriteData = Output(UInt(Defines.dataWidth))
    val regWriteDest_out = Output(UInt(Defines.regAddrWidth))
    val csrAddr_out = Output(UInt(Defines.csrAddrWidth))
    val csrWriteEnable_out = Output(UInt(Defines.dataWidth))
  })

  io.memoryBundle.memAccessAddr := io.aluResult_in
  val memReadResult = Wire(UInt(Defines.dataWidth))
  val readDataResult = io.memoryBundle.dataReadResult
  memReadResult := Mux(io.memReadEnable_in, MuxLookup(io.memReadType_in, 0.U(Defines.dataWidth), IndexedSeq(
    LtypeFunct3.lb -> Cat(Fill(56, readDataResult(7)), readDataResult(7, 0)),
    LtypeFunct3.lbu -> Cat(0.U(56.W), readDataResult(7, 0)),
    LtypeFunct3.lh -> Cat(Fill(48, readDataResult(15)), readDataResult(15, 0)),
    LtypeFunct3.lhu -> Cat(0.U(48.W), readDataResult(15, 0)),
    LtypeFunct3.lw -> Cat(Fill(32, readDataResult(31)), readDataResult(31, 0)),
    LtypeFunct3.lwu -> Cat(0.U(32.W), readDataResult(31, 0)),
    LtypeFunct3.ld -> readDataResult
  )), 0.U(Defines.dataWidth))

  io.memoryBundle.dataWriteData := io.rs2Data_in
  io.memoryBundle.dataWriteType := io.memWriteType_in
  io.memoryBundle.memWriteEnable := io.memWriteEnable_in

  io.regWriteData := MuxLookup(io.regWriteSource_in, 0.U(Defines.dataWidth), IndexedSeq(
    RegWriteSource.alu -> io.aluResult_in,
    RegWriteSource.nextPC -> io.aluResult_in,
    RegWriteSource.mem -> memReadResult,
    // Todo: RegWriteSource.csr ->
  ))
}
