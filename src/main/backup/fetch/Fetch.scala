package core.fetch
import chisel3._
import chisel3.util.{Decoupled, MuxCase}
import common.Defines

class Fetch extends Module {
  val io = IO(new Bundle() {
    val ctrl_stallFlag = Input(Bool())
    val jumpFlag = Input(Bool())
    val jumpAddress = Input(UInt(Defines.instAddrWidth))
    val rom_instruction = Input(UInt(Defines.instructionWidth))
    // val instruction_valid = Input(Bool())
    val out2id = new FetchOutBundle
  })
  val progCounter = RegInit(Defines.entryPC)

  progCounter := MuxCase(progCounter + 4.U(Defines.instAddrWidth), IndexedSeq(
    io.ctrl_stallFlag -> progCounter,
    (io.jumpFlag && !io.ctrl_stallFlag) -> io.jumpAddress
  ))

  io.out2id.instruction_address := progCounter
  io.out2id.instruction_id := io.rom_instruction


}
