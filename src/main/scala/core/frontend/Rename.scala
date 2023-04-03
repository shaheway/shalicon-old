package core.frontend
import chisel3._
import chisel3.util.PriorityEncoder
import core.CoreConfig

class Rename extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val in =
  })

  val phyRegister = Reg(VecInit(Seq.fill(64)(0.U(datawidth))))
  val mapTable = Reg(VecInit((1 to 32) map {i => i.U(physical_regaddrwidth)}))
  val freeList = Reg(Vec(2, Vec(32, Bool()))) // freeList为0表示已被占用
  val readableList = Reg(Vec(2, Vec(32, Bool()))) // readableList为1表示可以读

  when(reset.asBool){
    for (i <- 0 until 32){
      freeList(0)(i) := true.B
      readableList(0)(i) := true.B
      freeList(1)(i) := true.B
      readableList(1)(i) := true.B
    }
  }

  val freeidx0 = PriorityEncoder(freeList(0)) // 为cur找到第一个可以分配的寄存器
  val freeidx1 = PriorityEncoder(freeList(1)) // 为pnext找到第一个可以分配的寄存器
  val listBool0 = (freeList(0).asUInt === 0.U)
  val listBool1 = (freeList(1).asUInt === 0.U)
  // 更新freeList
  freeList(freeidx0) := 
}

