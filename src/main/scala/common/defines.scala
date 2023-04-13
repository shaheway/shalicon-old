package common

import chisel3._
import chisel3.util.{BitPat, Enum}

object Defines {
  val valid = 1.U(1.W)
  val invalid = 0.U(1.W)
  val fpi = 1.U(1.W)
  val infpi = 0.U(1.W)
  val fp32 = 1.U(1.W)
  val infp32 = 0.U(1.W)

  val uopLen = 9.W
  /*
  val uop_nop = 0.U(uopLen)
  val uop_ld = 1.U(uopLen)
  val uop_sta = 2.U(uopLen) // 存放地址生成单元生成的地址
  val uop_std = 3.U(uopLen) // todo: wtf store data generation 存放数据生成单元()
  val uop_lui = 4.U(uopLen) // load upper immediate

  // 算术逻辑运算
  val uop_addi = 5.U(uopLen)
  val uop_andi = 6.U
   */

  val uopX = BitPat.dontCare(9)
  // using enum
  val uop_nop :: uop_ld :: uop_sta :: uop_std :: uop_lui ::
      uop_addi :: uop_andi :: uop_ori :: uop_xori :: uop_slti :: uop_sltiu :: uop_slli :: uop_srai :: uop_srli ::
      uop_sll :: uop_add :: uop_sub :: uop_slt :: uop_sltu :: uop_and :: uop_or :: uop_xor :: uop_sra :: uop_srl ::
      uop_beq :: uop_bne :: uop_bge :: uop_bgeu :: uop_blt ::
      uop_csrrw :: uop_csrrs :: uop_csrrc :: uop_csrrwi :: uop_csrrsi :: uop_csrrci ::
      uop_j :: uop_jal :: uop_jalr :: uop_auipc :: uop_cflsh :: uop_fence ::
      uop_addiw :: uop_addw :: uop_subw :: uop_slliw :: uop_sllw :: uop_sraiw :: uop_sraw :: uop_srliw :: uop_srlw ::
      uop_mul :: uop_mulh :: uop_mulhu :: uop_mulhsu :: uop_mulw ::
      uop_div :: uop_divu :: uop_rem :: uop_remu :: uop_divw :: uop_divuw :: uop_remw :: uop_remuw ::
      uop_fencei ::
      uop_amo_ag ::
      uop_fmvsx :: uop_fmvdx :: uop_fmvxs :: uop_fmvxd ::
      uop_fsgnjs :: uop_fsgnjd ::
      uop_fcvtsd :: uop_fcvtds ::
      uop_fcvtsw :: uop_fcvtswu :: uop_fcvtsl :: uop_fcvtslu :: uop_fcvtdw :: uop_fcvtdwu :: uop_fcvtdl :: uop_fcvtdlu ::
      uop_fcvtws :: uop_fcvtwus :: uop_fcvtls :: uop_fcvtlus :: uop_fcvtwd :: uop_fcvtwud :: uop_fcvtld :: uop_fcvtlud ::
      uop_feqs :: uop_flts :: uop_fles :: uop_feqd :: uop_fltd :: uop_fled ::
      :: Nil = Enum(24)
}
