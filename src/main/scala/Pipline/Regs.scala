package Pipline
import chisel3._
import common.Defines._
import connect.{RegReadIO, RegWriteIO}
class Regs extends Module {
  val regReadIO = new RegReadIO(REG_ADDR_LEN)
  val regWriteIO = new RegWriteIO(REG_ADDR_LEN)
  // 通用寄存器
  val registers = Mem(32, UInt(WORD_LEN_WIDTH))
  // 读出寄存器中的数
  regReadIO.reg_rdata1 := registers(regReadIO.reg_raddr1)
  regReadIO.reg_rdata2 := registers(regReadIO.reg_raddr2)
  // 写回寄存器
  when(regWriteIO.wen){
    registers(regWriteIO.reg_waddr) := regWriteIO.reg_wdata
  }
}
