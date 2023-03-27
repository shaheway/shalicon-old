package core.frontend
import chisel3._
import chisel3.util.{Decoupled, Valid, is, switch}
import common.{CtrlFlowIO, RedirectIO}
import core.CoreConfig
import utils.BoolStopWatch

class BTBSRAMRead extends Bundle {

}

class BTBSRAMWrite extends Bundle {

}

class BTBSRAM extends Module {
  val io = IO(new Bundle() {
    val read = Flipped(new BTBSRAMRead)
    val write = Flipped(new BTBSRAMWrite)
  })

  val sram = SyncReadMem(32, UInt(129.W))

}
object StateList {
  val idle = 0x0.U(2.W)
  val extra = 0x1.U(2.W)
  val waitnext = 0x2.U(2.W)
  val wait_andjump = 0x3.U(2.W)
}

class BranchPredict extends Module with CoreConfig{
  val io = IO(new Bundle() {
    val inpc = Valid(UInt(addrwidth))
    val out = new RedirectIO
    val flush = Input(Bool())
    val crosslineJump = Output(Bool())
  })

  val flush = BoolStopWatch(io.flush, io.in.pc.valid, startPrivileged = true)

  // Branch Target Buffers - BTB
  val btb = Module(new BTBSRAM)
  // Flush BTB when executing fence.i
  val flushBTB = WireInit(false.B)
  val flushTLB = WireInit(false.B)

  btb.reset := reset.asBool || flushBTB || flushTLB
}
