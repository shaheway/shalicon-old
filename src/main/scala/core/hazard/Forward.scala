package core.hazard
import chisel3._
import chisel3.util.MuxCase
import common.Defines

class Forward extends Module {
  val io = IO(new Bundle() {
    // Todo: Here we forward the data directly to execute stage,
    // because judge jump or not can rely on other techniques.
    val op1Addr_deex = Input(UInt(Defines.regAddrWidth))
    val op2Addr_deex = Input(UInt(Defines.regAddrWidth))
    val rdAddr_exmem = Input(UInt(Defines.regAddrWidth))
    val regWen_exmem = Input(Bool())
    val memRead_exmem = Input(Bool())
    val rdAddr_memwb = Input(UInt(Defines.regAddrWidth))
    val regWen_memwb = Input(Bool())
    val op1ForwardType = Output(UInt(2.W))
    val op2ForwardType = Output(UInt(2.W))
  })
  io.op1ForwardType := MuxCase(0.U(2.W), Seq(
    (io.op1Addr_deex === io.rdAddr_exmem && io.regWen_exmem && (!io.memRead_exmem)) -> 1.U(2.W),
    (io.op1Addr_deex === io.rdAddr_exmem && io.regWen_exmem && io.memRead_exmem) -> 3.U(2.W),
    (io.op1Addr_deex === io.rdAddr_memwb && io.regWen_memwb) -> 2.U(2.W)
  ))

  io.op2ForwardType := MuxCase(0.U(2.W), Seq(
    (io.op2Addr_deex === io.rdAddr_exmem && io.regWen_exmem && (!io.memRead_exmem)) -> 1.U(2.W),
    (io.op2Addr_deex === io.rdAddr_exmem && io.regWen_exmem && io.memRead_exmem) -> 3.U(2.W),
    (io.op2Addr_deex === io.rdAddr_memwb && io.regWen_memwb) -> 2.U(2.W)
  ))
}
