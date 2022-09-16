package fetch
import common.Defines._
import chisel3._
import chisel3.stage.ChiselStage
class Pc_reg extends Module {
  val io = IO(new Bundle() {
    val inst_i = Input(UInt(WORD_LEN_WIDTH))
    val inst_addr = Output(UInt(WORD_LEN_WIDTH))
    val ce = Output(Bool())
  })
  val registers = Mem(32, UInt(WORD_LEN_WIDTH))
  val pc_reg = RegInit(START_ADDR)
  pc_reg := pc_reg + 4.U(WORD_LEN_WIDTH)
  io.inst_addr := pc_reg
  val inst = io.inst_i
  io.ce := (inst === 0x13136f97.U(WORD_LEN_WIDTH))
}

object Pc_reg extends App {
  (new ChiselStage).emitVerilog(new Pc_reg())
}