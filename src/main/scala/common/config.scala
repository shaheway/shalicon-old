package common
import chisel3._

trait CoreConfig {
  val addrWidth = 64.W
  val dataWidth = 64.W
  val instWidth = 32.W
  val instLength = 32
  val fetchCount = 2
}
