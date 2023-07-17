package core.frontend

import chisel3._
import chisel3.util.{Decoupled, MuxLookup}
import common.{MilkyBundle, MilkyModule, ScalaOpConstants}

class ICache2CoreBundle extends MilkyBundle {
  val inst = Output(UInt(ilen))
}

class Core2ICacheBundle extends MilkyBundle {
  val pc = Output(UInt(xlen))
}

class CacheLine(blocksize: Int = 4) extends MilkyBundle {
  /* A direct-mapped ICache, with 4 instructions per line. */
  val valid = Bool()
  val tag = UInt(56.W)
  val block = Vec(blocksize, UInt(32.W))
}

class InstructionCache(fetch_count: Int = 2, lineNumber: Int = 16, blocksize: Int = 4) extends MilkyModule {
  val io = IO(new Bundle {
    val core2icache = Vec(fetch_count, Flipped(Decoupled(new Core2ICacheBundle)))
    val icache2core = Vec(fetch_count, Decoupled(new ICache2CoreBundle))
  })

  /* 4-byte instructions, the cache will have 2 KB (16 * 4 * 4 bytes) capacity */
  // val lineNumber = 16
  val icache = SyncReadMem(lineNumber, new CacheLine(blocksize))

  /** Calculate the cache index and offset based on the input address
   * The instruction addresses in RISC-V should be aligned to 4-bytes edge,
   * so we use the 2 and 3 bit to index the blocks.
   * 63                         8 7       4 3       2 1  0
   * |---------------------------|---------|---------|----|
   *  -----------tag-------------line index--offset---align bit (0)
   * */

  for (i <- 0 until fetch_count){
    val lineIndex = io.core2icache(i).bits.pc(7, 4)
    val offset = io.core2icache(i).bits.pc(3, 2)
    val lineTag = io.core2icache(i).bits.pc(63, 8)

    /** Only when cache is hit, valid flag will be posed. */
    io.icache2core(i).valid := icache(lineIndex).valid && (icache(lineIndex).tag === lineTag)
    io.icache2core(i).bits.inst := MuxLookup(offset, ScalaOpConstants.uop_nop, (0 until blocksize).map(i => i.U -> icache(lineIndex).block(i)))

    /* todo
    *   If not hit, fetch data from memory and load into cacheline.
    * */
  }
//  val lineIndex1 = io.core2icache.bits.pc1(7, 4) /* 7 to 4 */
//  val lineIndex2 = io.core2icache.bits.pc2(7, 4)
//  val offset1 = io.core2icache.bits.pc1(3, 2)
//  val offset2 = io.core2icache.bits.pc2(3, 2)
//  val lineTag1 = io.core2icache.bits.pc1(63, 8)
//  val lineTag2 = io.core2icache.bits.pc2(63, 8)


}


