package fetch
import chisel3.util.{Cat, Fill, MuxCase}
import chisel3._

class Intro extends Module {
  val io = IO(new Bundle() {
    val in_a = Input(UInt(32.W))
    val in_b = Input(UInt(32.W))
    val out = Output(UInt(32.W))
  })
  /*
  val wire_a = Wire(UInt(32.W))
  val wire_b = Wire(UInt(32.W))
  wire_a := io.in_a
  wire_b := io.in_b
   */
  val register_with_next = RegNext(io.in_b, init = io.in_a)
  io.out := MuxCase(0.U(32.W), Seq(
    (io.in_a === 1.U) -> 233.U(32.W),
    (io.in_a === 2.U) -> 2333.U(32.W),
    (io.in_a === 3.U) -> 23333.U(32.W)
  ))

}

object Intro extends App {
  println(getVerilogString(new Intro))
}