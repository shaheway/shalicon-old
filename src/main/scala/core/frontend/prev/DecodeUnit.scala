package core.frontend.prev

import chisel3._
import chisel3.util.{Cat, Decoupled, Fill}
import common._

class Fetch2DecodeBundle extends MilkyBundle {
  val inst = Output(UInt(ilen))
}

class DecoderOut extends MilkyBundle {
  val optype = Output(UInt(5.W))
  val unitid = Output(UInt(3.W))
  val ope = Output(UInt(3.W)) // using ope to further detect inst type
  val imm = Output(UInt())
  val rs1 = Output(UInt(5.W))
  val rs2 = Output(UInt(5.W))
  val rd = Output(UInt(5.W))
}
class Decoder extends MilkyModule {
  val io = IO(new Bundle() {
    val inst = Input(UInt(ilen))
    val out = new DecoderOut
  })

  val ImmI = Cat(Fill(52, io.inst(31)), io.inst(31, 20))
  val ImmS = Cat(Fill(52, io.inst(31)), io.inst(31, 25), io.inst(11, 7))
  val ImmB = Cat(Fill(51, io.inst(31)), io.inst(31), io.inst(7), io.inst(30, 25), io.inst(11, 8), 0.U(1.W))
  val ImmU = Cat(Fill(32, io.inst(31)), io.inst(31, 12), 0.U(12.W))
  val ImmJ = Cat(Fill(42, io.inst(31)), io.inst(31), io.inst(19, 12), io.inst(20), io.inst(30, 21), 0.U(1.W))

  val opcode = io.inst(6, 0)

  val funct3 = io.inst(14, 12)

  val funct7 = io.inst(31, 25)
  io.out.optype := MuxLookup(opcode, 0.U, IndexedSeq(
    // todo: fence and eceb
    InstType32i.lui -> Cat(1.U(2.W), 3.U(3.W)),
    InstType32i.auipc -> Cat(0.U(2.W), 0.U(3.W)),
    InstType32i.jal -> Cat(0.U(2.W), 1.U(3.W)),
    InstType32i.jalr -> Cat(0.U(2.W), 2.U(3.W)),
    InstType32i.btype -> Cat(1.U(2.W), funct3),
    InstType32i.ltype -> Cat(0.U(2.W), funct3),
    InstType32i.stype -> Cat(1.U(2.W), funct3),
    InstType32i.itype -> Cat(0.U(2.W), funct3),
    InstType32i.rtype -> Cat(2.U(2.W), funct3),
    InstType64i.iwtype -> Cat(1.U(2.W), funct3), // share high 2-bit with lui
    InstType64i.rwtype -> Cat(3.U(2.W), funct3),
    csrType -> funct3
  ))

  io.out.unitid := MuxLookup(opcode, FuID.ignore, IndexedSeq(
    // todo: fence and eceb
    InstType32i.lui -> FuID.alu,
    InstType32i.auipc -> FuID.bru,
    InstType32i.jal -> FuID.bru,
    InstType32i.jalr -> FuID.bru,
    InstType32i.btype -> FuID.bru,
    InstType32i.ltype -> FuID.lsu,
    InstType32i.stype -> FuID.lsu,
    InstType32i.itype -> FuID.alu,
    InstType32i.rtype -> FuID.alu,
    InstType64i.iwtype -> FuID.alu,
    InstType64i.rwtype -> FuID.alu,
    csrType -> FuID.csru
  ))

  io.out.ope := Cat(funct7(7, 6), funct7(0))
  io.out.imm := MuxLookup(opcode, 0.U, IndexedSeq(
    InstType32i.lui -> ImmU,
    InstType32i.auipc -> ImmU,
    InstType32i.jal -> ImmJ,
    InstType32i.jalr -> ImmJ,
    InstType32i.btype -> ImmB,
    InstType32i.ltype -> ImmI,
    InstType32i.stype -> ImmS,
    InstType32i.itype -> ImmI,
    InstType64i.iwtype -> ImmI,
    csrType -> ImmI // use ImmI to indicate csr address
  ))

  io.out.rs1 := io.inst(19, 15)
  io.out.rs2 := io.inst(24, 20)
  io.out.rd := io.inst(11, 7)
}
class DecodeUnit(fetch_count: Int = 2) extends MilkyModule{
  val io = IO(new Bundle() {
    val insts = Vec(fetch_count, Decoupled(new Fetch2DecodeBundle))
    val decodeOut = Vec(fetch_count, Decoupled(new DecoderOut))
  })

}
