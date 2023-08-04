package peripheral

import chisel3._
import chisel3.util.{Enum, is, log2Ceil, switch}
trait TileLinkConfig {
  val dataWidth = 64.W // Data width in bits
  val addrWidth = 64.W // Address width in bits
  val burstSize = 8 // Burst size in beats
}
class TLChannel extends Bundle with TileLinkConfig {
  val addr = Output(UInt(addrWidth))
  val data = Output(UInt(dataWidth))
  val valid = Output(Bool())
  val ready = Input(Bool())
}

class TLRequest extends TLChannel {
  val burstLen = Output(UInt(log2Ceil(burstSize).W))
  val beat = Output(UInt(log2Ceil(burstSize).W))
}

class TLResponse extends TLChannel {
  val ack = Input(Bool())
}

class TileLinkModule extends Module with TileLinkConfig {
  val io = IO(new Bundle {
    val in = Flipped(new TLRequest)
    val out = new TLResponse
  })

  val addrReg = Reg(UInt(addrWidth))
  val dataReg = Reg(UInt(dataWidth))
  val beatReg = Reg(UInt(log2Ceil(burstSize).W))
  val burstLenReg = Reg(UInt(log2Ceil(burstSize).W))

  val idle :: burst :: response :: Nil = Enum(3)
  val stateReg = RegInit(idle)

  io.in.ready := stateReg === idle || stateReg === response

  switch(stateReg) {
    is(idle) {
      when(io.in.valid && io.in.ready) {
        addrReg := io.in.addr
        dataReg := io.in.data
        beatReg := 0.U
        burstLenReg := io.in.burstLen
        stateReg := burst
      }
    }
    is(burst) {
      when(io.out.ready) {
        dataReg := io.in.data
        beatReg := beatReg + 1.U
        when(beatReg === (burstLenReg - 1.U)) {
          stateReg := response
        }
      }
    }
    is(response) {
      when(io.out.ack) {
        stateReg := idle
      }
    }
  }

  io.out.addr := addrReg
  io.out.data := dataReg
  io.out.valid := stateReg === response
}
