package Pipline
import chisel3._
import common.Defines._
import connect.RegIO
class Regs extends Module {
  val regIO = new RegIO(REG_ADDR_LEN)
  // 通用寄存器
  val registers = Mem(32, UInt(WORD_LEN_WIDTH))
  // 读出寄存器中的数
  regIO.reg_rdata1 := registers(regIO.reg_raddr1)
  regIO.reg_rdata2 := registers(regIO.reg_raddr2)
  // 写回寄存器
  when(regIO.wen){
    registers(regIO.reg_waddr) := regIO.reg_wdata
  }
}
