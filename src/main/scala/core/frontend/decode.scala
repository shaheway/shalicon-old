package core.frontend
import chisel3._
import chisel3.util.BitPat

abstract trait ControlSignals {
  def decode_result: List[BitPat] =
    List()
}
class Decode extends Module {

}
