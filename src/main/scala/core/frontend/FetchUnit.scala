package core.frontend
import chisel3._
import common.MilkyModule

class PCGenerator extends MilkyModule{
  val io = IO(new Bundle() {
    val bp = Input(Bool())
    val cur_inst = Input(UInt(ilen))
    val next_pc = Output(UInt(xlen))
  })

/* pc is initialized as 0 when the machine is powered,
   then bootloader will direct pc to 0x800000000.
 */
  val pc = RegInit(0.U(xlen))
  val npc = Mux(io.bp, io.next_pc, pc)

  io.cur_pc := pc
}

class FetchUnit extends MilkyModule {

}