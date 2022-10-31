package common
import chisel3.util._

object Instructions {
  val U_LUI     =   BitPat("b?????????????????????????0110111")
  val U_AUIPC   =   BitPat("b?????????????????????????0010111")
  val J_JAL     =   BitPat("b?????????????????????????1101111")
  val I_JALR    =   BitPat("b?????????????????000?????1100111")
  val B_BEQ     =   BitPat("b?????????????????000?????1100011")
  val B_BNE     =   BitPat("b?????????????????001?????1100011")
  val B_BLT     =   BitPat("b?????????????????100?????1100011")
  val B_BGE     =   BitPat("b?????????????????101?????1100011")
  val B_BLTU    =   BitPat("b?????????????????110?????1100011")
  val B_BGEU    =   BitPat("b?????????????????111?????1100011")
  val I_LB      =   BitPat("b?????????????????000?????0000011")
  val I_LH      =   BitPat("b?????????????????001?????0000011")
  val I_LW      =   BitPat("b?????????????????010?????0000011")
  val I_LBU     =   BitPat("b?????????????????100?????0000011")
  val I_LHU     =   BitPat("b?????????????????101?????0000011")
  val S_SB      =   BitPat("b?????????????????000?????0100011")
  val S_SH      =   BitPat("b?????????????????001?????0100011")
  val S_SW      =   BitPat("b?????????????????010?????0100011")
  val I_ADDI    =   BitPat("b?????????????????000?????0010011")
  val I_SLTI    =   BitPat("b?????????????????010?????0010011")
  val I_SLTIU   =   BitPat("b?????????????????011?????0010011")
  val I_XORI    =   BitPat("b?????????????????100?????0010011")
  val I_ORI     =   BitPat("b?????????????????110?????0010011")
  val I_ANDI    =   BitPat("b?????????????????111?????0010011")
  val I_SLLI    =   BitPat("b0000000??????????001?????0010011")
  val I_SRLI    =   BitPat("b0000000??????????101?????0010011")
  val I_SRAI    =   BitPat("b0100000??????????101?????0010011")
  val R_ADD     =   BitPat("b0000000??????????000?????0110011")
  val R_SUB     =   BitPat("b0100000??????????000?????0110011")
  val R_SLL     =   BitPat("b0000000??????????001?????0110011")
  val R_SLT     =   BitPat("b0000000??????????010?????0110011")
  val R_SLTU    =   BitPat("b0000000??????????011?????0110011")
  val R_XOR     =   BitPat("b0000000??????????100?????0110011")
  val R_SRL     =   BitPat("b0000000??????????101?????0110011")
  val R_SRA     =   BitPat("b0100000??????????001?????0110011")
  val R_OR      =   BitPat("b0000000??????????110?????0110011")
  val R_AND     =   BitPat("b0000000??????????111?????0110011")
  val I_FENCE   =   BitPat("b0000????????00000000000000001111")
  val I_FENCE_I =   BitPat("b00000000000000000001000000001111")
  val CSR_RW    =   BitPat("b?????????????????001?????1110011")
  val CSR_RW_I  =   BitPat("b?????????????????101?????1110011")
  val CSR_RS    =   BitPat("b?????????????????010?????1110011")
  val CSR_RS_I  =   BitPat("b?????????????????110?????1110011")
  val CSR_RC    =   BitPat("b?????????????????011?????1110011")
  val CSR_RC_I  =   BitPat("b?????????????????111?????1110011")
  val CSR_ECALL =   BitPat("b00000000000000000000000001110011")
  // val I_ECALL   =   BitPat("b00000000000000000000000001110011")
  // val I_EBREAK  =   BitPat("b0000????????00000000000000001111")
  /*
  // SW功能要实现的是先将（rs1）加上（两块imm拼接成的12位立即数），加的结果作为往mem中写入的地址。再把5位rs2所指示的regfile内容作为往mem中写入的数据，写入mem中。
  val SW = BitPat("b?????????????????010?????0100011")
  // LW要实现的是把通用寄存器中regfile(rs1)内容+立即数imm，作为地址从mem中获取数据，然后将数据存进通用寄存器的位置regfile(rd)中。
  val LW = BitPat("b?????????????????010?????0000011")
  val ADD = BitPat("b0000000??????????000?????0110011")
  val SUB = BitPat("b0100000??????????000?????0110011")
  val ADDI = BitPat("b?????????????????000?????0010011")
  val AND = BitPat("b0000000??????????111?????0110011")
  val OR = BitPat("b0000000??????????110?????0110011")
  val XOR = BitPat("b0000000??????????100?????0110011")
  val ANDI = BitPat("b?????????????????111?????0010011")
  val ORI = BitPat("b?????????????????110?????0010011")
  val XORI = BitPat("b?????????????????100?????0010011")
  val SLL = BitPat("b0000000??????????001?????0110011")
  val SRL = BitPat("b0000000??????????101?????0110011")
  val SRA = BitPat("b0100000??????????101?????0110011")
  val SLLI = BitPat("b0000000??????????001?????0010011")
  val SRLI = BitPat("b0000000??????????101?????0010011")
  val SRAI = BitPat("b0100000??????????101?????0010011")
   */
}