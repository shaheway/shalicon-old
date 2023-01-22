package core.regs
import chisel3._
import chisel3.util.MuxLookup
import core.clint.PrivilegedCSRBundle
import core.common.Defines

class CSRFile extends Module {
  val io = IO(new Bundle() {
    val csrReadAddr = Input(UInt(Defines.csrAddrWidth))
    val csrWriteAddr = Input(UInt(Defines.csrAddrWidth))
    val writeData = Input(UInt(Defines.dataWidth))
    val writeEnable = Input(Bool())

    val readData = Output(UInt(Defines.dataWidth))

    val clintAccess = Flipped(new PrivilegedCSRBundle)
  })
  val mstatus = RegInit(0.U(Defines.dataWidth))
  val mcause = RegInit(0.U(Defines.dataWidth))
  val mtvec = RegInit(0.U(Defines.dataWidth))
  val mie = RegInit(0.U(Defines.dataWidth))
  val mepc = RegInit(0.U(Defines.dataWidth))
  val mscratch = RegInit(0.U(Defines.dataWidth))

  io.readData := MuxLookup(io.csrReadAddr, 0.U(Defines.dataWidth), IndexedSeq(
    IndexedCSR.mie -> mie,
    IndexedCSR.mcause -> mcause,
    IndexedCSR.mtvec -> mtvec,
    IndexedCSR.mstatus -> mstatus,
    IndexedCSR.mepc -> mepc,
    IndexedCSR.mscratch -> mscratch
  ))

  when(io.clintAccess.privilegedFlag){
    mstatus := io.clintAccess.mstatusWriteData
    mcause := io.clintAccess.mcauseWriteData
    mepc := io.clintAccess.mepcWriteData
  }.elsewhen(io.writeEnable) {
    mstatus := Mux(io.csrWriteAddr === IndexedCSR.mstatus, io.writeData, mstatus)
    mcause := Mux(io.csrWriteAddr === IndexedCSR.mcause, io.writeData, mcause)
    mepc := Mux(io.csrWriteAddr === IndexedCSR.mepc, io.writeData, mepc)
  }

  when(io.writeEnable){
    mie := Mux(io.csrWriteAddr === IndexedCSR.mie, io.writeData, mie)
    mtvec := Mux(io.csrWriteAddr === IndexedCSR.mtvec, io.writeData, mtvec)
    mscratch := Mux(io.csrWriteAddr === IndexedCSR.mscratch, io.writeData, mscratch)
  }

  // Notion: if pipeline writes at the time when clint reads, just forward the data to the clint
  io.clintAccess.mstatus := Mux(io.writeEnable && io.csrWriteAddr === IndexedCSR.mstatus, io.writeData, mstatus)
  io.clintAccess.mcause := Mux(io.writeEnable && io.csrWriteAddr === IndexedCSR.mcause, io.writeData, mcause)
  io.clintAccess.mtvec := Mux(io.writeEnable && io.csrWriteAddr === IndexedCSR.mtvec, io.writeData, mtvec)
  io.clintAccess.mepc := Mux(io.writeEnable && io.csrWriteAddr === IndexedCSR.mepc, io.writeData, mepc)
}
