package common
import chisel3._
import os.CommandResult

trait CoreConfig {
  val memaddr_width = 64.W
  val xlen = 64.W
  val regw = 5.W
  val ilen = 32.W
}

abstract class MilkyModule extends Module with CoreConfig

abstract class MilkyBundle extends Bundle with CoreConfig