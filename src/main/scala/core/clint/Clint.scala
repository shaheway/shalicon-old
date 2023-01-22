package core.clint
import chisel3._
import chisel3.util.{Cat, MuxLookup}
import core.common.Defines
import core.decode.PrivilegedISA

class Clint extends Module {
  val io = IO(new Bundle() {
    val interruptFlag = Input(Bool())
    val instruction = Input(UInt(Defines.instructionWidth))
    val instAddr = Input(UInt(Defines.instAddrWidth))
    val jumpFlag = Input(Bool())
    val jumpAddr = Input(UInt(Defines.instAddrWidth))
    val interruptHandlerAddr = Output(UInt(Defines.instAddrWidth))
    val interruptAssert = Output(Bool())
    val csrBundle = new PrivilegedCSRBundle
  })
  val interrupt_enable = io.csrBundle.mstatus(3)
  val instructionAddress = Mux(io.jumpFlag, io.jumpAddr, io.instAddr + 4.U(Defines.instAddrWidth))

  // CLINT
  when(io.instruction === 0x73.U(Defines.instructionWidth) || io.instruction === 0x100073.U(Defines.instructionWidth)){
    io.csrBundle.mstatusWriteData := Cat(io.csrBundle.mstatus(63, 4), 0.U(1.W), io.csrBundle.mstatus(2, 0))
    io.csrBundle.mepcWriteData := instructionAddress
    io.csrBundle.mcauseWriteData := Mux(io.instruction === 0x73.U(Defines.instructionWidth), 11.U(63.W), 3.U(63.W))
    io.csrBundle.privilegedFlag := true.asBool
    io.interruptAssert := true.asBool
    io.interruptHandlerAddr := io.csrBundle.mtvec
  }.elsewhen(io.interruptFlag =/= InterruptStatus.none && interrupt_enable){
    io.csrBundle.mstatusWriteData := Cat(io.csrBundle.mstatus(63, 4), 0.U(1.W), io.csrBundle.mstatus(2, 0))
    io.csrBundle.mepcWriteData := instructionAddress
    io.csrBundle.mcauseWriteData := Mux(io.interruptFlag(0), Cat(1.U(1.W), 7.U(63.W)), Cat(1.U(1.W), 11.U(63.W)))
    io.csrBundle.privilegedFlag := true.asBool
    io.interruptAssert := true.asBool
    io.interruptHandlerAddr := io.csrBundle.mtvec
  }.elsewhen(io.instruction === PrivilegedISA.mret){
    io.csrBundle.mstatusWriteData := Cat(io.csrBundle.mstatus(63, 4), io.csrBundle.mstatus(7), io.csrBundle.mstatus(2, 0))
    io.csrBundle.mepcWriteData := io.csrBundle.mepc
    io.csrBundle.mcauseWriteData := io.csrBundle.mcause
    io.csrBundle.privilegedFlag := true.asBool
    io.interruptAssert := true.asBool
    io.interruptHandlerAddr := io.csrBundle.mepc
  }.otherwise {
    io.csrBundle.mstatusWriteData := io.csrBundle.mstatus
    io.csrBundle.mepcWriteData := io.csrBundle.mepc
    io.csrBundle.mcauseWriteData := io.csrBundle.mcause
    io.csrBundle.privilegedFlag := false.asBool
    io.interruptAssert := false.asBool
    io.interruptHandlerAddr := instructionAddress
  }
}
