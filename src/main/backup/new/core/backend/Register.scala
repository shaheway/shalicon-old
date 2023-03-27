package core.backend
import chisel3._
import chisel3.util.Decoupled
import core.CoreConfig
class OperandReqIO extends Bundle with CoreConfig {
  val reg1Addr = Output(UInt(physical_regaddrwidth))
  val reg2Addr = Output(UInt(physical_regaddrwidth))
}
class OperandRetIO extends Bundle with CoreConfig {
  val reg1Data = Output(UInt(datawidth))
  val reg2Data = Output(UInt(datawidth))
}
class BusyIndicatorIO extends Bundle {
  val busyFlag = Output(UInt(64.W)) // 每一位都表示1个物理寄存器是否处于空闲状态
}
class WriteIO extends Bundle with CoreConfig {
  val writeAddr = Output(UInt(datawidth))
  val writeData = Output(UInt(datawidth))
}
class Register extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val req = Flipped(Decoupled(new OperandReqIO))
    val ret = Decoupled(new OperandRetIO)
    val wb = Flipped(Decoupled(new WriteIO))
    val indicator = Input(UInt(64.W)) // Every single bit indicates state of a physical register
  })
  val pregister = RegInit(VecInit(Seq.fill(64)(0.U(datawidth)))) // physical register

  val reg1Data = Mux(io.wb.fire && io.wb.bits.writeAddr === io.req.bits.reg1Addr, io.wb.bits.writeData, pregister(io.req.bits.reg1Addr))
  val reg2Data = Mux(io.wb.fire && io.wb.bits.writeAddr === io.req.bits.reg2Addr, io.wb.bits.writeData, pregister(io.req.bits.reg2Addr))

  
}
