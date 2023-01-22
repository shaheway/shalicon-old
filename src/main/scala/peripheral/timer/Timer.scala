package peripheral.timer
import chisel3._
import chisel3.util.MuxLookup
import core.common.Defines
import peripheral.memory.RAMBundle

class Timer extends Module {
  val io = IO(new Bundle() {
    val ramBundle = new RAMBundle
    val interrupt_signal = Output(Bool())
  })
  val count = RegInit(0.U(Defines.dataWidth))
  val limit = RegInit(10000000.U(Defines.dataWidth))
  val enable = RegInit(false.asBool)
  io.ramBundle.dataReadResult := MuxLookup(io.ramBundle.memAccessAddr, 0.U(Defines.dataWidth), IndexedSeq(
    0x80000004.U(Defines.dataAddrWidth) -> limit,
    0x80000008.U(Defines.dataAddrWidth) -> enable
  ))
  when(io.ramBundle.memWriteEnable){
    when(io.ramBundle.memAccessAddr === 0x80000004.U(Defines.dataAddrWidth)){
      count := 0.U(Defines.dataWidth)
      limit := io.ramBundle.dataWriteData
    }.elsewhen(io.ramBundle.memAccessAddr === 0x80000008.U(Defines.dataAddrWidth)){
      enable := (io.ramBundle.dataWriteData =/= 0.U(Defines.dataWidth))
    }
  }

  when(count >= limit){
    count := 0.U(Defines.dataWidth)
  }.otherwise{
    count := count + 1.U(Defines.dataWidth)
  }

  io.interrupt_signal := enable && (count >= (limit - 10.U(Defines.dataWidth)))
}
