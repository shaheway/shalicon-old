package core
import chisel3._

trait CoreConfig {
  val xlen = 64.W
  val datawidth = 64.W
  val instwidth = 32.W
  val regaddrwidth = 5.W
  val physical_regaddrwidth = 6.W
  val addrwidth = 64.W
  val resetVector = 0x60000000L.U(addrwidth)
  val robwidth = 3.W
}

class Core extends Module with CoreConfig {

}
