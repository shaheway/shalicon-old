package utils
import chisel3._

object BoolStopWatch {
  def apply(start: Bool, stop: Bool, startPrivileged: Boolean = false) = {
    val r = RegInit(false.B)
    if (startPrivileged){
      when(stop) { r := false.B }
      when(start) { r := true.B }
    }
    else {
      when(start) { r := true.B }
      when(stop) { r := false.B }
    }
    r // return r
  }
}
