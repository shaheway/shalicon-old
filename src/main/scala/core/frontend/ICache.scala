package core.frontend
import chisel3._
import common.{MilkyBundle, MilkyModule}
import chisel3.util.{Cat, log2Ceil}

class ITLB2ICacheBundle extends MilkyBundle {
  val instpaddr = Output(UInt(xlen))
  val instout = Input(UInt(ilen))
}

class TranslationUnit(ppn_width: Int = 27) extends MilkyModule {
  val io = IO(new Bundle() {
    val vpn = Input(UInt(ppn_width.W))
    val ppn = Output(UInt(12.W)) /* every page is 4KB */
    val paddr2mem = Output(UInt(xlen))
    val mem_res = Input(UInt(xlen))
  })
  val level2 = io.vpn(27, 19)
  val level1 = io.vpn(18, 10)
  val level0 = io.vpn(9, 0)
  val table = RegInit(0.U(xlen))

  val stage = RegInit(0.U(2.W))
  /* read table from memory */
  when(stage === 0.U){
    io.paddr2mem := Cat(0.U(55.W), level2)
    table := io.mem_res
    stage := 1.U
  }.elsewhen(stage === 1.U){
    io.paddr2mem := level1+table
    table := io.mem_res
    stage := 2.U
  }.otherwise{
    io.paddr2mem := level0 + table
    io.ppn := io.mem_res
    table := 0.U
    stage := 0.U
  }
}
class ITLBBlock(tag_width: Int = 19) extends MilkyBundle {
  val tag = RegInit(0.U(tag_width.W))
  val ppn = RegInit(0.U(12.W)) /* every page is 4KB */
  val valid = RegInit(false.B)
}
/* ITLB indeed is ITLB + Inst MMU */
class ITLB(index_width: Int = 8, tag_width: Int = 19, line_entities: Int = 4) extends MilkyModule {
  val io = IO(new Bundle() {
    val instvaddr = Input(UInt(xlen))
    val instpaddr = Output(UInt(ilen))
    val translate_res = Input(UInt(xlen))
  })

  val index = io.instvaddr(19, 12)
  val tag = io.instvaddr(39, 20)
  val ppo = io.instvaddr(11, 0)
  val block = Vec(1<<index_width, Vec(line_entities, new ITLBBlock(tag_width)))
  val ppn = Wire(UInt(12.W)) /* every page is 4KB */
  for (i <- 0 until line_entities){
    ppn := Mux(block(index)(i).tag === tag && block(index)(i).valid, block(index)(i).ppn, io.translate_res)
  }
  io.instpaddr := Cat(ppn, ppo)
}


class ICache(cachesize: Int = 4096, cachelinesize: Int = 32) extends MilkyModule {
  val io = IO(new Bundle() {
    val instpaddr = Input(UInt(xlen))
    val instout = Output(UInt(ilen))
  })

  val numCacheLines = cachesize / cachelinesize
  val indexBits = log2Ceil(numCacheLines)
  val offsetBits = log2Ceil(cachelinesize)

  // Create the cache memory
  val valid = RegInit(VecInit(Seq.fill(numCacheLines)(false.B)))
  val tags = Reg(Vec(numCacheLines, UInt(25.W))) // Assumes 4KB cache size (2^12 bytes)
  val data = Reg(Vec(numCacheLines, Vec(8, UInt(32.W))))

  io.instout
}
