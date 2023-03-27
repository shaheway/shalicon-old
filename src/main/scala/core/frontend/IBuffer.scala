package core.frontend
import chisel3._
import chisel3.util.Decoupled
import core.CoreConfig

class Icc2ibuf extends Bundle with CoreConfig { // Instruction Cache to instruction buffer
  val cur_instruction = Output(UInt(instwidth))
  val cur_pc = Output(UInt(addrwidth))
  val pnext_instruction = Output(UInt(instwidth))
  val pnext_pc = Output(UInt(addrwidth))
}

class Ibuf2dec extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val cur_instruction = Output(UInt(instwidth))
  val cur_entry = Output(UInt(robwidth))
  val pnext_pc = Output(UInt(addrwidth))
  val pnext_instruction = Output(UInt(instwidth))
  val pnext_entry = Output(UInt(robwidth))
}

class Ibuf2rob extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val pnext_pc = Output(UInt(addrwidth))
}

class Rob2ibuf extends Bundle with CoreConfig {
  val cur_entry = Output(UInt(robwidth))
  val pnext_entry = Output(UInt(robwidth))
}
class IBuffer extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val flush = Input(Bool())
    val icc2buf = Decoupled(Flipped(new Icc2ibuf))
    val ibuf2rob = Decoupled(new Ibuf2rob)
    val rob2ibuf = Decoupled(Flipped(new Rob2ibuf))
    val ibuf2dec = Decoupled(new Ibuf2dec)
  })

  // Pre-decode buffer与rob连接，传递cur_pc和pnext_pc
  io.ibuf2rob.bits.cur_pc := io.icc2buf.bits.cur_pc
  io.ibuf2rob.bits.pnext_pc := io.icc2buf.bits.pnext_pc

  io.ibuf2dec.bits.cur_pc := io.icc2buf.bits.cur_pc
  io.ibuf2dec.bits.cur_instruction := io.icc2buf.bits.cur_instruction
  io.ibuf2dec.bits.cur_entry := io.rob2ibuf.bits.cur_entry

  io.ibuf2dec.bits.pnext_pc := io.icc2buf.bits.pnext_pc
  io.ibuf2dec.bits.pnext_instruction := io.icc2buf.bits.pnext_instruction
  io.ibuf2dec.bits.pnext_entry := io.rob2ibuf.bits.pnext_entry
}
