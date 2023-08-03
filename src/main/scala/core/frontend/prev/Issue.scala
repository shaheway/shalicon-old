package core.frontend

import Chisel.Valid
import chisel3._
import common.MilkyModule

class Issue extends MilkyModule {

}

class RenameUnit extends MilkyModule {
  val io = IO(new Bundle {
    val archReg = Input(UInt(5.W))  // The architectural register to rename
    val physReg = Output(UInt(6.W)) // The physical register that the architectural register maps to
    val update = Flipped(Valid(new Bundle { // Update the mapping from an architectural register to a physical register
      val archReg = UInt(5.W)
      val physReg = UInt(6.W)
    }))
  })

  // The register file
  val regFile = RegInit(VecInit(Seq.fill(32)(0.U(6.W))))

  // On a rename request, output the physical register that the architectural register maps to
  io.physReg := regFile(io.archReg)

  // On an update, update the mapping from the architectural register to the physical register
  when(io.update.valid) {
    regFile(io.update.bits.archReg) := io.update.bits.physReg
  }
}