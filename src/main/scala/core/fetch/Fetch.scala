package core.fetch
import chisel3._
import chisel3.util.MuxCase
import common.Defines

class Fetch extends Module {
  val io = IO(new Bundle() {
    val ctrl_stallFlag = Input(Bool())
    val jumpFlag = Input(Bool())
    val jumpAddress = Input(UInt(Defines.instAddrWidth))
    val rom_instruction = Input(UInt(Defines.instructionWidth))
    // val instruction_valid = Input(Bool())
    val instruction_address = Output(UInt(Defines.instAddrWidth))
    val instruction_id = Output(UInt(Defines.instructionWidth))
  })
  val progCounter = RegInit(Defines.entryPC)

  progCounter := MuxCase(progCounter + 4.U(Defines.instAddrWidth), IndexedSeq(
    io.ctrl_stallFlag -> progCounter,
    (io.jumpFlag && !io.ctrl_stallFlag) -> io.jumpAddress
  ))

  io.instruction_address := progCounter
  io.instruction_id := io.rom_instruction
}
