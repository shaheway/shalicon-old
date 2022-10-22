package Pipline
import chisel3._
import chisel3.util._
import common.Defines._
import common.Instructions._
import connect.{InstIO, CsrIO, IfidIO}
class InstFetch extends Module {
  val io = IO(new Bundle() {
    val inst_mem = Flipped(new InstIO)
    val csr = Flipped(new CsrIO(CSR_REG_LEN))
    val br_flag = Input(Bool())
    val br_target = Input(UInt(WORD_LEN_WIDTH))
    val jmp_flag = Input(Bool())
    val alu_out = Input(UInt(WORD_LEN_WIDTH))
    val passby = new IfidIO
  })
  // 连接状态寄存器
  val ecall_addr = 0x305.U(CSR_REG_WIDTH)
  io.csr.reg_raddr := ecall_addr // 将0x305传给csr
  val ecall_data = io.csr.reg_rdata // 接收csr的0x305处的内容

  val if_pc_reg = RegInit(START_ADDR)
  io.inst_mem.inst_addr := if_pc_reg
  val if_inst = io.inst_mem.inst_o
  val pc_next = MuxCase(if_pc_reg + 4.U(WORD_LEN_WIDTH), Seq(
    io.br_flag -> io.br_target,
    io.jmp_flag -> io.alu_out,
    (if_inst === CSR_ECALL) -> ecall_data,
  ))
  if_pc_reg := pc_next

  // 连接译码单元
  io.passby.if_pc_reg := if_pc_reg
  io.passby.if_inst := if_inst
}
