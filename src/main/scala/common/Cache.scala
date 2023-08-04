package common

import chisel3._
import chisel3.util.{Cat, Decoupled, DecoupledIO, Enum, PriorityEncoder, is, log2Ceil, switch}
import peripheral.AxiLiteInterface

class CacheLine(tag_width: Int, line_size: Int = 32) extends MilkyBundle {
  val valid = Bool()
  val tag = UInt(tag_width.W)
  val data = Vec(line_size, UInt(8.W))
}

class CacheReq extends MilkyBundle {
  val paddr = Input(UInt(xlen))
  val req_type = Input(Bool())
  /* request type, true.B means to write */
  val write_data = Input(UInt(xlen))
}
class Cache(cache_size: Int = 4096, line_size: Int = 32, group_size: Int = 1) extends MilkyModule { /* byte */
  val io = IO(new Bundle() {
    val req = Flipped(Decoupled(new CacheReq))
    val out = Decoupled(Output(UInt(xlen)))
    val axi4 = Flipped(new AxiLiteInterface)
  })

  val paddr = io.req.bits.paddr
  val write_data = io.req.bits.write_data
  val req_type = io.req.bits.req_type

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

  val offset = paddr(offset_width - 1, 0)
  val group_index = paddr(group_width + offset_width - 1, offset_width)
  val tag = paddr(64, 64 - tag_width + 1)
  val data = RegInit(0.U(xlen))
  val stage = RegInit(0.U(2.W))

  io.out.valid := Mux(stage === 2.U && !req_type && io.req.valid, true.B, false.B)

  // Helper function to find a hit in a set
  def setHit(setIdx: UInt): Bool = {
    VecInit((0 until group_size).map(i => cache(setIdx)(i).valid && cache(setIdx)(i).tag === tag)).asUInt.orR
  }

  val hit = RegInit(false.B)
  val way = RegInit(0.U(log2Ceil(group_size)))

  /* Cache miss related AXI4-Lite register */
  val sidle :: sendWA :: sendWD :: recvWR :: sendRA :: recvRD :: Nil = Enum(6)
  val Axi4WriteByte = RegInit(0.U(offset_width))
  val Axi4LiteState = RegInit(0.U(3.W))

  val takeover = tag(log2Ceil(group_size)-1, 0) /* 使用tag的低某位来作为index将这一组中的这一行替换掉 */

  when(stage === 0.U){
    /* at the cycle 0, check whether hit */
    hit := setHit(group_index)
    stage := 1.U
  }.elsewhen(stage === 1.U){
    val set = cache(group_index)
    when(hit) {
      /* at the cycle 1, if hit, get the way of the group, and goto cycle 2 */
      way := PriorityEncoder(VecInit((0 until group_size).map(i => set(i).valid && set(i).tag === tag)).asUInt)
      stage := 2.U
    }.otherwise {
      /* at the cycle 1, if not hit, fetch data from the memory through axi4-lite bus, then come to cycle 2*/
      /* choose a cacheline and write the data back into memory */
      /* axi4-lite fsm */
      switch(Axi4LiteState){
        is(sidle){
          io.axi4.aw.awvalid := true.B
          Axi4WriteByte := Mux(io.axi4.aw.awready, Axi4WriteByte + 8.U, Axi4WriteByte)
          Axi4LiteState := Mux(io.axi4.aw.awready, sendWA, Axi4LiteState)
          stage := 1.U
          /* 关掉之前的 */
          io.axi4.b.bready := false.B
        }
        is(sendWA){
          io.axi4.aw.awaddr := Cat(set(takeover).tag, group_index, 0.U(offset_width) + Axi4WriteByte)
          io.axi4.w.wvalid := true.B
          Axi4LiteState := Mux(io.axi4.w.wready, sendWD, Axi4LiteState)
          stage := 1.U
          /* 关掉之前的 */
          io.axi4.aw.awvalid := false.B
        }
        is(sendWD){
          io.axi4.w.wdata := set(takeover).data
          Axi4LiteState := Mux(io.axi4.b.bvalid, recvWR, Axi4LiteState)
          stage := 1.U
          /* 关掉之前的 */
          io.axi4.w.wvalid := false.B
        }
        is(recvWR){
          io.axi4.b.bready := true.B
          stage := 1.U
          Axi4LiteState := sidle
        }
      }
    }
  }.otherwise{ /* stage === 2.U */
    when(hit) {
      when(req_type){
        for (i <- 0 until 8){
          cache(group_index)(way).data(offset+i.U) := write_data(8*(i+1)-1, 8*i)
        }
      }.otherwise{
        val d = cache(group_index)(way).data
        io.out.bits := Cat(d(7.U+offset), d(6.U+offset), d(5.U+offset), d(4.U+offset), d(3.U+offset), d(2.U+offset), d(1.U+offset), d(offset))
      }
    }.otherwise{
      switch(Axi4LiteState){
        is(sidle){
          io.axi4.ar.arvalid := true.B
          Axi4LiteState := Mux(io.axi4.ar.arready, sendRA, Axi4LiteState)
          stage := 2.U
        }
        is(sendRA){
          io.axi4.ar.araddr := paddr
          Axi4LiteState := Mux(io.axi4.r.rvalid, recvRD, Axi4LiteState)
          /* 关掉之前的 */
          io.axi4.ar.arvalid := false.B
          stage := 2.U
        }
        is(recvRD){
          io.axi4.r.rready := true.B
          cache(group_index)(takeover) := io.axi4.r.rdata
          Axi4LiteState := sidle
          stage := 0.U
        }
      }
    }
  }
}
