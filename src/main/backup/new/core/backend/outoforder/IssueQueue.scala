package core.backend.outoforder
import chisel3._
import chisel3.util.{Decoupled, Queue, log2Up}
import core.CoreConfig

class IssueQueueEntryIO extends Bundle with CoreConfig {
  val src1Type = Output(UInt()) // todo
  val src2Type = Output(UInt()) // todo
  val rs1Data = Output(UInt(datawidth))
  val rs2Data = Output(UInt(datawidth))
  val rs1Addr = Output(UInt(regaddrwidth))
  val rs2Addr = Output(UInt(regaddrwidth))
  val opType = Output(UInt()) // todo
}
class IssueQueueOutIO extends Bundle with CoreConfig {
  val op1Data = Output(UInt(datawidth))
  val op2Data = Output(UInt(datawidth))
  val opType = Output(UInt()) // todo
}
class IssueQueueStructure extends Bundle with CoreConfig {
  val src1Type = UInt() // todo
  val src2Type = UInt() // todo
  val rs1Data = UInt(datawidth)
  val rs2Data = UInt(datawidth)
  val rs1Addr = UInt(regaddrwidth)
  val rs2Addr = UInt(regaddrwidth)
  val opType = UInt() // todo
}

class ForwardIO extends Bundle with CoreConfig {
  val src1Type = Input(UInt())
  val src2Type = Input(UInt())
  val rs1Addr = Input(UInt(regaddrwidth))
  val rs2Addr = Input(UInt(regaddrwidth))
  val rs1ForwardFlag = Output(Bool())
  val rs2ForwardFlag = Output(Bool())
  val forwardData = Output(UInt(datawidth))
}

class IssueQueue(InstType: Int = 0, Line: Int = 4) extends Module {
  val io = IO(new Bundle() {
    val entry = Flipped(Decoupled(new IssueQueueEntryIO))
    val out = Decoupled(new IssueQueueOutIO)
    val forward = Flipped(new ForwardIO)
  })
  val deOut = Wire(new IssueQueueOutIO)
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

  val queue = Reg(Vec(Line, new IssueQueueStructure))

  when(do_enq) {
    queue(head) := io.entry
  }

  io.entry.ready := !is_full
  io.out.valid := !is_empty

  queue(tail) <> deOut

  io.out.bits.opType := deOut.opType

}
