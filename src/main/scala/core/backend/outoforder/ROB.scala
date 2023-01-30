package core.backend.outoforder
import chisel3._
import chisel3.util.{Queue, log2Up}
import core.CoreConfig

object ROBState {
  val issue = 0x0.U
  val exec_alu = 0x1.U
  val exec_imul = 0x2.U
  // val exec_idiv = 0x4.U
  val exec_fpu = 0x3.U
  // val exec_fpmul = 0x6.U
  val exec_lsu = 0x4.U
  val write = 0x5.U
  val commit = 0x6.U
}
class RobStructure(entities: Int = 32) extends Bundle with CoreConfig {
  val entry = UInt(log2Up(entities).W) // 有效位
  val busy = Bool()
  val instruction = UInt(instwidth)
  val state = UInt(3.W) // 状态
  val destination = UInt(5.W)
  val value = UInt(datawidth)
}
class ROB extends Module {
  val robQueue = new Queue(new RobStructure(entities = 32), 32)
  
}
