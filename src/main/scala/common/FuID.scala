package common
import chisel3._
import chisel3.util._
object FuID {
  val ignore = 0.U(3.W)
  val alu = 1.U(3.W)
  val bru = 2.U(3.W)
  val lsu = 3.U(3.W)
  val csru = 4.U(3.W)
}
