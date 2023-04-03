package core.frontend
import chisel3._
import chisel3.util.{Decoupled, MuxCase, PriorityEncoder, PriorityEncoderOH, PriorityMux}
import common.{CtrlSignalIO, FunctUType}
import core.CoreConfig
// 32 logic reg in total, 64 physical reg in total
// 0号逻辑寄存器映射到0号物理寄存器
class RenameOut extends Bundle with CoreConfig {
  val src1Type = Output(UInt(2.W))
  val src2Type = Output(UInt(2.W))
  val functOp = Output(UInt(4.W))
  val reg1Addr = Output(UInt(physical_regaddrwidth))
  val reg2Addr = Output(UInt(physical_regaddrwidth))
  val immediate = Output(UInt(datawidth))
  val destAddr = Output(UInt(physical_regaddrwidth))
}
class Rename extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val in = Flipped(Decoupled(new DecodeOutIO))
    val out2alu = Decoupled(new RenameOut)
    val out2csru = Decoupled(new RenameOut)
    val out2lsu = Decoupled(new RenameOut)
  })
  val map_table = Reg(Vec(32, UInt(regaddrwidth)))
  val free_list = Reg(Vec(64, Bool()))
  val busy_table = Reg(Vec(64, Bool()))
  // val remap_table = RegInit(VecInit(Seq.fill(32)(0.U(6.W))))

  when(reset.asBool){ // 初始化map table
    for (i <- 0 until 32){
      map_table(i) := i.U(6.W)
      free_list(i) := false.B
      busy_table(i) := false.B
    }
    for (i <- 33 until 64){
      free_list(i) := true.B
      busy_table(i) := false.B
    }
  }

  // find an idle physical register
  val destidx = PriorityEncoder(free_list)

  // 更新free_list
  // todo: As types of functional unit increase, Mux condition should change with more OR-gate
  free_list(destidx) := Mux(io.out2alu.valid || io.out2lsu.valid || io.out2csru.valid, false.B, free_list(destidx))

  // 发射到ALU
  // 判断是否能发射
  io.out2alu.valid := !busy_table(io.in.bits.path.reg1Addr) && !busy_table(io.in.bits.path.reg2Addr) && (io.in.bits.path.functU === FunctUType.alu)
  io.out2alu.bits.functOp := io.in.bits.path.functOp
  io.out2alu.bits.src1Type := io.in.bits.path.src1Type
  io.out2alu.bits.src2Type := io.in.bits.path.src2Type
  io.out2alu.bits.reg1Addr := map_table(io.in.bits.path.reg1Addr)
  io.out2alu.bits.reg2Addr := map_table(io.in.bits.path.reg2Addr)
  io.out2alu.bits.immediate := io.in.bits.path.immediate
  io.out2alu.bits.destAddr := destidx

  // 发射到LSU
  io.out2lsu.valid := !busy_table(io.in.bits.path.reg1Addr) && !busy_table(io.in.bits.path.reg2Addr) && (io.in.bits.path.functU === FunctUType.alu)
  io.out2lsu.bits.functOp := io.in.bits.path.functOp
  io.out2lsu.bits.src1Type := io.in.bits.path.src1Type
  io.out2lsu.bits.src2Type := io.in.bits.path.src2Type
  io.out2lsu.bits.reg1Addr := map_table(io.in.bits.path.reg1Addr)
  io.out2lsu.bits.reg2Addr := map_table(io.in.bits.path.reg2Addr)
  io.out2lsu.bits.immediate := io.in.bits.path.immediate
  io.out2lsu.bits.destAddr := destidx
}

