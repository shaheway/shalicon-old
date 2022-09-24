import chisel3._
class RegisterModule extends Module {
  val io = IO(new Bundle {
    val in  = Input(UInt(12.W))
    val out = Output(UInt(12.W))
  })

  val register = Reg(UInt(12.W))
  register := io.in + 1.U
  io.out := register
}

object RegisterModule extends App{
  test(new RegisterModule) { c =>
    for (i <- 0 until 100) {
      c.io.in.poke(i.U)
      c.clock.step(1)
      c.io.out.expect((i + 1).U)
    }
  }
  println("SUCCESS!!")
}

