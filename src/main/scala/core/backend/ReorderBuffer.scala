package core.backend

import chisel3._
import chisel3.util._
import common.{MilkyBundle, MilkyModule}

class RobEntry extends MilkyBundle {
  val valid = Bool()         // Indicates if the entry is valid
  val ready = Bool()         // Indicates if the instruction is ready to commit
  val inst = UInt(ilen)  // The instruction itself
}

class RobChange extends MilkyBundle {
  val inst = UInt(ilen)
  val ready = Bool()
}

// Define the ROB
class ReorderBuffer(val size: Int, val enqWidth: Int) extends Module {
  val io = IO(new Bundle {
    val enq = Flipped(Vec(enqWidth, Decoupled(new RobEntry)))  // Enqueue interface
    val deq = Decoupled(new RobEntry)           // Dequeue (commit) interface
    val chg = Decoupled(new RobChange)
  })

  // The actual buffer, implemented as a queue
  val buffer = Module(new Queue(new RobEntry, size))

  // Connect the dequeue (commit) interface
  io.deq <> buffer.io.deq

  // Only allow commit (dequeue) if the instruction is ready
  buffer.io.deq.ready := io.deq.ready && io.deq.bits.ready

  // Connect the enqueue interface
  for (i <- 0 until enqWidth) {
    buffer.io.enq.valid := io.enq(i).valid
    buffer.io.enq.bits := io.enq(i).bits
    io.enq(i).ready := buffer.io.enq.ready
  }

  when(io.chg.valid){
    for (i <- 0 until size){
      buffer(i)
    }
  }
}
