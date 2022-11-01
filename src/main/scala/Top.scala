import Pipline.{CSR, Decode, Execute, InstFetch, MemAccess, Memory, Regs, WriteBack}
import chisel3._
import chisel3.stage.ChiselStage
class Top extends Module {
  val module_inst_fetch = new InstFetch
  val module_decode = new Decode
  val module_execute = new Execute
  val module_memory_access = new MemAccess
  val module_write_back = new WriteBack

  val module_reg = new Regs
  val module_csr = new CSR
  val module_memory = new Memory

  // 连接取值阶段与指令内存
  module_inst_fetch.io.inst_mem <> module_memory.io.imem
  // 连接取指阶段与执行阶段：跳转、分支alu_out等
  module_inst_fetch.io.ex
  // 连接取指阶段对CSR的读取
  module_inst_fetch.io.csr_read <> module_csr.io.readIO
  // 连接取指阶段与译码阶段
  module_inst_fetch.io.passby <> module_decode.io.extend
  // 连接译码阶段与寄存器
  module_decode.io.regs <> module_reg.regReadIO
  // 连接译码阶段与执行阶段
  module_decode.io.passby <> module_execute.io.extend
  module_execute.io.passby
}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}