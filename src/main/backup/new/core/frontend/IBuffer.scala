package core.frontend
import chisel3._
import chisel3.util.{Decoupled, Queue}
import common.InstFlowIO
import core.CoreConfig
import core.backend.outoforder.ROB2iBuf

class InstFetchIO extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val pnext_pc = Output(UInt(addrwidth)) // predicted next pc
  val cur_instruction = Output(UInt(instwidth))
  val pnext_instruction = Output(UInt(instwidth)) // predict next instruction
}
class IBufferInstInIO extends Bundle with CoreConfig {
  val pc = UInt(addrwidth)
  val instruction = UInt(instwidth)
}
class IBuffer2ROB extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val pnext_pc = Output(UInt(addrwidth))
}
class IBuffer2DecodeIO extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val cur_instruction = Output(UInt(instwidth))
  val cur_entry = Output(UInt(robwidth))
  val pnext_pc = Output(UInt(addrwidth))
  val pnext_instruction = Output(UInt(instwidth))
  val pnext_entry = Output(UInt(robwidth))
}
class IBuffer extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val flush = Input(Bool())
    val in = Flipped(Decoupled(new InstFetchIO))
    val out2rob = Decoupled(new IBuffer2ROB)
    val robin = Flipped(Decoupled(new ROB2iBuf(entities = 8)))
    val out2decode = Decoupled(new IBuffer2DecodeIO)
  })

  val cur_instBundle = Wire(new IBufferInstInIO)
  val pnext_instBundle = Wire(new IBufferInstInIO)

  cur_instBundle.pc := io.in.bits.cur_pc
  cur_instBundle.instruction := io.in.bits.cur_instruction
  pnext_instBundle.pc := io.in.bits.pnext_pc
  pnext_instBundle.instruction := io.in.bits.pnext_instruction

  // To ROB
  io.out2rob.bits.cur_pc := cur_instBundle.pc
  io.out2rob.bits.pnext_pc := pnext_instBundle.pc

  // To Decode
  io.out2decode.bits.cur_pc := cur_instBundle.pc
  io.out2decode.bits.cur_instruction := cur_instBundle.instruction
  io.out2decode.bits.cur_entry := io.robin.bits.cur_entry
  io.out2decode.bits.pnext_instruction := pnext_instBundle.instruction
  io.out2decode.bits.pnext_pc := pnext_instBundle.pc
  io.out2decode.bits.pnext_entry := io.robin.bits.pnext_entry
}
