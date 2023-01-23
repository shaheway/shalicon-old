package core.mem
import chisel3._
import chisel3.util.{Cat, Fill, MuxLookup}
import common.Defines
import core.alu.AluOutBundle
import core.decode.{LtypeFunct3, RegWriteSource}
import peripheral.memory.RAMBundle
class MemoryAccess extends Module {
  val io = IO(new Bundle() {
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
//    val aluResult_in = Input(UInt(Defines.dataWidth))
//

    val in = Flipped(new AluOutBundle)
    val out = new MemOutBundle
    val memoryBundle = Flipped(new RAMBundle)
  })

  val csrResult = MuxLookup(io.in.csrType, 0.U(Defines.dataWidth), IndexedSeq(
    0x1.U(3.W) -> io.in.aluResult,
    0x5.U(3.W) -> io.in.aluResult,
    0x2.U(3.W) -> (io.in.aluResult & io.in.csrReadData),
    0x6.U(3.W) -> (io.in.aluResult & io.in.csrReadData),
    0x3.U(3.W) -> (io.in.aluResult | io.in.csrReadData),
    0x7.U(3.W) -> (io.in.aluResult | io.in.csrReadData)
  ))
  io.memoryBundle.memAccessAddr := io.in.aluResult
  val memReadResult = Wire(UInt(Defines.dataWidth))
  val readDataResult = io.memoryBundle.dataReadResult
  memReadResult := Mux(io.in.memReadEnable, MuxLookup(io.in.memReadType, 0.U(Defines.dataWidth), IndexedSeq(
    LtypeFunct3.lb -> Cat(Fill(56, readDataResult(7)), readDataResult(7, 0)),
    LtypeFunct3.lbu -> Cat(0.U(56.W), readDataResult(7, 0)),
    LtypeFunct3.lh -> Cat(Fill(48, readDataResult(15)), readDataResult(15, 0)),
    LtypeFunct3.lhu -> Cat(0.U(48.W), readDataResult(15, 0)),
    LtypeFunct3.lw -> Cat(Fill(32, readDataResult(31)), readDataResult(31, 0)),
    LtypeFunct3.lwu -> Cat(0.U(32.W), readDataResult(31, 0)),
    LtypeFunct3.ld -> readDataResult
  )), 0.U(Defines.dataWidth))

  io.memoryBundle.dataWriteData := io.in.rs2Data
  io.memoryBundle.dataWriteType := io.in.memWriteType
  io.memoryBundle.memWriteEnable := io.in.memWriteEnable


  io.out.regWriteData := MuxLookup(io.in.regWriteSource, 0.U(Defines.dataWidth), IndexedSeq(
    RegWriteSource.alu -> io.in.aluResult,
    RegWriteSource.nextPC -> io.in.aluResult,
    RegWriteSource.mem -> memReadResult,
    RegWriteSource.csr -> io.in.csrReadData
  ))

  io.out.regWriteEnable := io.in.regWriteEnable
  io.out.regWriteDest := io.in.regWriteDest
  io.out.csrWriteEnable := io.in.csrWriteEnable
  io.out.csrWriteData := io.in.csrReadData
  io.out.csrWriteAddr := io.in.csrWriteDest
}
