package peripheral

import chisel3._
import chisel3.util._
import common.MilkyBundle

// AXI4-Lite interface definition

class AWBundle extends MilkyBundle {
  val awaddr = Input(UInt(xlen)) // Address write channel
  val awvalid = Input(Bool()) // Valid write channel
  val awready = Output(Bool()) // Ready write channel
}

class WBundle extends MilkyBundle {
  val wdata = Input(Vec(8, UInt(8.W))) // Data write channel // 8 byte a time
  val wstrb = Input(UInt(4.W)) // Byte enable write channel
  val wvalid = Input(Bool()) // Valid write channel
  val wready = Output(Bool()) // Ready write channel
}

class BBundle extends MilkyBundle {
  val bresp = Output(UInt(2.W)) // Response write channel
  val bvalid = Output(Bool()) // Valid write channel
  val bready = Input(Bool()) // Ready write channel
}

class ARBundle extends MilkyBundle {
  val araddr = Input(UInt(xlen)) // Address read channel
  val arvalid = Input(Bool()) // Valid read channel
  val arready = Output(Bool()) // Ready read channel
}

class RBundle extends MilkyBundle {
  val rdata = Output(UInt(xlen)) // Data read channel
  val rresp = Output(UInt(2.W)) // Response read channel
  val rvalid = Output(Bool()) // Valid read channel
  val rready = Input(Bool()) // Ready read channel
}
class AxiLiteInterface extends MilkyBundle {
  val aw = new AWBundle
  val w = new WBundle
  val b = new BBundle
  val ar = new ARBundle
  val r = new RBundle
}