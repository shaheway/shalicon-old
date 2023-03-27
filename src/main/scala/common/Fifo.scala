package common
import chisel3._
import chisel3.util.log2Up

class Fifo (Line: Int) extends Module {
  val io = IO(new Bundle() {

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
}
