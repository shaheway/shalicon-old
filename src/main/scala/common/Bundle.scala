package common

import chisel3._
import core.CoreConfig

class RedirectIO extends Bundle with CoreConfig {
  val target = Output(UInt(addrwidth))
  // 1: branch predict fails -> flush frontend
  // 2: flush the whole pipeline
  val rtype = Output(UInt(1.W))
  val valid = Output(Bool())
}

class InstFlowIO extends Bundle with CoreConfig {
  val instruction = Output(UInt(instwidth))
  val pc = Output(UInt(addrwidth))
}

class ROBInIO extends Bundle with CoreConfig {
  val
}

class CtrlSignalIO extends Bundle with CoreConfig {
  val src1Type = Output(UInt(2.W))
  val src2Type = Output(UInt(2.W))
  val functU = Output(UInt(2.W))
  val functOp = Output(UInt(4.W))
  val reg1Addr = Output(UInt(2.W))
  val reg2Addr = Output(UInt(2.W))
}

class DecodeOutIO extends Bundle with CoreConfig {
  val ctrlSignal = new CtrlSignalIO
  val ctrlFlow = new CtrlFlowIO
}

class InstFetchIO extends Bundle with CoreConfig {
  val cur_pc = Output(UInt(addrwidth))
  val pnext_pc = Output(UInt(addrwidth)) // predicted next pc
  val cur_instruction = Output(UInt(instwidth))
  val pnext_instruction = Output(UInt(instwidth)) // predict next instruction
}