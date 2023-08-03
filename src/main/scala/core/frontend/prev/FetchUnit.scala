package core.frontend.prev

import chisel3._
import chisel3.util.{Cat, Decoupled, Fill, MuxLookup}
import common.{MilkyBundle, MilkyModule}


/* inner funtion unit does not need ready-valid signals */
class PCGenBundle extends MilkyBundle {
  val cur_pc = Input(UInt(xlen))
  val cur_inst = Input(UInt())
  val indicator = Input(Bool())
  val next_pc = Output(UInt(xlen))
}

class PCJALGen2RegBundle extends MilkyBundle {
  val laddr = Output(UInt(regw))
  val data = Output(UInt(xlen))
}
class PCGenerator(fetch_count: Int = 2) extends MilkyModule {
  val io = IO(new Bundle() {
    val gbundle = Vec(fetch_count, new PCGenBundle)
    val jalreg = Vec(fetch_count, Decoupled(new PCJALGen2RegBundle))
  })
  // if instruction type is branch
  val npc = Vec(fetch_count, Wire(UInt(xlen)))
  for (i <- 1 until fetch_count){
    val sextImm = Cat(Fill(51, io.gbundle(i).cur_inst(31)),
      io.gbundle(i).cur_inst(31),
      io.gbundle(i).cur_inst(7),
      io.gbundle(i).cur_inst(30, 25),
      io.gbundle(i).cur_inst(11, 8),
      0.U(1.W)
    )
    npc(i) := io.gbundle(i).cur_pc + sextImm
//    npc(i) := Mux(io.gbundle(i - 1).indicator, npc(i - 1) + 4.U,
//      Mux(io.gbundle(i).indicator, io.gbundle(i).cur_pc + sextImm, io.gbundle(i).cur_pc + 4.U))
  }
  // if instruction type is jal or jalr, not support jalr yet
  val jnpc = Vec(fetch_count, Wire(UInt(xlen)))
  for (i <- 0 until fetch_count){
    val opcode = io.gbundle(i).cur_inst(6, 0)
    val rd = io.gbundle(i).cur_inst(11, 7)
    io.jalreg(i).valid := Mux(opcode === 0x6f.U, true.B, false.B)
    io.jalreg(i).bits.laddr := rd
    jnpc(i) := io.gbundle(i).cur_pc + Cat(io.gbundle(i).cur_inst(31),
      io.gbundle(i).cur_inst(19, 12),
      io.gbundle(i).cur_inst(20),
      io.gbundle(i).cur_inst(30, 21))
    io.jalreg(i).bits.data := io.gbundle(i).cur_pc + 4.U
  }

  for (i <- 1 until fetch_count){
    io.gbundle(i).next_pc := Mux(io.gbundle(i - 1).indicator,
      Mux(io.gbundle(i - 1).cur_inst(6, 0) === 0x6f.B, jnpc(i - 1) + 4.U, npc(i - 1) + 4.U),
      Mux(io.gbundle(i).indicator, Mux(io.gbundle(i).cur_inst(6, 0) === 0x6f.B, jnpc(i), npc(i)), io.gbundle(i).cur_pc + 4.U))
  }
}

class Fetch2GshareBundle extends MilkyBundle {
  val pc = Output(UInt(xlen))
}

class Gshare2FetchBundle extends MilkyBundle {
  val indicator = Output(Bool())
}

class FetchUnit(fetch_count: Int = 2) extends MilkyModule {
  val io = IO(new Bundle() {
    val icache2core = Vec(fetch_count, Flipped(Decoupled(new ICache2CoreBundle)))
    val core2icache = Vec(fetch_count, Decoupled(new Core2ICacheBundle))
    val fetch2gshare = Vec(fetch_count, Decoupled(new Fetch2GshareBundle))
    val gshare2fetch = Vec(fetch_count, Flipped(Decoupled(new Gshare2FetchBundle)))
  })

  val indicator = Vec(fetch_count, Wire(Bool()))
  /* send inst to gshare */
  for (i <- 0 until fetch_count){
    io.fetch2gshare(i).valid := Mux(io.icache2core(i).valid, MuxLookup(io.icache2core(i).bits.inst(7, 0), false.B, IndexedSeq(
      0x6f.U -> true.B,
      0x67.U -> true.B,
      0x63.U -> true.B
    )), false.B)
    io.fetch2gshare(i).bits.pc := io.icache2core(i).bits.inst
    indicator(i) := io.gshare2fetch(i).bits.indicator
  }

  val pc = RegInit(VecInit(Seq.tabulate(fetch_count)(i => (i * 4).U(64.W))))

}
