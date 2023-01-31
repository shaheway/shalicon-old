package core.backend.outoforder
import chisel3._
import chisel3.util.{Decoupled, DecoupledIO, Queue, log2Up}
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
class EntryIO extends Bundle with CoreConfig {
  val pc = Output(UInt(addrwidth))
  val instruction = Output(UInt(instwidth))
}
class RobQueueStructure(entities: Int = 32) extends Bundle {
  val valid = Bool()
  val regLine = UInt(log2Up(entities).W)
}
class UpdateStateIO extends Bundle with CoreConfig {

}
class ROB(Line: Int = 32) extends Module {
  val io = IO(new Bundle() {
    val entry = Flipped(Decoupled(new EntryIO))
    val update_state = Flipped(Decoupled(new UpdateStateIO))
    val out = Decoupled(new EntryIO)
  })

  val head = RegInit(0.U(log2Up(Line).W)) // 头指针
  val tail = RegInit(0.U(log2Up(Line).W)) // 尾指针
  val is_full = RegInit(false.B)
  val is_empty = !is_full && (head === tail) // 队列空

  val do_enq = io.entry.fire
  val do_deq = io.out.fire
  val enq_ptr = head + 1.U
  val deq_ptr = tail + 1.U

  val full_next = Mux(do_enq && !do_deq && (head === tail), true.B, Mux(do_deq && is_full, false.B, is_full))

  head := Mux(do_enq, enq_ptr, head)
  tail := Mux(do_deq, deq_ptr, tail)

  is_full := full_next

  val rob = Reg(Vec(Line, new RobStructure(entities = Line)))
  when(do_enq){
    rob(head) := io.entry
  }

  io.entry.ready := !is_full
  io.out.valid := !is_empty

  rob(tail) <> io.out.bits
}
