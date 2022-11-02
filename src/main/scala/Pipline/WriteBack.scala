package Pipline
import chisel3._
import common.Defines._
import connect.{MaWbIO, RegWriteIO}
class WriteBack extends Module {
  val io = IO(new Bundle() {
    val extend = Flipped(new MaWbIO)
    val regIO = Flipped(new RegWriteIO(32))
  })

  // 定义本阶段寄存器
  val reg_wen_reg = RegInit(0.U(REN_LEN))
  val wb_addr = RegInit(0.U(REG_ADDR_WIDTH))
  val wb_data = RegInit(0.U(WORD_LEN_WIDTH))

  reg_wen_reg := io.extend.reg_wen
  io.regIO.reg_waddr := io.extend.reg_wb_addr
  io.regIO.reg_wdata := io.extend.reg_wb_data
  when(reg_wen_reg === REN_S) {
    io.regIO.wen := true.asBool
  }
}
