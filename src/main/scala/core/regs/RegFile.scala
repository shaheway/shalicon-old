package core.regs
import chisel3._
import common.Defines

class RegFile extends Module {
  val io = IO(new Bundle() {
    val read1Addr = Input(UInt(Defines.regAddrWidth))
    val read2Addr = Input(UInt(Defines.regAddrWidth))
    val writeAddr = Input(UInt(Defines.regAddrWidth))
    val writeData = Input(UInt(Defines.regAddrWidth))
    val writeEnable = Input(Bool())
    val read1Data = Output(UInt(Defines.dataWidth))
    val read2Data = Output(UInt(Defines.dataWidth))
  })

  val registers = RegInit(VecInit(Seq.fill(32)(0.U(Defines.dataWidth))))
  when(io.writeEnable){
    registers(io.writeAddr) := io.writeData
  }

  io.read1Data := Mux(io.read1Addr === 0.U(Defines.regAddrWidth), 0.U(Defines.dataWidth), registers(io.read1Addr))
  io.read2Data := Mux(io.read2Addr === 0.U(Defines.regAddrWidth), 0.U(Defines.dataWidth), registers(io.read2Addr))
}
