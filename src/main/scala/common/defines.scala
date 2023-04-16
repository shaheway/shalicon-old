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
}

object ScalaOpConstants {
  val X = BitPat("b?")
  val Y = BitPat("b1")
  val N = BitPat("b0")

  val uopLen = 9.W
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
    uop_fclasss :: uop_fclassd :: uop_fmins :: uop_fmaxs :: uop_fmind :: uop_fmaxd ::
    uop_fadds :: uop_fsubs :: uop_fmuls :: uop_faddd :: uop_fsubd :: uop_fmuld ::
    uop_fmadds :: uop_fmsubs :: uop_fnmadds :: uop_fnmsubs :: uop_fmaddd :: uop_fmsubd :: uop_fnmaddd :: uop_fnmsubd ::
    uop_fdivs :: uop_fdivd :: uop_fsqrts :: uop_fsqrtd :: uop_system :: Nil = Enum(122)

  val bubble = 0x4033.U(32.W)
}

object FUConstants {
  val functionSize = 8.W
  val FU_X = BitPat.dontCare(8)
  val FU_ALU = 1.U(functionSize)
  val FU_BRU = 2.U(functionSize)
  val FU_MEM = 3.U(functionSize)
  val FU_MUL = 4.U(functionSize)
  val FU_DIV = 5.U(functionSize)
  val FU_FPU = 6.U(functionSize)
  val FU_CSR = 7.U(functionSize)
  val FU_FDV = 8.U(functionSize)
}

object DestRegType {
  val destTypeLen = 2.W
  val RT_X = BitPat("b10") // not a register
  val RT_FIX = BitPat("b00")
}

object ImmExtSelect {
  val immTypeLen = 3.W
  val Itype = 0.U(3.W)
  val Stype = 1.U(3.W)
  val Btype = 2.U(3.W)
  val Utype = 3.U(3.W)
  val Jtype = 4.U(3.W)
  val Xtype = BitPat("b???")
}

object MemMaskType {
  val maskX = BitPat("b???")
  val maskB = 0.U(3.W)
  val maskH = 1.U(3.W)
  val maskW = 2.U(3.W)
  val maskD = 3.U(3.W)
  val maskBU = 4.U(3.W)
  val maskHU = 5.U(3.W)
  val maskWU = 6.U(3.W)
}

object MemOpConstants {
  val memCommandLen = 5.W
  val memX = BitPat("b?????")
  val memXRD = 0.U(5.W) // int load
  val memXWR = 1.U(5.W) // int store
  val memPFR = 2.U(5.W) // prefetch with intent to read
  val memPFW = 3.U(5.W) // prefetch with intent to write
  val memXASwap = 4.U(5.W)
  val memFlushAll = 5.U(5.W) // flush all lines
  val memXLR = 6.U(5.W)
  val memXSC = 7.U(5.W)
  val memXAAdd = 8.U(5.W)
  val memXAXor = 9.U(5.W)
  val memXAOr = 10.U(5.W)
  val memXAAnd = 11.U(5.W)
  val memXAMin = 12.U(5.W)
  val memXAMax = 13.U(5.W)
  val memXAMinU = 14.U(5.W)
  val memXAMaxU = 15.U(5.W)
  val memFlush = 16.U(5.W) // write back dirty data and cede R/W permissions
  val memProduce = 17.U(5.W) // write back dirty data and cede W permissions
  val memClean = 18.U(5.W) // write back dirty data and retain R/W permissions
}

object CSR {
  val size = 3.W
  val X = BitPat.dontCare(3)
  val N = 0.U(3.W)
  val W = 1.U(3.W)
  val S = 2.U(3.W)
  val C = 3.U(3.W)
  val I = 4.U(3.W)
  val R = 5.U(3.W)
}

object SourceOpType {
  val srcTypeLen = 2.W
}

