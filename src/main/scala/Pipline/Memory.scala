package Pipline
import common.Defines._
import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline
import connect.{InstIO, MemReadIO, MemWriteIO}
class Memory extends Module {
  val io = IO(new Bundle() {
    val imem = (new InstIO)
    val aread = (new MemReadIO)
    val awrite = (new MemWriteIO)
  })
  val mem = Mem(16384, UInt(8.W))
  loadMemoryFromFileInline(mem, "memoryFile.hex")
  when(reset.asBool){
    io.imem.inst_o := START_ADDR
  }.otherwise {
    io.imem.inst_o := Cat(mem(io.imem.inst_addr + 3.U(8.W)),
      mem(io.imem.inst_addr + 2.U(8.W)),
      mem(io.imem.inst_addr + 1.U(8.W)),
      mem(io.imem.inst_addr))
  }

  io.aread.rdata := Cat(mem(io.aread.raddr + 3.U(8.W)),
    mem(io.aread.raddr + 2.U(8.W)),
    mem(io.aread.raddr + 1.U(8.W)),
    mem(io.aread.raddr))

  when(io.awrite.write_en){
    mem(io.awrite.waddr + 3.U(8.W)) := io.awrite.wdata(31, 24)
    mem(io.awrite.waddr + 2.U(8.W)) := io.awrite.wdata(23, 16)
    mem(io.awrite.waddr + 1.U(8.W)) := io.awrite.wdata(15, 8)
    mem(io.awrite.waddr) := io.awrite.wdata(7, 0)
  }
}
/*
object Memory extends App {
  (new ChiselStage).emitVerilog(new Memory())
}
 */