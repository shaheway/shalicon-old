package common
import chisel3._
import chisel3.util._
object InstType32i {
  val lui = "b0110111" // ALU
  val auipc = "b0010111" // BRU
  val jal = "b1101111" // BRU
  val jalr = "b1100111" // BRU
  val btype = "b1100011" // BRU
  val ltype = "b0000011" // LSU
  val stype = "b0100011" // LSU
  val itype = "b0010011" //ALU
  val rtype = "b0110011" // ALU
  val fence = "b0001111" // ?
  val eceb = "b1110011" // ?
}

object InstType64i {
  val iwtype = "b0011011" // ALU
  val rwtype = "b0111011" // ALU
}

val csrType = "b1110011"