package connect

import chisel3._
class IntroIO extends Bundle {
  val inx = Input(UInt(32.W))
  val outx = Output(UInt(32.W))
}

class Px extends Module {
  val io = IO(new IntroIO)
}

class Py extends Module {
  val io = Flipped(new IntroIO)
}
class Top extends Module {
  val PX = Module(new Px)
  val PY = Module(new Py)
  PX.io <> PY.io
}