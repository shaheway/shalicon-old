package core.pipeline.regs
import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}

class Template extends Module {
  val io = IO(new Bundle() {
    val flushEnable = Input(Bool())
    val in = Flipped(new )
    val out2 = Decoupled(new )
  })

  // Pipeline bus
  val outport = io.out2
  val idle :: busy :: Nil = Enum(2)
  val state = RegInit(idle)
  state := MuxLookup(state, idle, IndexedSeq(
    idle -> Mux(outport.valid, busy, idle),
    busy -> Mux(outport.fire, idle, busy) // fire = valid & ready
  ))
  val valid = RegInit(true.asBool)
  outport.valid := valid

  val pRegWriteEnable = MuxLookup(state, false.asBool, IndexedSeq(
    idle -> true.asBool,
    busy -> false.asBool
  ))

}
