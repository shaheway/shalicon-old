package fetch
import common.Defines._
import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import chisel3.util.experimental.loadMemoryFromFileInline
import connect.{InstIO, WbIO}
class Memory extends Module {
  val io = IO(new Bundle() {
    val imem = (new InstIO)
    val wbio = (new WbIO)
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

  io.wbio.rdata := Cat(mem(io.wbio.raddr + 3.U(8.W)),
    mem(io.wbio.raddr + 2.U(8.W)),
    mem(io.wbio.raddr + 1.U(8.W)),
    mem(io.wbio.raddr))

  when(io.wbio.write_en){
    mem(io.wbio.waddr + 3.U(8.W)) := io.wbio.wdata(31, 24)
    mem(io.wbio.waddr + 2.U(8.W)) := io.wbio.wdata(23, 16)
    mem(io.wbio.waddr + 1.U(8.W)) := io.wbio.wdata(15, 8)
    mem(io.wbio.waddr) := io.wbio.wdata(7, 0)
  }
}

object Memory extends App {
  (new ChiselStage).emitVerilog(new Memory())
}