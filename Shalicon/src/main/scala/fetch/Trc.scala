package fetch
import Chisel.{is, switch}
import chisel3._
import chisel3.util.Enum
class Fsm1 extends Module {
  val io = IO(new Bundle() {
    val in = Input(Bool())
    val out = Output(Bool())
  })
  val zero::up::high::Nil = Enum(3)
  val state_register = RegInit(zero)
  switch(state_register) {
    is(zero) {
      when(io.in) {
        state_register := up
      }.otherwise {
        state_register := zero
      }
    }
    is(up) {
      when(io.in) {
        state_register := high
      }.otherwise {
        state_register := zero
      }
    }
    is(high) {
      when(io.in) {
        state_register := high
      }.otherwise {
        state_register := zero
      }
    }
  }
  io.out := (state_register === up)
}

object Fsm1 extends App {
  println(getVerilogString(new Fsm))
}