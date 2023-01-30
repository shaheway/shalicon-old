package utils
import chisel3._
import chisel3.util.{Decoupled, log2Up}

class SRAMBundleA(val set: Int) extends Bundle {
  val setIdx = Output(UInt(log2Up(set).W))
  def apply(setIdx: UInt) = {
    this.setIdx := setIdx
    this
  }
}

class SRAMBundleAW[T <: Data](private val gen: T, set: Int, val way: Int = 1) extends SRAMBundleA(set){
  val data = Output(gen)
  // val waymask = None // suppose way will not > 1

  def apply(data: T, setIdx: UInt, waymask: UInt) = {
    super.apply(setIdx)
    this.data := data
    // this.waymask.map(_ := waymask)
    this
  }
}

class SRAMBundleR[T <: Data](private val gen: T, val way: Int = 1) extends Bundle{
  val data = Output(Vec(way, gen))
}

class SRAMReadBus[T <: Data](private val gen: T, val set: Int, val way: Int = 1) extends Bundle {
  val request = Decoupled(new SRAMBundleA(set))
  val response = Decoupled(new SRAMBundleR(gen, way))
  def apply(valid: Bool, setIdx: UInt) = {
    this.request.bits.apply(setIdx)
    this.request.valid := valid
    this
  }
}

class SRAMWriteBus[T <: Data](private val gen: T, val set: Int, val way: Int = 1) extends Bundle {
  val response = Decoupled(new SRAMBundleAW(gen, set, way))

  def apply(valid: Bool, data: T, setIdx: UInt, waymask: UInt) = {
    this.response.bits.apply(data = data, setIdx = setIdx, waymask = waymask)
    this.response.valid := valid
    this
  }
}

class SRAMTemplate[T <: Data](gen: T, set: Int, way: Int = 1, should_reset:  Boolean = false, hold_read: Boolean = false, single_port: Boolean = false) extends Module {
  val io = IO(new Bundle{
    val read = Flipped(new SRAMReadBus(gen, set, way))
    val write = Flipped(new SRAMWriteBus(gen, set, way))
  })

  val sram = SyncReadMem(set, Vec(way, 8.W))
}
