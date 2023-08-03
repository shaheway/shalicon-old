package core.frontend
import chisel3._
import chisel3.util.{MuxLookup, PriorityEncoder, log2Ceil}
import common.{MilkyBundle, MilkyModule}

class CacheLine(tag_width: Int, line_size: Int = 32) extends MilkyBundle {
  val valid = Bool()
  val tag = UInt(tag_width.W)
  val data = Vec(line_size, UInt(8.W))
}
class Cache(cache_size: Int = 4096, line_size: Int = 32, group_size: Int = 1) extends MilkyModule { /* byte */
  val io = IO(new Bundle() {
    val paddr = Input(UInt(xlen))
    val req_type = Input(Bool())
    val write_data = Input(UInt(xlen))
    val out = Output(UInt(xlen))
  })

  val group_num = cache_size / line_size / group_size
  val tag_width = 64 - log2Ceil(group_num) - log2Ceil(line_size)
  val group_width = log2Ceil(group_num)
  val offset_width = log2Ceil(line_size)
  val cache = SyncReadMem(group_num, Vec(group_size, new CacheLine(tag_width, line_size)))
  when(reset.asBool){
    for (i <- 0 until group_num){
      for (j <- 0 until group_size){
        cache(i)(j).valid := false.B
      }
    }
  }

  val offset = io.paddr(offset_width - 1, 0)
  val group_index = io.paddr(group_width + offset_width - 1, offset_width)
  val tag = io.paddr(64, 64 - tag_width + 1)
  val data = RegInit(0.U(xlen))
  val stage = RegInit(0.U(2.W))

  // Helper function to find a hit in a set
  def setHit(setIdx: UInt): Bool = {
    VecInit((0 until group_size).map(i => cache(setIdx)(i).valid && cache(setIdx)(i).tag === tag)).asUInt.orR
  }

  val hit = RegInit(false.B)
  val way = RegInit(0.U(log2Ceil(group_size)))
  when(stage === 0.U){
    hit := setHit(group_index)
    stage := 1.U
  }.elsewhen(stage === 1.U){
    val set = cache(group_index)
    when(hit) {
      way := PriorityEncoder(VecInit((0 until group_size).map(i => set(i).valid && set(i).tag === tag)).asUInt)
      set(way).data(offset)
    }.otherwise {}
    stage := 2.U
  }.otherwise{ /* stage === 2.U */
    when(hit) {

    }
  }
}
