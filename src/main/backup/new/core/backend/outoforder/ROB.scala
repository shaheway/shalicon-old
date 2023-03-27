package core.backend.outoforder
import chisel3._
import chisel3.util.{Decoupled, DecoupledIO, Enum, Queue, log2Up}
import core.CoreConfig

object ROBState {
  // val decode:: issue:: exec_alu:: exec_imul:: exec_fpu:: exec_lsu:: write:: commit:: Nil = Enum(8)
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
class RobStructure(entities: Int = 8) extends Bundle with CoreConfig {
  val entry = UInt(log2Up(entities).W) // 有效位
  val busy = Bool()
  val pc = UInt(addrwidth)
  val state = UInt(3.W) // 状态
  val destination = UInt(5.W)
  val value = UInt(datawidth)
}
class EntryIO extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val pnext_pc = Output(UInt(addrwidth))
}
class ROB2iBuf(entities: Int = 8) extends Bundle {
  val cur_entry = Output(UInt(log2Up(entities).W))
  val pnext_entry = Output(UInt(log2Up(entities).W))
}
class UpdateStateIO extends Bundle with CoreConfig {

}
class ROB(Line: Int = 8) extends Module {
  val io = IO(new Bundle() {
    val entry = Flipped(Decoupled(new EntryIO))
    val out2ibuf = Decoupled(new ROB2iBuf(entities = 8))
    val update_state = Flipped(Decoupled(new UpdateStateIO))
    val forward = new ForwardIO
    val out = Decoupled()
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
    rob(head).entry := head
    rob(head).busy := true.B
    rob(head).pc := io.entry.bits.cur_pc
    rob(head+1.U).entry := head+1.U
    rob(head+1.U).busy := true.B
    rob(head+1.U).pc := io.entry.bits.pnext_pc
  }

  io.entry.ready := !is_full
  io.out.valid := !is_empty

  rob(tail) <> io.out.bits

  // forward
  io.forward.rs1Addr

  // To instruction buffer
  io.out2ibuf.bits.cur_entry := head
  io.out2ibuf.bits.pnext_entry := head + 1.U
}