object Instructions {
  val BEQ                = BitPat("b?????????????????000?????1100011")
  val BNE                = BitPat("b?????????????????001?????1100011")
  val BLT                = BitPat("b?????????????????100?????1100011")
  val BGE                = BitPat("b?????????????????101?????1100011")
  val BLTU               = BitPat("b?????????????????110?????1100011")
  val BGEU               = BitPat("b?????????????????111?????1100011")
  val JALR               = BitPat("b?????????????????000?????1100111")
  val JAL                = BitPat("b?????????????????????????1101111")
  val LUI                = BitPat("b?????????????????????????0110111")
  val AUIPC              = BitPat("b?????????????????????????0010111")
  val ADDI               = BitPat("b?????????????????000?????0010011")
  val SLLI               = BitPat("b000000???????????001?????0010011")
  val SLTI               = BitPat("b?????????????????010?????0010011")
  val SLTIU              = BitPat("b?????????????????011?????0010011")
  val XORI               = BitPat("b?????????????????100?????0010011")
  val SRLI               = BitPat("b000000???????????101?????0010011")
  val SRAI               = BitPat("b010000???????????101?????0010011")
  val ORI                = BitPat("b?????????????????110?????0010011")
  val ANDI               = BitPat("b?????????????????111?????0010011")
  val ADD                = BitPat("b0000000??????????000?????0110011")
  val SUB                = BitPat("b0100000??????????000?????0110011")
  val SLL                = BitPat("b0000000??????????001?????0110011")
  val SLT                = BitPat("b0000000??????????010?????0110011")
  val SLTU               = BitPat("b0000000??????????011?????0110011")
  val XOR                = BitPat("b0000000??????????100?????0110011")
  val SRL                = BitPat("b0000000??????????101?????0110011")
  val SRA                = BitPat("b0100000??????????101?????0110011")
  val OR                 = BitPat("b0000000??????????110?????0110011")
  val AND                = BitPat("b0000000??????????111?????0110011")
  val ADDIW              = BitPat("b?????????????????000?????0011011")
  val SLLIW              = BitPat("b0000000??????????001?????0011011")
  val SRLIW              = BitPat("b0000000??????????101?????0011011")
  val SRAIW              = BitPat("b0100000??????????101?????0011011")
  val ADDW               = BitPat("b0000000??????????000?????0111011")
  val SUBW               = BitPat("b0100000??????????000?????0111011")
  val SLLW               = BitPat("b0000000??????????001?????0111011")
  val SRLW               = BitPat("b0000000??????????101?????0111011")
  val SRAW               = BitPat("b0100000??????????101?????0111011")
  val LB                 = BitPat("b?????????????????000?????0000011")
  val LH                 = BitPat("b?????????????????001?????0000011")
  val LW                 = BitPat("b?????????????????010?????0000011")
  val LD                 = BitPat("b?????????????????011?????0000011")
  val LBU                = BitPat("b?????????????????100?????0000011")
  val LHU                = BitPat("b?????????????????101?????0000011")
  val LWU                = BitPat("b?????????????????110?????0000011")
  val SB                 = BitPat("b?????????????????000?????0100011")
  val SH                 = BitPat("b?????????????????001?????0100011")
  val SW                 = BitPat("b?????????????????010?????0100011")
  val SD                 = BitPat("b?????????????????011?????0100011")
  val FENCE              = BitPat("b?????????????????000?????0001111")
  val FENCE_I            = BitPat("b?????????????????001?????0001111")
  val MUL                = BitPat("b0000001??????????000?????0110011")
  val MULH               = BitPat("b0000001??????????001?????0110011")
  val MULHSU             = BitPat("b0000001??????????010?????0110011")
  val MULHU              = BitPat("b0000001??????????011?????0110011")
  val DIV                = BitPat("b0000001??????????100?????0110011")
  val DIVU               = BitPat("b0000001??????????101?????0110011")
  val REM                = BitPat("b0000001??????????110?????0110011")
  val REMU               = BitPat("b0000001??????????111?????0110011")
  val MULW               = BitPat("b0000001??????????000?????0111011")
  val DIVW               = BitPat("b0000001??????????100?????0111011")
  val DIVUW              = BitPat("b0000001??????????101?????0111011")
  val REMW               = BitPat("b0000001??????????110?????0111011")
  val REMUW              = BitPat("b0000001??????????111?????0111011")
  val AMOADD_W           = BitPat("b00000????????????010?????0101111")
  val AMOXOR_W           = BitPat("b00100????????????010?????0101111")
  val AMOOR_W            = BitPat("b01000????????????010?????0101111")
  val AMOAND_W           = BitPat("b01100????????????010?????0101111")
  val AMOMIN_W           = BitPat("b10000????????????010?????0101111")
  val AMOMAX_W           = BitPat("b10100????????????010?????0101111")
  val AMOMINU_W          = BitPat("b11000????????????010?????0101111")
  val AMOMAXU_W          = BitPat("b11100????????????010?????0101111")
  val AMOSWAP_W          = BitPat("b00001????????????010?????0101111")
  val LR_W               = BitPat("b00010??00000?????010?????0101111")
  val SC_W               = BitPat("b00011????????????010?????0101111")
  val AMOADD_D           = BitPat("b00000????????????011?????0101111")
  val AMOXOR_D           = BitPat("b00100????????????011?????0101111")
  val AMOOR_D            = BitPat("b01000????????????011?????0101111")
  val AMOAND_D           = BitPat("b01100????????????011?????0101111")
  val AMOMIN_D           = BitPat("b10000????????????011?????0101111")
  val AMOMAX_D           = BitPat("b10100????????????011?????0101111")
  val AMOMINU_D          = BitPat("b11000????????????011?????0101111")
  val AMOMAXU_D          = BitPat("b11100????????????011?????0101111")
  val AMOSWAP_D          = BitPat("b00001????????????011?????0101111")
  val LR_D               = BitPat("b00010??00000?????011?????0101111")
  val SC_D               = BitPat("b00011????????????011?????0101111")
  val ECALL              = BitPat("b00000000000000000000000001110011")
  val EBREAK             = BitPat("b00000000000100000000000001110011")
  val URET               = BitPat("b00000000001000000000000001110011")
  val SRET               = BitPat("b00010000001000000000000001110011")
  val HRET               = BitPat("b00100000001000000000000001110011")
  val MRET               = BitPat("b00110000001000000000000001110011")
  val DRET               = BitPat("b01111011001000000000000001110011")
  val SFENCE_VM          = BitPat("b000100000100?????000000001110011")
  val WFI                = BitPat("b00010000010100000000000001110011")
  val CSRRW              = BitPat("b?????????????????001?????1110011")
  val CSRRS              = BitPat("b?????????????????010?????1110011")
  val CSRRC              = BitPat("b?????????????????011?????1110011")
  val CSRRWI             = BitPat("b?????????????????101?????1110011")
  val CSRRSI             = BitPat("b?????????????????110?????1110011")
  val CSRRCI             = BitPat("b?????????????????111?????1110011")
  val FADD_S             = BitPat("b0000000??????????????????1010011")
  val FSUB_S             = BitPat("b0000100??????????????????1010011")
  val FMUL_S             = BitPat("b0001000??????????????????1010011")
  val FDIV_S             = BitPat("b0001100??????????????????1010011")
  val FSGNJ_S            = BitPat("b0010000??????????000?????1010011")
  val FSGNJN_S           = BitPat("b0010000??????????001?????1010011")
  val FSGNJX_S           = BitPat("b0010000??????????010?????1010011")
  val FMIN_S             = BitPat("b0010100??????????000?????1010011")
  val FMAX_S             = BitPat("b0010100??????????001?????1010011")
  val FSQRT_S            = BitPat("b010110000000?????????????1010011")
  val FADD_D             = BitPat("b0000001??????????????????1010011")
  val FSUB_D             = BitPat("b0000101??????????????????1010011")
  val FMUL_D             = BitPat("b0001001??????????????????1010011")
  val FDIV_D             = BitPat("b0001101??????????????????1010011")
  val FSGNJ_D            = BitPat("b0010001??????????000?????1010011")
  val FSGNJN_D           = BitPat("b0010001??????????001?????1010011")
  val FSGNJX_D           = BitPat("b0010001??????????010?????1010011")
  val FMIN_D             = BitPat("b0010101??????????000?????1010011")
  val FMAX_D             = BitPat("b0010101??????????001?????1010011")
  val FCVT_S_D           = BitPat("b010000000001?????????????1010011")
  val FCVT_D_S           = BitPat("b010000100000?????????????1010011")
  val FSQRT_D            = BitPat("b010110100000?????????????1010011")
  val FLE_S              = BitPat("b1010000??????????000?????1010011")
  val FLT_S              = BitPat("b1010000??????????001?????1010011")
  val FEQ_S              = BitPat("b1010000??????????010?????1010011")
  val FLE_D              = BitPat("b1010001??????????000?????1010011")
  val FLT_D              = BitPat("b1010001??????????001?????1010011")
  val FEQ_D              = BitPat("b1010001??????????010?????1010011")
  val FCVT_W_S           = BitPat("b110000000000?????????????1010011")
  val FCVT_WU_S          = BitPat("b110000000001?????????????1010011")
  val FCVT_L_S           = BitPat("b110000000010?????????????1010011")
  val FCVT_LU_S          = BitPat("b110000000011?????????????1010011")
  val FMV_X_S            = BitPat("b111000000000?????000?????1010011")
  val FCLASS_S           = BitPat("b111000000000?????001?????1010011")
  val FCVT_W_D           = BitPat("b110000100000?????????????1010011")
  val FCVT_WU_D          = BitPat("b110000100001?????????????1010011")
  val FCVT_L_D           = BitPat("b110000100010?????????????1010011")
  val FCVT_LU_D          = BitPat("b110000100011?????????????1010011")
  val FMV_X_D            = BitPat("b111000100000?????000?????1010011")
  val FCLASS_D           = BitPat("b111000100000?????001?????1010011")
  val FCVT_S_W           = BitPat("b110100000000?????????????1010011")
  val FCVT_S_WU          = BitPat("b110100000001?????????????1010011")
  val FCVT_S_L           = BitPat("b110100000010?????????????1010011")
  val FCVT_S_LU          = BitPat("b110100000011?????????????1010011")
  val FMV_S_X            = BitPat("b111100000000?????000?????1010011")
  val FCVT_D_W           = BitPat("b110100100000?????????????1010011")
  val FCVT_D_WU          = BitPat("b110100100001?????????????1010011")
  val FCVT_D_L           = BitPat("b110100100010?????????????1010011")
  val FCVT_D_LU          = BitPat("b110100100011?????????????1010011")
  val FMV_D_X            = BitPat("b111100100000?????000?????1010011")
  val FLW                = BitPat("b?????????????????010?????0000111")
  val FLD                = BitPat("b?????????????????011?????0000111")
  val FSW                = BitPat("b?????????????????010?????0100111")
  val FSD                = BitPat("b?????????????????011?????0100111")
  val FMADD_S            = BitPat("b?????00??????????????????1000011")
  val FMSUB_S            = BitPat("b?????00??????????????????1000111")
  val FNMSUB_S           = BitPat("b?????00??????????????????1001011")
  val FNMADD_S           = BitPat("b?????00??????????????????1001111")
  val FMADD_D            = BitPat("b?????01??????????????????1000011")
  val FMSUB_D            = BitPat("b?????01??????????????????1000111")
  val FNMSUB_D           = BitPat("b?????01??????????????????1001011")
  val FNMADD_D           = BitPat("b?????01??????????????????1001111")
  val CUSTOM0            = BitPat("b?????????????????000?????0001011")
  val CUSTOM0_RS1        = BitPat("b?????????????????010?????0001011")
  val CUSTOM0_RS1_RS2    = BitPat("b?????????????????011?????0001011")
  val CUSTOM0_RD         = BitPat("b?????????????????100?????0001011")
  val CUSTOM0_RD_RS1     = BitPat("b?????????????????110?????0001011")
  val CUSTOM0_RD_RS1_RS2 = BitPat("b?????????????????111?????0001011")
  val CUSTOM1            = BitPat("b?????????????????000?????0101011")
  val CUSTOM1_RS1        = BitPat("b?????????????????010?????0101011")
  val CUSTOM1_RS1_RS2    = BitPat("b?????????????????011?????0101011")
  val CUSTOM1_RD         = BitPat("b?????????????????100?????0101011")
  val CUSTOM1_RD_RS1     = BitPat("b?????????????????110?????0101011")
  val CUSTOM1_RD_RS1_RS2 = BitPat("b?????????????????111?????0101011")
  val CUSTOM2            = BitPat("b?????????????????000?????1011011")
  val CUSTOM2_RS1        = BitPat("b?????????????????010?????1011011")
  val CUSTOM2_RS1_RS2    = BitPat("b?????????????????011?????1011011")
  val CUSTOM2_RD         = BitPat("b?????????????????100?????1011011")
  val CUSTOM2_RD_RS1     = BitPat("b?????????????????110?????1011011")
  val CUSTOM2_RD_RS1_RS2 = BitPat("b?????????????????111?????1011011")
  val CUSTOM3            = BitPat("b?????????????????000?????1111011")
  val CUSTOM3_RS1        = BitPat("b?????????????????010?????1111011")
  val CUSTOM3_RS1_RS2    = BitPat("b?????????????????011?????1111011")
  val CUSTOM3_RD         = BitPat("b?????????????????100?????1111011")
  val CUSTOM3_RD_RS1     = BitPat("b?????????????????110?????1111011")
  val CUSTOM3_RD_RS1_RS2 = BitPat("b?????????????????111?????1111011")
  val SLLI_RV32          = BitPat("b0000000??????????001?????0010011")
  val SRLI_RV32          = BitPat("b0000000??????????101?????0010011")
  val SRAI_RV32          = BitPat("b0100000??????????101?????0010011")
  val FRFLAGS            = BitPat("b00000000000100000010?????1110011")
  val FSFLAGS            = BitPat("b000000000001?????001?????1110011")
  val FSFLAGSI           = BitPat("b000000000001?????101?????1110011")
  val FRRM               = BitPat("b00000000001000000010?????1110011")
  val FSRM               = BitPat("b000000000010?????001?????1110011")
  val FSRMI              = BitPat("b000000000010?????101?????1110011")
  val FSCSR              = BitPat("b000000000011?????001?????1110011")
  val FRCSR              = BitPat("b00000000001100000010?????1110011")
  val RDCYCLE            = BitPat("b11000000000000000010?????1110011")
  val RDTIME             = BitPat("b11000000000100000010?????1110011")
  val RDINSTRET          = BitPat("b11000000001000000010?????1110011")
  val RDCYCLEH           = BitPat("b11001000000000000010?????1110011")
  val RDTIMEH            = BitPat("b11001000000100000010?????1110011")
  val RDINSTRETH         = BitPat("b11001000001000000010?????1110011")
  val SCALL              = BitPat("b00000000000000000000000001110011")
  val SBREAK             = BitPat("b00000000000100000000000001110011")
}