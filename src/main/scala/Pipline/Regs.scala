package Pipline
import chisel3._
import common.Defines._
import connect.{RegReadIO, RegWriteIO}
class Regs extends Module {
  val io = IO(new Bundle() {
    val regReadIO = new RegReadIO(REG_ADDR_LEN)
    val regWriteIO = new RegWriteIO(REG_ADDR_LEN)
    val probe = Output(UInt(WORD_LEN_WIDTH)) // 测试用
  })

  // 通用寄存器
  val registers = Mem(32, UInt(WORD_LEN_WIDTH))
  // 读出寄存器中的数
  io.regReadIO.reg_rdata1 := registers(io.regReadIO.reg_raddr1)
  io.regReadIO.reg_rdata2 := registers(io.regReadIO.reg_raddr2)
  // 写回寄存器
  when(io.regWriteIO.wen){
    registers(io.regWriteIO.reg_waddr) := io.regWriteIO.reg_wdata
  }

  io.probe := registers(6)
}
