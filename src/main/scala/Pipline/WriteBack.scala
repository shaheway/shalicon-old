package Pipline
import chisel3._
import common.Defines._
import connect.{MaWbIO, RegWriteIO}
class WriteBack extends Module {
  val io = IO(new Bundle() {
    val extend = Flipped(new MaWbIO)
    val regIO = Flipped(new RegWriteIO(32))
    val gp = Output(UInt(WORD_LEN_WIDTH)) // 用于测试
  })

  // 定义本阶段寄存器
  val reg_wen_reg = RegInit(0.U(REN_LEN))
  val wb_addr_reg = RegInit(0.U(REG_ADDR_WIDTH))
  val wb_data_reg = RegInit(0.U(WORD_LEN_WIDTH))

  // 将上一级数据给到本级寄存器
  reg_wen_reg := io.extend.reg_wen
  wb_addr_reg := io.extend.reg_wb_addr
  wb_data_reg := io.extend.reg_wb_data

  io.regIO.reg_waddr := wb_addr_reg
  io.regIO.reg_wdata := wb_data_reg
  when(reg_wen_reg === REN_S) {
    io.regIO.wen := true.asBool
  }.otherwise{
    io.regIO.wen := false.asBool
  }
  // 测试用
  io.gp := wb_data_reg
}
