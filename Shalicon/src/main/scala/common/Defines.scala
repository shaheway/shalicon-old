package common
import chisel3._
import Instructions._
object Defines {
  val WORD_LEN = 32;
  val WORD_LEN_WIDTH = 32.W
  val REG_ADDR_WIDTH = 5.W
  val START_ADDR = 0.U(WORD_LEN_WIDTH)
  val BUBBLE = 0x00000013.U(WORD_LEN_WIDTH)  // [ADDI x0,x0,0] = BUBBLE

  // ALU INSTRUCTION RELATED
  val EXE_FUN_LEN = 5.W
  val ALU_X         =   0.U(EXE_FUN_LEN)
  val ALU_ADD       =   1.U(EXE_FUN_LEN)
  val ALU_SUB       =   2.U(EXE_FUN_LEN)
  val ALU_AND       =   3.U(EXE_FUN_LEN)
  val ALU_OR        =   4.U(EXE_FUN_LEN)
  val ALU_XOR       =   5.U(EXE_FUN_LEN)
  val ALU_SLL       =   6.U(EXE_FUN_LEN)
  val ALU_SRL       =   7.U(EXE_FUN_LEN)
  val ALU_SRA       =   8.U(EXE_FUN_LEN)
  val ALU_SLT       =   9.U(EXE_FUN_LEN)
  val ALU_SLTU      =   10.U(EXE_FUN_LEN)
  val ALU_JALR      =   11.U(EXE_FUN_LEN)
  val ALU_NOP_CSR  =   12.U(EXE_FUN_LEN)
  val BR_BEQ        =   13.U(EXE_FUN_LEN)
  val BR_BNE        =   14.U(EXE_FUN_LEN)
  val BR_BLTU       =   15.U(EXE_FUN_LEN)
  val BR_BGEU       =   16.U(EXE_FUN_LEN)
  val BR_BLT        =   17.U(EXE_FUN_LEN)
  val BR_BGE        =   18.U(EXE_FUN_LEN)

  // ALU OP1 RELATED
  val OP1_LEN    =  2.W
  val OP1_X      =  0.U(OP1_LEN)
  val OP1_RS     =  1.U(OP1_LEN)
  val OP1_PC     =  2.U(OP1_LEN)
  val OP1_IM_Z   =  3.U(OP1_LEN)

  val OP2_LEN    =  3.W
  val OP2_X      =  0.U(OP2_LEN)
  val OP2_RS     =  1.U(OP2_LEN)
  val OP2_IM_I   =  2.U(OP2_LEN)
  val OP2_IM_J   =  3.U(OP2_LEN)
  val OP2_IM_S   =  4.U(OP2_LEN)
  val OP2_IM_U   =  5.U(OP2_LEN)

  val MEN_LEN    =  2.W
  val MEN_X      =  0.U(MEN_LEN)
  val MEN_S      =  1.U(MEN_LEN) // Instructions for scala quantities
  val MEN_V      =  2.U(MEN_LEN) // Instructions for vectors

  val REN_LEN    =  2.W
  val REN_X      =  0.U(REN_LEN)
  val REN_S      =  1.U(REN_LEN)
  val REN_V      =  2.U(REN_LEN)

  val WB_SEL_LEN =  3.W
  val WB_X       =  0.U(WB_SEL_LEN)
  val WB_ALU     =  1.U(WB_SEL_LEN)
  val WB_MEM     =  2.U(WB_SEL_LEN)
  val WB_PC      =  3.U(WB_SEL_LEN)
  val WB_CSR     =  4.U(WB_SEL_LEN)
  val WB_MEM_V   =  5.U(WB_SEL_LEN)
  val WB_ALU_V   =  6.U(WB_SEL_LEN)
  val WB_VL      =  7.U(WB_SEL_LEN)

  val MW_LEN     =  3.W
  val MW_X       =  0.U(MW_LEN)
  val MW_W       =  1.U(MW_LEN)
  val MW_H       =  2.U(MW_LEN)
  val MW_B       =  3.U(MW_LEN)
  val MW_HU      =  4.U(MW_LEN)
  val MW_BU      =  5.U(MW_LEN)

  val CSR_LEN = 3.W
  val CSR_X      =  0.U(CSR_LEN)
  val CSR_W      =  1.U(CSR_LEN)
  val CSR_S      =  2.U(CSR_LEN)
  val CSR_C      =  3.U(CSR_LEN)
  val CSR_E      =  4.U(CSR_LEN)
  val CSR_V      =  5.U(CSR_LEN)
}

















