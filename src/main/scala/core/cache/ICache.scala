package core.cache
import chisel3._
import chisel3.util
class ICache extends Module{
  val io = IO(new Bundle() {

  })

  /*
  Address -> 64-bit
  tag: (63, 60) -> 24-bit
  set index: (59, 16) -> 32-bit
  block index: (15, 0) -> 8-bit
  E = 1

  valid | tag | B byte
   */

  val ICache = SyncReadMem(VecInit(Seq.fill(32)(0.U(89))))
}
