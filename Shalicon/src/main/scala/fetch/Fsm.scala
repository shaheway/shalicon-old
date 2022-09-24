package fetch
import Chisel.switch
import chisel3._
import chisel3.util.{Enum, is}
class Fsm extends Module {
  val io = IO(new Bundle() {
    val in = Input(Bool())
    val out = Output(Bool())
  })
  //
  val zero::up::one::Nil = Enum(3)
  val state_register = RegInit(zero)
  switch(state_register) {
    is(zero){
      when(io.in){
        state_register := up
      }.otherwise {
        state_register := zero
      }
    }
    is(up) {
      when(io.in) {
        state_register := one
      }.otherwise {
        state_register := zero
      }
    }
    is(one) {
      when(io.in) {
        state_register := one
      }.otherwise {
        state_register := zero
      }
    }
  }

  io.out := (state_register === up)
}
object Fsm extends App {
  println(getVerilogString(new Fsm))

}
