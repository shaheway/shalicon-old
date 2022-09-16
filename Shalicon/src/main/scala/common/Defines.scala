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
  val EXE_FUN_LEN = 8.W
  val ALU_U_LUI     =   1.U(EXE_FUN_LEN)
  val ALU_U_AUIPC   =   2.U(EXE_FUN_LEN)
  val ALU_J_JAL     =   3.U(EXE_FUN_LEN)
  val ALU_I_JALR    =   4.U(EXE_FUN_LEN)
  val ALU_B_BEQ     =   5.U(EXE_FUN_LEN)
  val ALU_B_BNE     =   6.U(EXE_FUN_LEN)
  val ALU_B_BLT     =   7.U(EXE_FUN_LEN)
  val ALU_B_BGE     =   8.U(EXE_FUN_LEN)
  val ALU_B_BLTU    =   9.U(EXE_FUN_LEN)
  val ALU_B_BGEU    =  10.U(EXE_FUN_LEN)
  val ALU_I_LB      =  11.U(EXE_FUN_LEN)
  val ALU_I_LH      =  12.U(EXE_FUN_LEN)
  val ALU_I_LW      =  13.U(EXE_FUN_LEN)
  val ALU_I_LBU     =  14.U(EXE_FUN_LEN)
  val ALU_I_LHU     =  15.U(EXE_FUN_LEN)
  val ALU_S_SB      =  16.U(EXE_FUN_LEN)
  val ALU_S_SH      =  17.U(EXE_FUN_LEN)
  val ALU_S_SW      =  18.U(EXE_FUN_LEN)
  val ALU_I_ADDI    =  19.U(EXE_FUN_LEN)
  val ALU_I_SLTI    =  20.U(EXE_FUN_LEN)
  val ALU_I_SLTIU   =  21.U(EXE_FUN_LEN)
  val ALU_I_XORI    =  22.U(EXE_FUN_LEN)
  val ALU_I_ORI     =  23.U(EXE_FUN_LEN)
  val ALU_I_ANDI    =  24.U(EXE_FUN_LEN)
  val ALU_I_SLLI    =  25.U(EXE_FUN_LEN)
  val ALU_I_SRLT    =  26.U(EXE_FUN_LEN)
  val ALU_I_SRAI    =  27.U(EXE_FUN_LEN)
  val ALU_R_ADD     =  28.U(EXE_FUN_LEN)
  val ALU_R_SUB     =  29.U(EXE_FUN_LEN)
  val ALU_R_SLL     =  30.U(EXE_FUN_LEN)
  val ALU_R_SLT     =  31.U(EXE_FUN_LEN)
  val ALU_R_SLTU    =  32.U(EXE_FUN_LEN)
  val ALU_R_XOR     =  33.U(EXE_FUN_LEN)
  val ALU_R_SRL     =  34.U(EXE_FUN_LEN)
  val ALU_R_SRA     =  35.U(EXE_FUN_LEN)
  val ALU_R_OR      =  36.U(EXE_FUN_LEN)
  val ALU_R_AND     =  37.U(EXE_FUN_LEN)
  val ALU_I_FENCE   =  38.U(EXE_FUN_LEN)
  val ALU_I_FENCE_I =  39.U(EXE_FUN_LEN)

  // ALU OP1 RELATED
  val OP1_LEN    =  3.W
  val OP1_RS     =  0.U(OP1_LEN)
  val OP1_PC     =  1.U(OP1_LEN)

  val OP2_LEN    =  3.W
  val OP2_RS     =  0.U(OP2_LEN)
  val OP2_IM_I   =  1.U(OP2_LEN)
  val OP2_IM_J   =  2.U(OP2_LEN)
  val OP2_IM_S   =  3.U(OP2_LEN)
  val OP2_IM_U   =  4.U(OP2_LEN)

  val
}

















