import Pipline.{CSR, Decode, Execute, InstFetch, MemAccess, Memory, Regs, WriteBack}
import chisel3._
import chiseltest._
import org.scalatest._
import common.Defines._
import firrtl.Utils.True
class Top extends Module {
  val io = IO(new Bundle() {
    val probe = Output(UInt(WORD_LEN_WIDTH)) // 测试用
    val exit = Output(Bool())
  })
  val module_inst_fetch = Module(new InstFetch)
  val module_decode = Module(new Decode)
  val module_execute = Module(new Execute)
  val module_memory_access = Module(new MemAccess)
  val module_write_back = Module(new WriteBack)

  val module_reg = Module(new Regs)
  val module_csr = Module(new CSR)
  val module_memory = Module(new Memory)

  // 连接取值阶段与指令内存
  module_inst_fetch.io.inst_mem <> module_memory.io.imem
  // 连接取指阶段与执行阶段：跳转、分支alu_out等
  module_inst_fetch.io.exio <> module_execute.io.exifIO
  // 连接取指阶段对CSR的读取
  module_inst_fetch.io.csr_read <> module_csr.io.read1IO
  // 连接取指阶段与译码阶段
  module_inst_fetch.io.passby <> module_decode.io.extend
  // 连接译码阶段与寄存器
  module_decode.io.regs <> module_reg.io.regReadIO
  // 连接译码阶段与执行阶段
  module_decode.io.passby <> module_execute.io.extend
  // 连接执行阶段与访存阶段
  module_execute.io.passby <> module_memory_access.io.extend
  // 连接访存与CSR
  module_memory_access.io.csr_read <> module_csr.io.read2IO
  module_memory_access.io.csr_write <> module_csr.io.writeIO
  // 连接访存与内存
  module_memory_access.io.mem_write <> module_memory.io.awrite
  module_memory_access.io.mem_read <> module_memory.io.aread
  // 连接访存与写回
  module_memory_access.io.passby <> module_write_back.io.extend
  // 连接写回与寄存器文件
  module_write_back.io.regIO <> module_reg.io.regWriteIO
  //测试用
  // IO & Debug
  io.probe := module_reg.io.probe
  io.exit := (module_inst_fetch.if_inst === UNIMP)
  printf(p"if_reg_pc        : 0x${Hexadecimal(module_inst_fetch.io.passby.if_pc_reg)}\n")
  printf(p"id_reg_pc        : 0x${Hexadecimal(module_decode.io.passby.id_pc_reg)}\n")
  // printf(p"id_reg_inst      : 0x${Hexadecimal(module_decode.io.passby.)}\n")
  printf(p"exe_reg_pc       : 0x${Hexadecimal(module_execute.io.passby.exe_pc_reg)}\n")
  printf(p"exe_reg_op1_data : 0x${Hexadecimal(module_execute.io.passby.op1_data)}\n")
  printf(p"exe_reg_rs2_data : 0x${Hexadecimal(module_execute.io.passby.rs2_data)}\n")
  printf(p"exe_alu_out      : 0x${Hexadecimal(module_execute.io.passby.alu_out)}\n")
  // printf(p"mem_reg_pc       : 0x${Hexadecimal(module_execute.io.passby.mem_pc_reg)}\n")
  printf(p"reg_wb_data      : 0x${Hexadecimal(module_memory_access.io.passby.reg_wb_data)}\n")
  printf(p"register at position 6: 0x${Hexadecimal(io.probe)}\n")
  printf("---------\n")
}

/*
object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}
 */

class HexTest extends FlatSpec with ChiselScalatestTester {
  "mycpu" should "work through hex" in {
    test(new Top) { c =>
      for (i <- 1 to 36){
        c.clock.step(1)
      }
    }
  }
}