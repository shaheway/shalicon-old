package core.frontend

import chisel3._
import common.FUConstants

class IssueUnitIO(issueWidth: Int, num_wakeupPorts: Int, dispatchWidth: Int) extends Bundle {
  val dispatch_valids = Input(Vec(dispatchWidth, Bool()))
  val dispatch_uops = Input(Vec(dispatchWidth, new MicroOp))
  val dispatch_readys = Output(Vec(dispatchWidth, Bool()))
  val issue_valids = Output(Vec(issueWidth, Bool()))
  val issue_uops = Output(Vec(issueWidth, new MicroOp))
  // todo val wakeupPorts = Vec(num_wakeupPorts, Valid())

  /* tell the issue unit what each execution pipeline has in terms of functional units */
  val fu_types = Input(Vec(issueWidth, Bits(width = FUConstants.functionSize)))
  val branch_info = Input(new Bran)
  val flush_pipeline = Input(Bool())
  val event_empty = Output(Bool()) // used by HPM events; is the issue unit empty?
  // todo: val tsc_reg = Input(UInt(xLen))
}

abstract class IssueUnit(num_issueSlots: Int, issueWidth: Int, num_wakeupPorts: Int, dispatchWidth) extends Module {
  val io = new IssueUnitIO(issueWidth = issueWidth, num_wakeupPorts = num_wakeupPorts)
  val dispatch_uops = Array.fill(dispatchWidth) {Wire(new MicroOp)}
  for (w <- 0 until dispatchWidth){
    dispatch_uops(w) := io.dispatch_uops(w)
    dispatch_uops(w) := //todo
  }

  /* Issue Table */
  val issueSlots = Vec(num_issueSlots, new IssueSlot(num_wakeupPorts).io)
}