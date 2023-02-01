package core.frontend
import chisel3._
import chisel3.util.{Decoupled, MuxCase, PriorityEncoder, PriorityEncoderOH, PriorityMux}
import common.CtrlSignalIO
import core.CoreConfig
// 32 logic reg in total, 64 physical reg in total
// 0号逻辑寄存器映射到0号物理寄存器
class RenameOut extends Bundle with CoreConfig {
  val src1Type = Output(UInt(2.W))
  val src2Type = Output(UInt(2.W))
  val functOp = Output(UInt(4.W))
  val reg1Addr = Output(UInt(physical_regaddrwidth))
  val reg2Addr = Output(UInt(physical_regaddrwidth))
  val imm = Output(UInt(datawidth))
  val destAddr = Output(UInt(physical_regaddrwidth))
}
class Rename extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val in = Flipped(Decoupled(new CtrlSignalIO))
    val out = Decoupled(new RenameOut)
  })
  val map_table = Reg(Vec(32, UInt(regaddrwidth)))
  val free_list = Reg(Vec(64, Bool()))
  val busy_table = Reg(Vec(64, Bool()))
  val remap_table = RegInit(VecInit(Seq.fill(32)(0.U(6.W))))

  when(reset.asBool){ // 初始化map table
    for (i <- 0 until 32){
      map_table(i) := i.U(6.W)
      free_list(i) := false.B
      busy_table(i) := false.B
    }
    for (i <- 33 until 63){
      free_list(i) := true.B
      busy_table(i) := false.B
    }
  }

  io.out.bits.functOp := io.in.bits.functOp
  io.out.bits.src1Type := io.in.bits.src1Type
  io.out.bits.src2Type := io.in.bits.src2Type
  io.out.bits.imm := 0.U(datawidth) // todo
  io.out.bits.reg1Addr := map_table(io.in.bits.reg1Addr)
  io.out.bits.reg2Addr := map_table(io.in.bits.reg2Addr)

  // find an idle physical register
  val destidx = PriorityEncoder(free_list)
  io.out.bits.destAddr := destidx

  // 判断是否能发射
  io.out.valid := !busy_table(io.in.bits.reg1Addr) && !busy_table(io.in.bits.reg2Addr)

  // 更新free_list
  free_list(destidx) := Mux(io.out.valid, false.B, free_list(destidx))
}

