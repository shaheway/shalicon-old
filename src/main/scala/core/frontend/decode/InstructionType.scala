package core.frontend.decode

import chisel3._
object InstructionType {
  val R = "b0110011".U(7.W)
  val I = "b0010011".U(7.W)
  val L = "b0000011".U(7.W)
  val S = "b0100011".U(7.W)
  val B = "b1100011".U(7.W)
  val E = "b1110011".U(7.W)
  val RW = "b0111011".U(7.W)
  val IW = "b0011011".U(7.W)
  val csr = "b1110011".U(7.W)
  val jal = "b1101111".U(7.W)
  val jalr = "b1100111".U(7.W)
  val lui = "b0110111".U(7.W)
  val auipc = "b0010111".U(7.W)
  val fenceI = "b0001111".U(7.W) // todo
}