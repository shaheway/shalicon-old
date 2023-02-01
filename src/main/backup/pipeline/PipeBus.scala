package core.pipeline
import chisel3._
import chisel3.util.{Decoupled, Enum, MuxLookup}

class PipeBus(port: Bundle) extends Module {
  val io = IO(new Bundle() {
    val inport = Decoupled(port)
  })
  val idle :: busy :: Nil = Enum(2)
  val state = RegInit(idle)
  state := MuxLookup(state, idle, IndexedSeq(
    idle -> Mux(io.inport.valid, busy, idle),
    busy -> Mux(io.inport.fire, idle, busy) // fire = valid & ready
  ))
}