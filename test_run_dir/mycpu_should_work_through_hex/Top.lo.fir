circuit Top :
  module InstFetch :
    input clock : Clock
    input reset : UInt<1>
    output io_inst_mem_inst_addr : UInt<32>
    input io_inst_mem_inst_o : UInt<32>
    output io_csr_read_reg_raddr : UInt<12>
    input io_csr_read_reg_rdata : UInt<32>
    input io_exio_alu_out : UInt<32>
    input io_exio_br_flag : UInt<1>
    input io_exio_br_target : UInt<32>
    input io_exio_jmp_flag : UInt<1>
    output io_passby_if_pc_reg : UInt<32>
    output io_passby_if_inst : UInt<32>

    reg if_pc_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), if_pc_reg) @[InstFetch.scala 19:26]
    node _pc_next_T = add(if_pc_reg, UInt<32>("h4")) @[InstFetch.scala 22:35]
    node _pc_next_T_1 = tail(_pc_next_T, 1) @[InstFetch.scala 22:35]
    node _pc_next_T_2 = and(io_inst_mem_inst_o, UInt<32>("hffffffff")) @[InstFetch.scala 25:14]
    node _pc_next_T_3 = eq(UInt<7>("h73"), _pc_next_T_2) @[InstFetch.scala 25:14]
    node _pc_next_T_4 = mux(_pc_next_T_3, io_csr_read_reg_rdata, _pc_next_T_1) @[Mux.scala 101:16]
    node _pc_next_T_5 = mux(io_exio_jmp_flag, io_exio_alu_out, _pc_next_T_4) @[Mux.scala 101:16]
    node pc_next = mux(io_exio_br_flag, io_exio_br_target, _pc_next_T_5) @[Mux.scala 101:16]
    io_inst_mem_inst_addr <= if_pc_reg @[InstFetch.scala 20:25]
    io_csr_read_reg_raddr <= UInt<12>("h305") @[InstFetch.scala 16:25]
    io_passby_if_pc_reg <= if_pc_reg @[InstFetch.scala 30:23]
    io_passby_if_inst <= io_inst_mem_inst_o @[InstFetch.scala 31:21]
    if_pc_reg <= mux(reset, UInt<32>("h0"), pc_next) @[InstFetch.scala 19:{26,26} 27:13]

  module Decode :
    input clock : Clock
    input reset : UInt<1>
    input io_extend_if_pc_reg : UInt<32>
    input io_extend_if_inst : UInt<32>
    output io_regs_reg_raddr1 : UInt<5>
    output io_regs_reg_raddr2 : UInt<5>
    input io_regs_reg_rdata1 : UInt<32>
    input io_regs_reg_rdata2 : UInt<32>
    output io_passby_id_pc_reg : UInt<32>
    output io_passby_imm_i_sext : UInt<32>
    output io_passby_imm_s_sext : UInt<32>
    output io_passby_imm_b_sext : UInt<32>
    output io_passby_imm_u_shifted : UInt<32>
    output io_passby_imm_z_uext : UInt<32>
    output io_passby_op1_data : UInt<32>
    output io_passby_op2_data : UInt<32>
    output io_passby_rs2_data : UInt<32>
    output io_passby_wb_addr : UInt<5>
    output io_passby_exe_fun : UInt<5>
    output io_passby_mem_wen : UInt<2>
    output io_passby_reg_wen : UInt<2>
    output io_passby_wb_sel : UInt<3>
    output io_passby_csr_cmd : UInt<3>
    output io_passby_csr_addr : UInt<12>

    reg id_inst_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), id_inst_reg) @[Decode.scala 15:28]
    reg id_pc_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), id_pc_reg) @[Decode.scala 16:26]
    node rs1_addr = bits(id_inst_reg, 19, 15) @[Decode.scala 21:29]
    node rs2_addr = bits(id_inst_reg, 24, 20) @[Decode.scala 22:29]
    node _rs1_data_T = neq(rs1_addr, UInt<32>("h0")) @[Decode.scala 29:31]
    node rs1_data = mux(_rs1_data_T, io_regs_reg_rdata1, UInt<32>("h0")) @[Decode.scala 29:21]
    node _rs2_data_T = neq(rs2_addr, UInt<32>("h0")) @[Decode.scala 30:31]
    node rs2_data = mux(_rs2_data_T, io_regs_reg_rdata2, UInt<32>("h0")) @[Decode.scala 30:21]
    node wb_addr = bits(id_inst_reg, 11, 7) @[Decode.scala 33:28]
    node imm_i = bits(id_inst_reg, 31, 20) @[Decode.scala 35:26]
    node _imm_i_sext_T = bits(imm_i, 11, 11) @[Decode.scala 36:38]
    node _imm_i_sext_T_1 = bits(_imm_i_sext_T, 0, 0) @[Bitwise.scala 74:15]
    node _imm_i_sext_T_2 = mux(_imm_i_sext_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 74:12]
    node imm_i_sext = cat(_imm_i_sext_T_2, imm_i) @[Cat.scala 31:58]
    node _imm_s_T = bits(id_inst_reg, 31, 25) @[Decode.scala 37:30]
    node _imm_s_T_1 = bits(id_inst_reg, 11, 7) @[Decode.scala 37:51]
    node imm_s = cat(_imm_s_T, _imm_s_T_1) @[Cat.scala 31:58]
    node _imm_s_sext_T = bits(imm_s, 11, 11) @[Decode.scala 38:38]
    node _imm_s_sext_T_1 = bits(_imm_s_sext_T, 0, 0) @[Bitwise.scala 74:15]
    node _imm_s_sext_T_2 = mux(_imm_s_sext_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 74:12]
    node imm_s_sext = cat(_imm_s_sext_T_2, imm_s) @[Cat.scala 31:58]
    node _imm_b_T = bits(id_inst_reg, 31, 31) @[Decode.scala 39:30]
    node _imm_b_T_1 = bits(id_inst_reg, 7, 7) @[Decode.scala 39:47]
    node _imm_b_T_2 = bits(id_inst_reg, 30, 25) @[Decode.scala 39:63]
    node _imm_b_T_3 = bits(id_inst_reg, 11, 8) @[Decode.scala 39:84]
    node imm_b_lo = cat(_imm_b_T_2, _imm_b_T_3) @[Cat.scala 31:58]
    node imm_b_hi = cat(_imm_b_T, _imm_b_T_1) @[Cat.scala 31:58]
    node imm_b = cat(imm_b_hi, imm_b_lo) @[Cat.scala 31:58]
    node _imm_b_sext_T = bits(imm_b, 11, 11) @[Decode.scala 40:38]
    node _imm_b_sext_T_1 = bits(_imm_b_sext_T, 0, 0) @[Bitwise.scala 74:15]
    node _imm_b_sext_T_2 = mux(_imm_b_sext_T_1, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 74:12]
    node _imm_b_sext_T_3 = dshr(UInt<1>("h0"), UInt<1>("h1")) @[Decode.scala 40:55]
    node _imm_b_sext_T_4 = bits(_imm_b_sext_T_3, 0, 0) @[Decode.scala 40:55]
    node imm_b_sext_hi = cat(_imm_b_sext_T_2, imm_b) @[Cat.scala 31:58]
    node imm_b_sext = cat(imm_b_sext_hi, _imm_b_sext_T_4) @[Cat.scala 31:58]
    node _imm_j_T = bits(id_inst_reg, 31, 31) @[Decode.scala 41:30]
    node _imm_j_T_1 = bits(id_inst_reg, 19, 12) @[Decode.scala 41:47]
    node _imm_j_T_2 = bits(id_inst_reg, 20, 20) @[Decode.scala 41:68]
    node _imm_j_T_3 = bits(id_inst_reg, 30, 21) @[Decode.scala 41:85]
    node imm_j_lo = cat(_imm_j_T_2, _imm_j_T_3) @[Cat.scala 31:58]
    node imm_j_hi = cat(_imm_j_T, _imm_j_T_1) @[Cat.scala 31:58]
    node imm_j = cat(imm_j_hi, imm_j_lo) @[Cat.scala 31:58]
    node _imm_j_sext_T = bits(imm_j, 19, 19) @[Decode.scala 42:38]
    node _imm_j_sext_T_1 = bits(_imm_j_sext_T, 0, 0) @[Bitwise.scala 74:15]
    node _imm_j_sext_T_2 = mux(_imm_j_sext_T_1, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 74:12]
    node _imm_j_sext_T_3 = dshr(UInt<1>("h0"), UInt<1>("h1")) @[Decode.scala 42:55]
    node _imm_j_sext_T_4 = bits(_imm_j_sext_T_3, 0, 0) @[Decode.scala 42:55]
    node imm_j_sext_hi = cat(_imm_j_sext_T_2, imm_j) @[Cat.scala 31:58]
    node imm_j_sext = cat(imm_j_sext_hi, _imm_j_sext_T_4) @[Cat.scala 31:58]
    node imm_u = bits(id_inst_reg, 31, 12) @[Decode.scala 43:26]
    node _imm_u_shifted_T = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 74:12]
    node imm_u_shifted = cat(imm_u, _imm_u_shifted_T) @[Cat.scala 31:58]
    node imm_z = bits(id_inst_reg, 19, 15) @[Decode.scala 45:26]
    node _imm_z_uext_T = mux(UInt<1>("h0"), UInt<27>("h7ffffff"), UInt<27>("h0")) @[Bitwise.scala 74:12]
    node imm_z_uext = cat(_imm_z_uext_T, imm_z) @[Cat.scala 31:58]
    node _decoded_inst_T = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_1 = eq(UInt<14>("h2023"), _decoded_inst_T) @[Lookup.scala 31:38]
    node _decoded_inst_T_2 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_3 = eq(UInt<14>("h2003"), _decoded_inst_T_2) @[Lookup.scala 31:38]
    node _decoded_inst_T_4 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_5 = eq(UInt<6>("h33"), _decoded_inst_T_4) @[Lookup.scala 31:38]
    node _decoded_inst_T_6 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_7 = eq(UInt<31>("h40000033"), _decoded_inst_T_6) @[Lookup.scala 31:38]
    node _decoded_inst_T_8 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_9 = eq(UInt<5>("h13"), _decoded_inst_T_8) @[Lookup.scala 31:38]
    node _decoded_inst_T_10 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_11 = eq(UInt<15>("h7033"), _decoded_inst_T_10) @[Lookup.scala 31:38]
    node _decoded_inst_T_12 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_13 = eq(UInt<15>("h7013"), _decoded_inst_T_12) @[Lookup.scala 31:38]
    node _decoded_inst_T_14 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_15 = eq(UInt<15>("h6033"), _decoded_inst_T_14) @[Lookup.scala 31:38]
    node _decoded_inst_T_16 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_17 = eq(UInt<15>("h6013"), _decoded_inst_T_16) @[Lookup.scala 31:38]
    node _decoded_inst_T_18 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_19 = eq(UInt<15>("h4033"), _decoded_inst_T_18) @[Lookup.scala 31:38]
    node _decoded_inst_T_20 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_21 = eq(UInt<15>("h4013"), _decoded_inst_T_20) @[Lookup.scala 31:38]
    node _decoded_inst_T_22 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_23 = eq(UInt<13>("h1033"), _decoded_inst_T_22) @[Lookup.scala 31:38]
    node _decoded_inst_T_24 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_25 = eq(UInt<13>("h1013"), _decoded_inst_T_24) @[Lookup.scala 31:38]
    node _decoded_inst_T_26 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_27 = eq(UInt<15>("h5033"), _decoded_inst_T_26) @[Lookup.scala 31:38]
    node _decoded_inst_T_28 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_29 = eq(UInt<15>("h5013"), _decoded_inst_T_28) @[Lookup.scala 31:38]
    node _decoded_inst_T_30 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_31 = eq(UInt<31>("h40001033"), _decoded_inst_T_30) @[Lookup.scala 31:38]
    node _decoded_inst_T_32 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_33 = eq(UInt<31>("h40005013"), _decoded_inst_T_32) @[Lookup.scala 31:38]
    node _decoded_inst_T_34 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_35 = eq(UInt<14>("h2033"), _decoded_inst_T_34) @[Lookup.scala 31:38]
    node _decoded_inst_T_36 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_37 = eq(UInt<14>("h2013"), _decoded_inst_T_36) @[Lookup.scala 31:38]
    node _decoded_inst_T_38 = and(id_inst_reg, UInt<32>("hfe00707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_39 = eq(UInt<14>("h3033"), _decoded_inst_T_38) @[Lookup.scala 31:38]
    node _decoded_inst_T_40 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_41 = eq(UInt<14>("h3013"), _decoded_inst_T_40) @[Lookup.scala 31:38]
    node _decoded_inst_T_42 = and(id_inst_reg, UInt<7>("h7f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_43 = eq(UInt<7>("h6f"), _decoded_inst_T_42) @[Lookup.scala 31:38]
    node _decoded_inst_T_44 = and(id_inst_reg, UInt<7>("h7f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_45 = eq(UInt<6>("h37"), _decoded_inst_T_44) @[Lookup.scala 31:38]
    node _decoded_inst_T_46 = and(id_inst_reg, UInt<7>("h7f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_47 = eq(UInt<5>("h17"), _decoded_inst_T_46) @[Lookup.scala 31:38]
    node _decoded_inst_T_48 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_49 = eq(UInt<7>("h67"), _decoded_inst_T_48) @[Lookup.scala 31:38]
    node _decoded_inst_T_50 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_51 = eq(UInt<7>("h63"), _decoded_inst_T_50) @[Lookup.scala 31:38]
    node _decoded_inst_T_52 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_53 = eq(UInt<13>("h1063"), _decoded_inst_T_52) @[Lookup.scala 31:38]
    node _decoded_inst_T_54 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_55 = eq(UInt<15>("h6063"), _decoded_inst_T_54) @[Lookup.scala 31:38]
    node _decoded_inst_T_56 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_57 = eq(UInt<15>("h7063"), _decoded_inst_T_56) @[Lookup.scala 31:38]
    node _decoded_inst_T_58 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_59 = eq(UInt<15>("h4063"), _decoded_inst_T_58) @[Lookup.scala 31:38]
    node _decoded_inst_T_60 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_61 = eq(UInt<15>("h5063"), _decoded_inst_T_60) @[Lookup.scala 31:38]
    node _decoded_inst_T_62 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_63 = eq(UInt<13>("h1073"), _decoded_inst_T_62) @[Lookup.scala 31:38]
    node _decoded_inst_T_64 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_65 = eq(UInt<15>("h5073"), _decoded_inst_T_64) @[Lookup.scala 31:38]
    node _decoded_inst_T_66 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_67 = eq(UInt<14>("h2073"), _decoded_inst_T_66) @[Lookup.scala 31:38]
    node _decoded_inst_T_68 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_69 = eq(UInt<15>("h6073"), _decoded_inst_T_68) @[Lookup.scala 31:38]
    node _decoded_inst_T_70 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_71 = eq(UInt<14>("h3073"), _decoded_inst_T_70) @[Lookup.scala 31:38]
    node _decoded_inst_T_72 = and(id_inst_reg, UInt<15>("h707f")) @[Lookup.scala 31:38]
    node _decoded_inst_T_73 = eq(UInt<15>("h7073"), _decoded_inst_T_72) @[Lookup.scala 31:38]
    node _decoded_inst_T_74 = and(id_inst_reg, UInt<32>("hffffffff")) @[Lookup.scala 31:38]
    node _decoded_inst_T_75 = eq(UInt<7>("h73"), _decoded_inst_T_74) @[Lookup.scala 31:38]
    node _decoded_inst_T_76 = mux(_decoded_inst_T_75, UInt<5>("h0"), UInt<5>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_77 = mux(_decoded_inst_T_73, UInt<5>("hc"), _decoded_inst_T_76) @[Lookup.scala 34:39]
    node _decoded_inst_T_78 = mux(_decoded_inst_T_71, UInt<5>("hc"), _decoded_inst_T_77) @[Lookup.scala 34:39]
    node _decoded_inst_T_79 = mux(_decoded_inst_T_69, UInt<5>("hc"), _decoded_inst_T_78) @[Lookup.scala 34:39]
    node _decoded_inst_T_80 = mux(_decoded_inst_T_67, UInt<5>("hc"), _decoded_inst_T_79) @[Lookup.scala 34:39]
    node _decoded_inst_T_81 = mux(_decoded_inst_T_65, UInt<5>("hc"), _decoded_inst_T_80) @[Lookup.scala 34:39]
    node _decoded_inst_T_82 = mux(_decoded_inst_T_63, UInt<5>("hc"), _decoded_inst_T_81) @[Lookup.scala 34:39]
    node _decoded_inst_T_83 = mux(_decoded_inst_T_61, UInt<5>("h12"), _decoded_inst_T_82) @[Lookup.scala 34:39]
    node _decoded_inst_T_84 = mux(_decoded_inst_T_59, UInt<5>("h11"), _decoded_inst_T_83) @[Lookup.scala 34:39]
    node _decoded_inst_T_85 = mux(_decoded_inst_T_57, UInt<5>("h10"), _decoded_inst_T_84) @[Lookup.scala 34:39]
    node _decoded_inst_T_86 = mux(_decoded_inst_T_55, UInt<5>("hf"), _decoded_inst_T_85) @[Lookup.scala 34:39]
    node _decoded_inst_T_87 = mux(_decoded_inst_T_53, UInt<5>("he"), _decoded_inst_T_86) @[Lookup.scala 34:39]
    node _decoded_inst_T_88 = mux(_decoded_inst_T_51, UInt<5>("hd"), _decoded_inst_T_87) @[Lookup.scala 34:39]
    node _decoded_inst_T_89 = mux(_decoded_inst_T_49, UInt<5>("hb"), _decoded_inst_T_88) @[Lookup.scala 34:39]
    node _decoded_inst_T_90 = mux(_decoded_inst_T_47, UInt<5>("h1"), _decoded_inst_T_89) @[Lookup.scala 34:39]
    node _decoded_inst_T_91 = mux(_decoded_inst_T_45, UInt<5>("h1"), _decoded_inst_T_90) @[Lookup.scala 34:39]
    node _decoded_inst_T_92 = mux(_decoded_inst_T_43, UInt<5>("h1"), _decoded_inst_T_91) @[Lookup.scala 34:39]
    node _decoded_inst_T_93 = mux(_decoded_inst_T_41, UInt<5>("h9"), _decoded_inst_T_92) @[Lookup.scala 34:39]
    node _decoded_inst_T_94 = mux(_decoded_inst_T_39, UInt<5>("h9"), _decoded_inst_T_93) @[Lookup.scala 34:39]
    node _decoded_inst_T_95 = mux(_decoded_inst_T_37, UInt<5>("h9"), _decoded_inst_T_94) @[Lookup.scala 34:39]
    node _decoded_inst_T_96 = mux(_decoded_inst_T_35, UInt<5>("h9"), _decoded_inst_T_95) @[Lookup.scala 34:39]
    node _decoded_inst_T_97 = mux(_decoded_inst_T_33, UInt<5>("h8"), _decoded_inst_T_96) @[Lookup.scala 34:39]
    node _decoded_inst_T_98 = mux(_decoded_inst_T_31, UInt<5>("h8"), _decoded_inst_T_97) @[Lookup.scala 34:39]
    node _decoded_inst_T_99 = mux(_decoded_inst_T_29, UInt<5>("h7"), _decoded_inst_T_98) @[Lookup.scala 34:39]
    node _decoded_inst_T_100 = mux(_decoded_inst_T_27, UInt<5>("h7"), _decoded_inst_T_99) @[Lookup.scala 34:39]
    node _decoded_inst_T_101 = mux(_decoded_inst_T_25, UInt<5>("h6"), _decoded_inst_T_100) @[Lookup.scala 34:39]
    node _decoded_inst_T_102 = mux(_decoded_inst_T_23, UInt<5>("h6"), _decoded_inst_T_101) @[Lookup.scala 34:39]
    node _decoded_inst_T_103 = mux(_decoded_inst_T_21, UInt<5>("h4"), _decoded_inst_T_102) @[Lookup.scala 34:39]
    node _decoded_inst_T_104 = mux(_decoded_inst_T_19, UInt<5>("h5"), _decoded_inst_T_103) @[Lookup.scala 34:39]
    node _decoded_inst_T_105 = mux(_decoded_inst_T_17, UInt<5>("h4"), _decoded_inst_T_104) @[Lookup.scala 34:39]
    node _decoded_inst_T_106 = mux(_decoded_inst_T_15, UInt<5>("h4"), _decoded_inst_T_105) @[Lookup.scala 34:39]
    node _decoded_inst_T_107 = mux(_decoded_inst_T_13, UInt<5>("h3"), _decoded_inst_T_106) @[Lookup.scala 34:39]
    node _decoded_inst_T_108 = mux(_decoded_inst_T_11, UInt<5>("h3"), _decoded_inst_T_107) @[Lookup.scala 34:39]
    node _decoded_inst_T_109 = mux(_decoded_inst_T_9, UInt<5>("h1"), _decoded_inst_T_108) @[Lookup.scala 34:39]
    node _decoded_inst_T_110 = mux(_decoded_inst_T_7, UInt<5>("h2"), _decoded_inst_T_109) @[Lookup.scala 34:39]
    node _decoded_inst_T_111 = mux(_decoded_inst_T_5, UInt<5>("h1"), _decoded_inst_T_110) @[Lookup.scala 34:39]
    node _decoded_inst_T_112 = mux(_decoded_inst_T_3, UInt<5>("h1"), _decoded_inst_T_111) @[Lookup.scala 34:39]
    node decoded_inst_0 = mux(_decoded_inst_T_1, UInt<5>("h1"), _decoded_inst_T_112) @[Lookup.scala 34:39]
    node _decoded_inst_T_113 = mux(_decoded_inst_T_75, UInt<2>("h0"), UInt<2>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_114 = mux(_decoded_inst_T_73, UInt<2>("h3"), _decoded_inst_T_113) @[Lookup.scala 34:39]
    node _decoded_inst_T_115 = mux(_decoded_inst_T_71, UInt<2>("h1"), _decoded_inst_T_114) @[Lookup.scala 34:39]
    node _decoded_inst_T_116 = mux(_decoded_inst_T_69, UInt<2>("h3"), _decoded_inst_T_115) @[Lookup.scala 34:39]
    node _decoded_inst_T_117 = mux(_decoded_inst_T_67, UInt<2>("h1"), _decoded_inst_T_116) @[Lookup.scala 34:39]
    node _decoded_inst_T_118 = mux(_decoded_inst_T_65, UInt<2>("h3"), _decoded_inst_T_117) @[Lookup.scala 34:39]
    node _decoded_inst_T_119 = mux(_decoded_inst_T_63, UInt<2>("h1"), _decoded_inst_T_118) @[Lookup.scala 34:39]
    node _decoded_inst_T_120 = mux(_decoded_inst_T_61, UInt<2>("h1"), _decoded_inst_T_119) @[Lookup.scala 34:39]
    node _decoded_inst_T_121 = mux(_decoded_inst_T_59, UInt<2>("h1"), _decoded_inst_T_120) @[Lookup.scala 34:39]
    node _decoded_inst_T_122 = mux(_decoded_inst_T_57, UInt<2>("h1"), _decoded_inst_T_121) @[Lookup.scala 34:39]
    node _decoded_inst_T_123 = mux(_decoded_inst_T_55, UInt<2>("h1"), _decoded_inst_T_122) @[Lookup.scala 34:39]
    node _decoded_inst_T_124 = mux(_decoded_inst_T_53, UInt<2>("h1"), _decoded_inst_T_123) @[Lookup.scala 34:39]
    node _decoded_inst_T_125 = mux(_decoded_inst_T_51, UInt<2>("h1"), _decoded_inst_T_124) @[Lookup.scala 34:39]
    node _decoded_inst_T_126 = mux(_decoded_inst_T_49, UInt<2>("h2"), _decoded_inst_T_125) @[Lookup.scala 34:39]
    node _decoded_inst_T_127 = mux(_decoded_inst_T_47, UInt<2>("h2"), _decoded_inst_T_126) @[Lookup.scala 34:39]
    node _decoded_inst_T_128 = mux(_decoded_inst_T_45, UInt<2>("h0"), _decoded_inst_T_127) @[Lookup.scala 34:39]
    node _decoded_inst_T_129 = mux(_decoded_inst_T_43, UInt<2>("h2"), _decoded_inst_T_128) @[Lookup.scala 34:39]
    node _decoded_inst_T_130 = mux(_decoded_inst_T_41, UInt<2>("h1"), _decoded_inst_T_129) @[Lookup.scala 34:39]
    node _decoded_inst_T_131 = mux(_decoded_inst_T_39, UInt<2>("h1"), _decoded_inst_T_130) @[Lookup.scala 34:39]
    node _decoded_inst_T_132 = mux(_decoded_inst_T_37, UInt<2>("h1"), _decoded_inst_T_131) @[Lookup.scala 34:39]
    node _decoded_inst_T_133 = mux(_decoded_inst_T_35, UInt<2>("h1"), _decoded_inst_T_132) @[Lookup.scala 34:39]
    node _decoded_inst_T_134 = mux(_decoded_inst_T_33, UInt<2>("h1"), _decoded_inst_T_133) @[Lookup.scala 34:39]
    node _decoded_inst_T_135 = mux(_decoded_inst_T_31, UInt<2>("h1"), _decoded_inst_T_134) @[Lookup.scala 34:39]
    node _decoded_inst_T_136 = mux(_decoded_inst_T_29, UInt<2>("h1"), _decoded_inst_T_135) @[Lookup.scala 34:39]
    node _decoded_inst_T_137 = mux(_decoded_inst_T_27, UInt<2>("h1"), _decoded_inst_T_136) @[Lookup.scala 34:39]
    node _decoded_inst_T_138 = mux(_decoded_inst_T_25, UInt<2>("h1"), _decoded_inst_T_137) @[Lookup.scala 34:39]
    node _decoded_inst_T_139 = mux(_decoded_inst_T_23, UInt<2>("h1"), _decoded_inst_T_138) @[Lookup.scala 34:39]
    node _decoded_inst_T_140 = mux(_decoded_inst_T_21, UInt<2>("h1"), _decoded_inst_T_139) @[Lookup.scala 34:39]
    node _decoded_inst_T_141 = mux(_decoded_inst_T_19, UInt<2>("h1"), _decoded_inst_T_140) @[Lookup.scala 34:39]
    node _decoded_inst_T_142 = mux(_decoded_inst_T_17, UInt<2>("h1"), _decoded_inst_T_141) @[Lookup.scala 34:39]
    node _decoded_inst_T_143 = mux(_decoded_inst_T_15, UInt<2>("h1"), _decoded_inst_T_142) @[Lookup.scala 34:39]
    node _decoded_inst_T_144 = mux(_decoded_inst_T_13, UInt<2>("h1"), _decoded_inst_T_143) @[Lookup.scala 34:39]
    node _decoded_inst_T_145 = mux(_decoded_inst_T_11, UInt<2>("h1"), _decoded_inst_T_144) @[Lookup.scala 34:39]
    node _decoded_inst_T_146 = mux(_decoded_inst_T_9, UInt<2>("h1"), _decoded_inst_T_145) @[Lookup.scala 34:39]
    node _decoded_inst_T_147 = mux(_decoded_inst_T_7, UInt<2>("h1"), _decoded_inst_T_146) @[Lookup.scala 34:39]
    node _decoded_inst_T_148 = mux(_decoded_inst_T_5, UInt<2>("h1"), _decoded_inst_T_147) @[Lookup.scala 34:39]
    node _decoded_inst_T_149 = mux(_decoded_inst_T_3, UInt<2>("h1"), _decoded_inst_T_148) @[Lookup.scala 34:39]
    node decoded_inst_1 = mux(_decoded_inst_T_1, UInt<2>("h1"), _decoded_inst_T_149) @[Lookup.scala 34:39]
    node _decoded_inst_T_150 = mux(_decoded_inst_T_75, UInt<3>("h0"), UInt<3>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_151 = mux(_decoded_inst_T_73, UInt<3>("h0"), _decoded_inst_T_150) @[Lookup.scala 34:39]
    node _decoded_inst_T_152 = mux(_decoded_inst_T_71, UInt<3>("h1"), _decoded_inst_T_151) @[Lookup.scala 34:39]
    node _decoded_inst_T_153 = mux(_decoded_inst_T_69, UInt<3>("h0"), _decoded_inst_T_152) @[Lookup.scala 34:39]
    node _decoded_inst_T_154 = mux(_decoded_inst_T_67, UInt<3>("h0"), _decoded_inst_T_153) @[Lookup.scala 34:39]
    node _decoded_inst_T_155 = mux(_decoded_inst_T_65, UInt<3>("h0"), _decoded_inst_T_154) @[Lookup.scala 34:39]
    node _decoded_inst_T_156 = mux(_decoded_inst_T_63, UInt<3>("h0"), _decoded_inst_T_155) @[Lookup.scala 34:39]
    node _decoded_inst_T_157 = mux(_decoded_inst_T_61, UInt<3>("h1"), _decoded_inst_T_156) @[Lookup.scala 34:39]
    node _decoded_inst_T_158 = mux(_decoded_inst_T_59, UInt<3>("h1"), _decoded_inst_T_157) @[Lookup.scala 34:39]
    node _decoded_inst_T_159 = mux(_decoded_inst_T_57, UInt<3>("h1"), _decoded_inst_T_158) @[Lookup.scala 34:39]
    node _decoded_inst_T_160 = mux(_decoded_inst_T_55, UInt<3>("h1"), _decoded_inst_T_159) @[Lookup.scala 34:39]
    node _decoded_inst_T_161 = mux(_decoded_inst_T_53, UInt<3>("h1"), _decoded_inst_T_160) @[Lookup.scala 34:39]
    node _decoded_inst_T_162 = mux(_decoded_inst_T_51, UInt<3>("h1"), _decoded_inst_T_161) @[Lookup.scala 34:39]
    node _decoded_inst_T_163 = mux(_decoded_inst_T_49, UInt<3>("h3"), _decoded_inst_T_162) @[Lookup.scala 34:39]
    node _decoded_inst_T_164 = mux(_decoded_inst_T_47, UInt<3>("h5"), _decoded_inst_T_163) @[Lookup.scala 34:39]
    node _decoded_inst_T_165 = mux(_decoded_inst_T_45, UInt<3>("h5"), _decoded_inst_T_164) @[Lookup.scala 34:39]
    node _decoded_inst_T_166 = mux(_decoded_inst_T_43, UInt<3>("h3"), _decoded_inst_T_165) @[Lookup.scala 34:39]
    node _decoded_inst_T_167 = mux(_decoded_inst_T_41, UInt<3>("h2"), _decoded_inst_T_166) @[Lookup.scala 34:39]
    node _decoded_inst_T_168 = mux(_decoded_inst_T_39, UInt<3>("h1"), _decoded_inst_T_167) @[Lookup.scala 34:39]
    node _decoded_inst_T_169 = mux(_decoded_inst_T_37, UInt<3>("h2"), _decoded_inst_T_168) @[Lookup.scala 34:39]
    node _decoded_inst_T_170 = mux(_decoded_inst_T_35, UInt<3>("h1"), _decoded_inst_T_169) @[Lookup.scala 34:39]
    node _decoded_inst_T_171 = mux(_decoded_inst_T_33, UInt<3>("h2"), _decoded_inst_T_170) @[Lookup.scala 34:39]
    node _decoded_inst_T_172 = mux(_decoded_inst_T_31, UInt<3>("h1"), _decoded_inst_T_171) @[Lookup.scala 34:39]
    node _decoded_inst_T_173 = mux(_decoded_inst_T_29, UInt<3>("h2"), _decoded_inst_T_172) @[Lookup.scala 34:39]
    node _decoded_inst_T_174 = mux(_decoded_inst_T_27, UInt<3>("h1"), _decoded_inst_T_173) @[Lookup.scala 34:39]
    node _decoded_inst_T_175 = mux(_decoded_inst_T_25, UInt<3>("h2"), _decoded_inst_T_174) @[Lookup.scala 34:39]
    node _decoded_inst_T_176 = mux(_decoded_inst_T_23, UInt<3>("h1"), _decoded_inst_T_175) @[Lookup.scala 34:39]
    node _decoded_inst_T_177 = mux(_decoded_inst_T_21, UInt<3>("h2"), _decoded_inst_T_176) @[Lookup.scala 34:39]
    node _decoded_inst_T_178 = mux(_decoded_inst_T_19, UInt<3>("h1"), _decoded_inst_T_177) @[Lookup.scala 34:39]
    node _decoded_inst_T_179 = mux(_decoded_inst_T_17, UInt<3>("h2"), _decoded_inst_T_178) @[Lookup.scala 34:39]
    node _decoded_inst_T_180 = mux(_decoded_inst_T_15, UInt<3>("h1"), _decoded_inst_T_179) @[Lookup.scala 34:39]
    node _decoded_inst_T_181 = mux(_decoded_inst_T_13, UInt<3>("h2"), _decoded_inst_T_180) @[Lookup.scala 34:39]
    node _decoded_inst_T_182 = mux(_decoded_inst_T_11, UInt<3>("h1"), _decoded_inst_T_181) @[Lookup.scala 34:39]
    node _decoded_inst_T_183 = mux(_decoded_inst_T_9, UInt<3>("h2"), _decoded_inst_T_182) @[Lookup.scala 34:39]
    node _decoded_inst_T_184 = mux(_decoded_inst_T_7, UInt<3>("h1"), _decoded_inst_T_183) @[Lookup.scala 34:39]
    node _decoded_inst_T_185 = mux(_decoded_inst_T_5, UInt<3>("h1"), _decoded_inst_T_184) @[Lookup.scala 34:39]
    node _decoded_inst_T_186 = mux(_decoded_inst_T_3, UInt<3>("h2"), _decoded_inst_T_185) @[Lookup.scala 34:39]
    node decoded_inst_2 = mux(_decoded_inst_T_1, UInt<3>("h4"), _decoded_inst_T_186) @[Lookup.scala 34:39]
    node _decoded_inst_T_187 = mux(_decoded_inst_T_75, UInt<2>("h0"), UInt<2>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_188 = mux(_decoded_inst_T_73, UInt<2>("h0"), _decoded_inst_T_187) @[Lookup.scala 34:39]
    node _decoded_inst_T_189 = mux(_decoded_inst_T_71, UInt<2>("h0"), _decoded_inst_T_188) @[Lookup.scala 34:39]
    node _decoded_inst_T_190 = mux(_decoded_inst_T_69, UInt<2>("h0"), _decoded_inst_T_189) @[Lookup.scala 34:39]
    node _decoded_inst_T_191 = mux(_decoded_inst_T_67, UInt<2>("h0"), _decoded_inst_T_190) @[Lookup.scala 34:39]
    node _decoded_inst_T_192 = mux(_decoded_inst_T_65, UInt<2>("h0"), _decoded_inst_T_191) @[Lookup.scala 34:39]
    node _decoded_inst_T_193 = mux(_decoded_inst_T_63, UInt<2>("h0"), _decoded_inst_T_192) @[Lookup.scala 34:39]
    node _decoded_inst_T_194 = mux(_decoded_inst_T_61, UInt<2>("h0"), _decoded_inst_T_193) @[Lookup.scala 34:39]
    node _decoded_inst_T_195 = mux(_decoded_inst_T_59, UInt<2>("h0"), _decoded_inst_T_194) @[Lookup.scala 34:39]
    node _decoded_inst_T_196 = mux(_decoded_inst_T_57, UInt<2>("h0"), _decoded_inst_T_195) @[Lookup.scala 34:39]
    node _decoded_inst_T_197 = mux(_decoded_inst_T_55, UInt<2>("h0"), _decoded_inst_T_196) @[Lookup.scala 34:39]
    node _decoded_inst_T_198 = mux(_decoded_inst_T_53, UInt<2>("h0"), _decoded_inst_T_197) @[Lookup.scala 34:39]
    node _decoded_inst_T_199 = mux(_decoded_inst_T_51, UInt<2>("h0"), _decoded_inst_T_198) @[Lookup.scala 34:39]
    node _decoded_inst_T_200 = mux(_decoded_inst_T_49, UInt<2>("h0"), _decoded_inst_T_199) @[Lookup.scala 34:39]
    node _decoded_inst_T_201 = mux(_decoded_inst_T_47, UInt<2>("h0"), _decoded_inst_T_200) @[Lookup.scala 34:39]
    node _decoded_inst_T_202 = mux(_decoded_inst_T_45, UInt<2>("h0"), _decoded_inst_T_201) @[Lookup.scala 34:39]
    node _decoded_inst_T_203 = mux(_decoded_inst_T_43, UInt<2>("h0"), _decoded_inst_T_202) @[Lookup.scala 34:39]
    node _decoded_inst_T_204 = mux(_decoded_inst_T_41, UInt<2>("h0"), _decoded_inst_T_203) @[Lookup.scala 34:39]
    node _decoded_inst_T_205 = mux(_decoded_inst_T_39, UInt<2>("h0"), _decoded_inst_T_204) @[Lookup.scala 34:39]
    node _decoded_inst_T_206 = mux(_decoded_inst_T_37, UInt<2>("h0"), _decoded_inst_T_205) @[Lookup.scala 34:39]
    node _decoded_inst_T_207 = mux(_decoded_inst_T_35, UInt<2>("h0"), _decoded_inst_T_206) @[Lookup.scala 34:39]
    node _decoded_inst_T_208 = mux(_decoded_inst_T_33, UInt<2>("h0"), _decoded_inst_T_207) @[Lookup.scala 34:39]
    node _decoded_inst_T_209 = mux(_decoded_inst_T_31, UInt<2>("h0"), _decoded_inst_T_208) @[Lookup.scala 34:39]
    node _decoded_inst_T_210 = mux(_decoded_inst_T_29, UInt<2>("h0"), _decoded_inst_T_209) @[Lookup.scala 34:39]
    node _decoded_inst_T_211 = mux(_decoded_inst_T_27, UInt<2>("h0"), _decoded_inst_T_210) @[Lookup.scala 34:39]
    node _decoded_inst_T_212 = mux(_decoded_inst_T_25, UInt<2>("h0"), _decoded_inst_T_211) @[Lookup.scala 34:39]
    node _decoded_inst_T_213 = mux(_decoded_inst_T_23, UInt<2>("h0"), _decoded_inst_T_212) @[Lookup.scala 34:39]
    node _decoded_inst_T_214 = mux(_decoded_inst_T_21, UInt<2>("h0"), _decoded_inst_T_213) @[Lookup.scala 34:39]
    node _decoded_inst_T_215 = mux(_decoded_inst_T_19, UInt<2>("h0"), _decoded_inst_T_214) @[Lookup.scala 34:39]
    node _decoded_inst_T_216 = mux(_decoded_inst_T_17, UInt<2>("h0"), _decoded_inst_T_215) @[Lookup.scala 34:39]
    node _decoded_inst_T_217 = mux(_decoded_inst_T_15, UInt<2>("h0"), _decoded_inst_T_216) @[Lookup.scala 34:39]
    node _decoded_inst_T_218 = mux(_decoded_inst_T_13, UInt<2>("h0"), _decoded_inst_T_217) @[Lookup.scala 34:39]
    node _decoded_inst_T_219 = mux(_decoded_inst_T_11, UInt<2>("h0"), _decoded_inst_T_218) @[Lookup.scala 34:39]
    node _decoded_inst_T_220 = mux(_decoded_inst_T_9, UInt<2>("h0"), _decoded_inst_T_219) @[Lookup.scala 34:39]
    node _decoded_inst_T_221 = mux(_decoded_inst_T_7, UInt<2>("h0"), _decoded_inst_T_220) @[Lookup.scala 34:39]
    node _decoded_inst_T_222 = mux(_decoded_inst_T_5, UInt<2>("h0"), _decoded_inst_T_221) @[Lookup.scala 34:39]
    node _decoded_inst_T_223 = mux(_decoded_inst_T_3, UInt<2>("h0"), _decoded_inst_T_222) @[Lookup.scala 34:39]
    node decoded_inst_3 = mux(_decoded_inst_T_1, UInt<2>("h1"), _decoded_inst_T_223) @[Lookup.scala 34:39]
    node _decoded_inst_T_224 = mux(_decoded_inst_T_75, UInt<2>("h0"), UInt<2>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_225 = mux(_decoded_inst_T_73, UInt<2>("h1"), _decoded_inst_T_224) @[Lookup.scala 34:39]
    node _decoded_inst_T_226 = mux(_decoded_inst_T_71, UInt<2>("h1"), _decoded_inst_T_225) @[Lookup.scala 34:39]
    node _decoded_inst_T_227 = mux(_decoded_inst_T_69, UInt<2>("h1"), _decoded_inst_T_226) @[Lookup.scala 34:39]
    node _decoded_inst_T_228 = mux(_decoded_inst_T_67, UInt<2>("h1"), _decoded_inst_T_227) @[Lookup.scala 34:39]
    node _decoded_inst_T_229 = mux(_decoded_inst_T_65, UInt<2>("h1"), _decoded_inst_T_228) @[Lookup.scala 34:39]
    node _decoded_inst_T_230 = mux(_decoded_inst_T_63, UInt<2>("h1"), _decoded_inst_T_229) @[Lookup.scala 34:39]
    node _decoded_inst_T_231 = mux(_decoded_inst_T_61, UInt<2>("h0"), _decoded_inst_T_230) @[Lookup.scala 34:39]
    node _decoded_inst_T_232 = mux(_decoded_inst_T_59, UInt<2>("h0"), _decoded_inst_T_231) @[Lookup.scala 34:39]
    node _decoded_inst_T_233 = mux(_decoded_inst_T_57, UInt<2>("h0"), _decoded_inst_T_232) @[Lookup.scala 34:39]
    node _decoded_inst_T_234 = mux(_decoded_inst_T_55, UInt<2>("h0"), _decoded_inst_T_233) @[Lookup.scala 34:39]
    node _decoded_inst_T_235 = mux(_decoded_inst_T_53, UInt<2>("h0"), _decoded_inst_T_234) @[Lookup.scala 34:39]
    node _decoded_inst_T_236 = mux(_decoded_inst_T_51, UInt<2>("h0"), _decoded_inst_T_235) @[Lookup.scala 34:39]
    node _decoded_inst_T_237 = mux(_decoded_inst_T_49, UInt<2>("h1"), _decoded_inst_T_236) @[Lookup.scala 34:39]
    node _decoded_inst_T_238 = mux(_decoded_inst_T_47, UInt<2>("h1"), _decoded_inst_T_237) @[Lookup.scala 34:39]
    node _decoded_inst_T_239 = mux(_decoded_inst_T_45, UInt<2>("h1"), _decoded_inst_T_238) @[Lookup.scala 34:39]
    node _decoded_inst_T_240 = mux(_decoded_inst_T_43, UInt<2>("h1"), _decoded_inst_T_239) @[Lookup.scala 34:39]
    node _decoded_inst_T_241 = mux(_decoded_inst_T_41, UInt<2>("h1"), _decoded_inst_T_240) @[Lookup.scala 34:39]
    node _decoded_inst_T_242 = mux(_decoded_inst_T_39, UInt<2>("h1"), _decoded_inst_T_241) @[Lookup.scala 34:39]
    node _decoded_inst_T_243 = mux(_decoded_inst_T_37, UInt<2>("h1"), _decoded_inst_T_242) @[Lookup.scala 34:39]
    node _decoded_inst_T_244 = mux(_decoded_inst_T_35, UInt<2>("h1"), _decoded_inst_T_243) @[Lookup.scala 34:39]
    node _decoded_inst_T_245 = mux(_decoded_inst_T_33, UInt<2>("h1"), _decoded_inst_T_244) @[Lookup.scala 34:39]
    node _decoded_inst_T_246 = mux(_decoded_inst_T_31, UInt<2>("h1"), _decoded_inst_T_245) @[Lookup.scala 34:39]
    node _decoded_inst_T_247 = mux(_decoded_inst_T_29, UInt<2>("h1"), _decoded_inst_T_246) @[Lookup.scala 34:39]
    node _decoded_inst_T_248 = mux(_decoded_inst_T_27, UInt<2>("h1"), _decoded_inst_T_247) @[Lookup.scala 34:39]
    node _decoded_inst_T_249 = mux(_decoded_inst_T_25, UInt<2>("h1"), _decoded_inst_T_248) @[Lookup.scala 34:39]
    node _decoded_inst_T_250 = mux(_decoded_inst_T_23, UInt<2>("h1"), _decoded_inst_T_249) @[Lookup.scala 34:39]
    node _decoded_inst_T_251 = mux(_decoded_inst_T_21, UInt<2>("h1"), _decoded_inst_T_250) @[Lookup.scala 34:39]
    node _decoded_inst_T_252 = mux(_decoded_inst_T_19, UInt<2>("h1"), _decoded_inst_T_251) @[Lookup.scala 34:39]
    node _decoded_inst_T_253 = mux(_decoded_inst_T_17, UInt<2>("h1"), _decoded_inst_T_252) @[Lookup.scala 34:39]
    node _decoded_inst_T_254 = mux(_decoded_inst_T_15, UInt<2>("h1"), _decoded_inst_T_253) @[Lookup.scala 34:39]
    node _decoded_inst_T_255 = mux(_decoded_inst_T_13, UInt<2>("h1"), _decoded_inst_T_254) @[Lookup.scala 34:39]
    node _decoded_inst_T_256 = mux(_decoded_inst_T_11, UInt<2>("h1"), _decoded_inst_T_255) @[Lookup.scala 34:39]
    node _decoded_inst_T_257 = mux(_decoded_inst_T_9, UInt<2>("h1"), _decoded_inst_T_256) @[Lookup.scala 34:39]
    node _decoded_inst_T_258 = mux(_decoded_inst_T_7, UInt<2>("h1"), _decoded_inst_T_257) @[Lookup.scala 34:39]
    node _decoded_inst_T_259 = mux(_decoded_inst_T_5, UInt<2>("h1"), _decoded_inst_T_258) @[Lookup.scala 34:39]
    node _decoded_inst_T_260 = mux(_decoded_inst_T_3, UInt<2>("h1"), _decoded_inst_T_259) @[Lookup.scala 34:39]
    node decoded_inst_4 = mux(_decoded_inst_T_1, UInt<2>("h0"), _decoded_inst_T_260) @[Lookup.scala 34:39]
    node _decoded_inst_T_261 = mux(_decoded_inst_T_75, UInt<3>("h0"), UInt<3>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_262 = mux(_decoded_inst_T_73, UInt<3>("h4"), _decoded_inst_T_261) @[Lookup.scala 34:39]
    node _decoded_inst_T_263 = mux(_decoded_inst_T_71, UInt<3>("h4"), _decoded_inst_T_262) @[Lookup.scala 34:39]
    node _decoded_inst_T_264 = mux(_decoded_inst_T_69, UInt<3>("h4"), _decoded_inst_T_263) @[Lookup.scala 34:39]
    node _decoded_inst_T_265 = mux(_decoded_inst_T_67, UInt<3>("h4"), _decoded_inst_T_264) @[Lookup.scala 34:39]
    node _decoded_inst_T_266 = mux(_decoded_inst_T_65, UInt<3>("h4"), _decoded_inst_T_265) @[Lookup.scala 34:39]
    node _decoded_inst_T_267 = mux(_decoded_inst_T_63, UInt<3>("h4"), _decoded_inst_T_266) @[Lookup.scala 34:39]
    node _decoded_inst_T_268 = mux(_decoded_inst_T_61, UInt<3>("h0"), _decoded_inst_T_267) @[Lookup.scala 34:39]
    node _decoded_inst_T_269 = mux(_decoded_inst_T_59, UInt<3>("h0"), _decoded_inst_T_268) @[Lookup.scala 34:39]
    node _decoded_inst_T_270 = mux(_decoded_inst_T_57, UInt<3>("h0"), _decoded_inst_T_269) @[Lookup.scala 34:39]
    node _decoded_inst_T_271 = mux(_decoded_inst_T_55, UInt<3>("h0"), _decoded_inst_T_270) @[Lookup.scala 34:39]
    node _decoded_inst_T_272 = mux(_decoded_inst_T_53, UInt<3>("h0"), _decoded_inst_T_271) @[Lookup.scala 34:39]
    node _decoded_inst_T_273 = mux(_decoded_inst_T_51, UInt<3>("h0"), _decoded_inst_T_272) @[Lookup.scala 34:39]
    node _decoded_inst_T_274 = mux(_decoded_inst_T_49, UInt<3>("h3"), _decoded_inst_T_273) @[Lookup.scala 34:39]
    node _decoded_inst_T_275 = mux(_decoded_inst_T_47, UInt<3>("h1"), _decoded_inst_T_274) @[Lookup.scala 34:39]
    node _decoded_inst_T_276 = mux(_decoded_inst_T_45, UInt<3>("h1"), _decoded_inst_T_275) @[Lookup.scala 34:39]
    node _decoded_inst_T_277 = mux(_decoded_inst_T_43, UInt<3>("h3"), _decoded_inst_T_276) @[Lookup.scala 34:39]
    node _decoded_inst_T_278 = mux(_decoded_inst_T_41, UInt<3>("h1"), _decoded_inst_T_277) @[Lookup.scala 34:39]
    node _decoded_inst_T_279 = mux(_decoded_inst_T_39, UInt<3>("h1"), _decoded_inst_T_278) @[Lookup.scala 34:39]
    node _decoded_inst_T_280 = mux(_decoded_inst_T_37, UInt<3>("h1"), _decoded_inst_T_279) @[Lookup.scala 34:39]
    node _decoded_inst_T_281 = mux(_decoded_inst_T_35, UInt<3>("h1"), _decoded_inst_T_280) @[Lookup.scala 34:39]
    node _decoded_inst_T_282 = mux(_decoded_inst_T_33, UInt<3>("h1"), _decoded_inst_T_281) @[Lookup.scala 34:39]
    node _decoded_inst_T_283 = mux(_decoded_inst_T_31, UInt<3>("h1"), _decoded_inst_T_282) @[Lookup.scala 34:39]
    node _decoded_inst_T_284 = mux(_decoded_inst_T_29, UInt<3>("h1"), _decoded_inst_T_283) @[Lookup.scala 34:39]
    node _decoded_inst_T_285 = mux(_decoded_inst_T_27, UInt<3>("h1"), _decoded_inst_T_284) @[Lookup.scala 34:39]
    node _decoded_inst_T_286 = mux(_decoded_inst_T_25, UInt<3>("h1"), _decoded_inst_T_285) @[Lookup.scala 34:39]
    node _decoded_inst_T_287 = mux(_decoded_inst_T_23, UInt<3>("h1"), _decoded_inst_T_286) @[Lookup.scala 34:39]
    node _decoded_inst_T_288 = mux(_decoded_inst_T_21, UInt<3>("h1"), _decoded_inst_T_287) @[Lookup.scala 34:39]
    node _decoded_inst_T_289 = mux(_decoded_inst_T_19, UInt<3>("h1"), _decoded_inst_T_288) @[Lookup.scala 34:39]
    node _decoded_inst_T_290 = mux(_decoded_inst_T_17, UInt<3>("h1"), _decoded_inst_T_289) @[Lookup.scala 34:39]
    node _decoded_inst_T_291 = mux(_decoded_inst_T_15, UInt<3>("h1"), _decoded_inst_T_290) @[Lookup.scala 34:39]
    node _decoded_inst_T_292 = mux(_decoded_inst_T_13, UInt<3>("h1"), _decoded_inst_T_291) @[Lookup.scala 34:39]
    node _decoded_inst_T_293 = mux(_decoded_inst_T_11, UInt<3>("h1"), _decoded_inst_T_292) @[Lookup.scala 34:39]
    node _decoded_inst_T_294 = mux(_decoded_inst_T_9, UInt<3>("h1"), _decoded_inst_T_293) @[Lookup.scala 34:39]
    node _decoded_inst_T_295 = mux(_decoded_inst_T_7, UInt<3>("h1"), _decoded_inst_T_294) @[Lookup.scala 34:39]
    node _decoded_inst_T_296 = mux(_decoded_inst_T_5, UInt<3>("h1"), _decoded_inst_T_295) @[Lookup.scala 34:39]
    node _decoded_inst_T_297 = mux(_decoded_inst_T_3, UInt<3>("h2"), _decoded_inst_T_296) @[Lookup.scala 34:39]
    node decoded_inst_5 = mux(_decoded_inst_T_1, UInt<3>("h0"), _decoded_inst_T_297) @[Lookup.scala 34:39]
    node _decoded_inst_T_298 = mux(_decoded_inst_T_75, UInt<3>("h4"), UInt<3>("h0")) @[Lookup.scala 34:39]
    node _decoded_inst_T_299 = mux(_decoded_inst_T_73, UInt<3>("h3"), _decoded_inst_T_298) @[Lookup.scala 34:39]
    node _decoded_inst_T_300 = mux(_decoded_inst_T_71, UInt<3>("h3"), _decoded_inst_T_299) @[Lookup.scala 34:39]
    node _decoded_inst_T_301 = mux(_decoded_inst_T_69, UInt<3>("h2"), _decoded_inst_T_300) @[Lookup.scala 34:39]
    node _decoded_inst_T_302 = mux(_decoded_inst_T_67, UInt<3>("h2"), _decoded_inst_T_301) @[Lookup.scala 34:39]
    node _decoded_inst_T_303 = mux(_decoded_inst_T_65, UInt<3>("h1"), _decoded_inst_T_302) @[Lookup.scala 34:39]
    node _decoded_inst_T_304 = mux(_decoded_inst_T_63, UInt<3>("h1"), _decoded_inst_T_303) @[Lookup.scala 34:39]
    node _decoded_inst_T_305 = mux(_decoded_inst_T_61, UInt<3>("h0"), _decoded_inst_T_304) @[Lookup.scala 34:39]
    node _decoded_inst_T_306 = mux(_decoded_inst_T_59, UInt<3>("h0"), _decoded_inst_T_305) @[Lookup.scala 34:39]
    node _decoded_inst_T_307 = mux(_decoded_inst_T_57, UInt<3>("h0"), _decoded_inst_T_306) @[Lookup.scala 34:39]
    node _decoded_inst_T_308 = mux(_decoded_inst_T_55, UInt<3>("h0"), _decoded_inst_T_307) @[Lookup.scala 34:39]
    node _decoded_inst_T_309 = mux(_decoded_inst_T_53, UInt<3>("h0"), _decoded_inst_T_308) @[Lookup.scala 34:39]
    node _decoded_inst_T_310 = mux(_decoded_inst_T_51, UInt<3>("h0"), _decoded_inst_T_309) @[Lookup.scala 34:39]
    node _decoded_inst_T_311 = mux(_decoded_inst_T_49, UInt<3>("h0"), _decoded_inst_T_310) @[Lookup.scala 34:39]
    node _decoded_inst_T_312 = mux(_decoded_inst_T_47, UInt<3>("h0"), _decoded_inst_T_311) @[Lookup.scala 34:39]
    node _decoded_inst_T_313 = mux(_decoded_inst_T_45, UInt<3>("h0"), _decoded_inst_T_312) @[Lookup.scala 34:39]
    node _decoded_inst_T_314 = mux(_decoded_inst_T_43, UInt<3>("h0"), _decoded_inst_T_313) @[Lookup.scala 34:39]
    node _decoded_inst_T_315 = mux(_decoded_inst_T_41, UInt<3>("h0"), _decoded_inst_T_314) @[Lookup.scala 34:39]
    node _decoded_inst_T_316 = mux(_decoded_inst_T_39, UInt<3>("h0"), _decoded_inst_T_315) @[Lookup.scala 34:39]
    node _decoded_inst_T_317 = mux(_decoded_inst_T_37, UInt<3>("h0"), _decoded_inst_T_316) @[Lookup.scala 34:39]
    node _decoded_inst_T_318 = mux(_decoded_inst_T_35, UInt<3>("h0"), _decoded_inst_T_317) @[Lookup.scala 34:39]
    node _decoded_inst_T_319 = mux(_decoded_inst_T_33, UInt<3>("h0"), _decoded_inst_T_318) @[Lookup.scala 34:39]
    node _decoded_inst_T_320 = mux(_decoded_inst_T_31, UInt<3>("h0"), _decoded_inst_T_319) @[Lookup.scala 34:39]
    node _decoded_inst_T_321 = mux(_decoded_inst_T_29, UInt<3>("h0"), _decoded_inst_T_320) @[Lookup.scala 34:39]
    node _decoded_inst_T_322 = mux(_decoded_inst_T_27, UInt<3>("h0"), _decoded_inst_T_321) @[Lookup.scala 34:39]
    node _decoded_inst_T_323 = mux(_decoded_inst_T_25, UInt<3>("h0"), _decoded_inst_T_322) @[Lookup.scala 34:39]
    node _decoded_inst_T_324 = mux(_decoded_inst_T_23, UInt<3>("h0"), _decoded_inst_T_323) @[Lookup.scala 34:39]
    node _decoded_inst_T_325 = mux(_decoded_inst_T_21, UInt<3>("h0"), _decoded_inst_T_324) @[Lookup.scala 34:39]
    node _decoded_inst_T_326 = mux(_decoded_inst_T_19, UInt<3>("h0"), _decoded_inst_T_325) @[Lookup.scala 34:39]
    node _decoded_inst_T_327 = mux(_decoded_inst_T_17, UInt<3>("h0"), _decoded_inst_T_326) @[Lookup.scala 34:39]
    node _decoded_inst_T_328 = mux(_decoded_inst_T_15, UInt<3>("h0"), _decoded_inst_T_327) @[Lookup.scala 34:39]
    node _decoded_inst_T_329 = mux(_decoded_inst_T_13, UInt<3>("h0"), _decoded_inst_T_328) @[Lookup.scala 34:39]
    node _decoded_inst_T_330 = mux(_decoded_inst_T_11, UInt<3>("h0"), _decoded_inst_T_329) @[Lookup.scala 34:39]
    node _decoded_inst_T_331 = mux(_decoded_inst_T_9, UInt<3>("h0"), _decoded_inst_T_330) @[Lookup.scala 34:39]
    node _decoded_inst_T_332 = mux(_decoded_inst_T_7, UInt<3>("h0"), _decoded_inst_T_331) @[Lookup.scala 34:39]
    node _decoded_inst_T_333 = mux(_decoded_inst_T_5, UInt<3>("h0"), _decoded_inst_T_332) @[Lookup.scala 34:39]
    node _decoded_inst_T_334 = mux(_decoded_inst_T_3, UInt<3>("h0"), _decoded_inst_T_333) @[Lookup.scala 34:39]
    node csr_cmd = mux(_decoded_inst_T_1, UInt<3>("h0"), _decoded_inst_T_334) @[Lookup.scala 34:39]
    node _op1_data_T = eq(decoded_inst_1, UInt<2>("h1")) @[Decode.scala 101:14]
    node _op1_data_T_1 = eq(decoded_inst_1, UInt<2>("h2")) @[Decode.scala 102:14]
    node _op1_data_T_2 = eq(decoded_inst_1, UInt<2>("h3")) @[Decode.scala 103:14]
    node _op1_data_T_3 = mux(_op1_data_T_2, imm_z_uext, UInt<32>("h0")) @[Mux.scala 101:16]
    node _op1_data_T_4 = mux(_op1_data_T_1, id_pc_reg, _op1_data_T_3) @[Mux.scala 101:16]
    node op1_data = mux(_op1_data_T, rs1_data, _op1_data_T_4) @[Mux.scala 101:16]
    node _op2_data_T = eq(decoded_inst_2, UInt<3>("h1")) @[Decode.scala 107:14]
    node _op2_data_T_1 = eq(decoded_inst_2, UInt<3>("h2")) @[Decode.scala 108:14]
    node _op2_data_T_2 = eq(decoded_inst_2, UInt<3>("h4")) @[Decode.scala 109:14]
    node _op2_data_T_3 = eq(decoded_inst_2, UInt<3>("h3")) @[Decode.scala 110:14]
    node _op2_data_T_4 = eq(decoded_inst_2, UInt<3>("h5")) @[Decode.scala 111:14]
    node _op2_data_T_5 = mux(_op2_data_T_4, imm_u_shifted, UInt<32>("h0")) @[Mux.scala 101:16]
    node _op2_data_T_6 = mux(_op2_data_T_3, imm_j_sext, _op2_data_T_5) @[Mux.scala 101:16]
    node _op2_data_T_7 = mux(_op2_data_T_2, imm_s_sext, _op2_data_T_6) @[Mux.scala 101:16]
    node _op2_data_T_8 = mux(_op2_data_T_1, imm_i_sext, _op2_data_T_7) @[Mux.scala 101:16]
    node op2_data = mux(_op2_data_T, rs2_data, _op2_data_T_8) @[Mux.scala 101:16]
    node _csr_addr_T = eq(csr_cmd, UInt<3>("h4")) @[Decode.scala 114:30]
    node _csr_addr_T_1 = bits(id_inst_reg, 31, 20) @[Decode.scala 114:74]
    node csr_addr = mux(_csr_addr_T, UInt<1>("h0"), _csr_addr_T_1) @[Decode.scala 114:21]
    io_regs_reg_raddr1 <= rs1_addr @[Decode.scala 23:22]
    io_regs_reg_raddr2 <= rs2_addr @[Decode.scala 24:22]
    io_passby_id_pc_reg <= id_pc_reg @[Decode.scala 117:23]
    io_passby_imm_i_sext <= imm_i_sext @[Decode.scala 118:24]
    io_passby_imm_s_sext <= imm_s_sext @[Decode.scala 119:24]
    io_passby_imm_b_sext <= imm_b_sext @[Decode.scala 120:24]
    io_passby_imm_u_shifted <= imm_u_shifted @[Decode.scala 121:27]
    io_passby_imm_z_uext <= imm_z_uext @[Decode.scala 122:24]
    io_passby_op1_data <= op1_data @[Decode.scala 123:22]
    io_passby_op2_data <= op2_data @[Decode.scala 124:22]
    io_passby_rs2_data <= rs2_data @[Decode.scala 125:22]
    io_passby_wb_addr <= wb_addr @[Decode.scala 126:21]
    io_passby_exe_fun <= decoded_inst_0 @[Decode.scala 127:21]
    io_passby_mem_wen <= decoded_inst_3 @[Decode.scala 128:21]
    io_passby_reg_wen <= decoded_inst_4 @[Decode.scala 129:21]
    io_passby_wb_sel <= decoded_inst_5 @[Decode.scala 130:20]
    io_passby_csr_cmd <= csr_cmd @[Decode.scala 131:21]
    io_passby_csr_addr <= csr_addr @[Decode.scala 132:22]
    id_inst_reg <= mux(reset, UInt<32>("h0"), io_extend_if_inst) @[Decode.scala 15:{28,28} 17:15]
    id_pc_reg <= mux(reset, UInt<32>("h0"), io_extend_if_inst) @[Decode.scala 16:{26,26} 18:13]

  module Execute :
    input clock : Clock
    input reset : UInt<1>
    input io_extend_id_pc_reg : UInt<32>
    input io_extend_imm_i_sext : UInt<32>
    input io_extend_imm_s_sext : UInt<32>
    input io_extend_imm_b_sext : UInt<32>
    input io_extend_imm_u_shifted : UInt<32>
    input io_extend_imm_z_uext : UInt<32>
    input io_extend_op1_data : UInt<32>
    input io_extend_op2_data : UInt<32>
    input io_extend_rs2_data : UInt<32>
    input io_extend_wb_addr : UInt<5>
    input io_extend_exe_fun : UInt<5>
    input io_extend_mem_wen : UInt<2>
    input io_extend_reg_wen : UInt<2>
    input io_extend_wb_sel : UInt<3>
    input io_extend_csr_cmd : UInt<3>
    input io_extend_csr_addr : UInt<12>
    output io_exifIO_alu_out : UInt<32>
    output io_exifIO_br_flag : UInt<1>
    output io_exifIO_br_target : UInt<32>
    output io_exifIO_jmp_flag : UInt<1>
    output io_passby_exe_pc_reg : UInt<32>
    output io_passby_wb_addr : UInt<5>
    output io_passby_op1_data : UInt<32>
    output io_passby_rs2_data : UInt<32>
    output io_passby_mem_wen : UInt<2>
    output io_passby_reg_wen : UInt<2>
    output io_passby_wb_sel : UInt<3>
    output io_passby_csr_addr : UInt<12>
    output io_passby_csr_cmd : UInt<3>
    output io_passby_imm_z_uext : UInt<32>
    output io_passby_alu_out : UInt<32>

    reg ex_pc_reg : UInt<5>, clock with :
      reset => (UInt<1>("h0"), ex_pc_reg) @[Execute.scala 15:26]
    reg exe_fun_reg : UInt<5>, clock with :
      reset => (UInt<1>("h0"), exe_fun_reg) @[Execute.scala 16:28]
    reg op1_data_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), op1_data_reg) @[Execute.scala 17:29]
    reg op2_data_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), op2_data_reg) @[Execute.scala 18:29]
    reg rs2_data_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), rs2_data_reg) @[Execute.scala 19:29]
    reg wb_addr_reg : UInt<5>, clock with :
      reset => (UInt<1>("h0"), wb_addr_reg) @[Execute.scala 20:28]
    reg mem_wen_reg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), mem_wen_reg) @[Execute.scala 21:28]
    reg reg_wen_reg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), reg_wen_reg) @[Execute.scala 22:28]
    reg wb_sel_reg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), wb_sel_reg) @[Execute.scala 23:27]
    reg csr_addr_reg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), csr_addr_reg) @[Execute.scala 24:29]
    reg csr_cmd_reg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), csr_cmd_reg) @[Execute.scala 25:28]
    reg imm_i_sext_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), imm_i_sext_reg) @[Execute.scala 26:31]
    reg imm_s_sext_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), imm_s_sext_reg) @[Execute.scala 27:31]
    reg imm_b_sext_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), imm_b_sext_reg) @[Execute.scala 28:31]
    reg imm_u_shifted_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), imm_u_shifted_reg) @[Execute.scala 29:34]
    reg imm_z_uext_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), imm_z_uext_reg) @[Execute.scala 30:31]
    node _inv_one_T = mux(UInt<1>("h1"), UInt<31>("h7fffffff"), UInt<31>("h0")) @[Bitwise.scala 74:12]
    node _inv_one_T_1 = dshr(UInt<1>("h0"), UInt<1>("h1")) @[Execute.scala 55:52]
    node _inv_one_T_2 = bits(_inv_one_T_1, 0, 0) @[Execute.scala 55:52]
    node inv_one = cat(_inv_one_T, _inv_one_T_2) @[Cat.scala 31:58]
    node _alu_out_T = eq(exe_fun_reg, UInt<5>("h1")) @[Execute.scala 58:18]
    node _alu_out_T_1 = add(op1_data_reg, op2_data_reg) @[Execute.scala 58:48]
    node _alu_out_T_2 = tail(_alu_out_T_1, 1) @[Execute.scala 58:48]
    node _alu_out_T_3 = eq(exe_fun_reg, UInt<5>("h2")) @[Execute.scala 59:18]
    node _alu_out_T_4 = sub(op1_data_reg, op2_data_reg) @[Execute.scala 59:48]
    node _alu_out_T_5 = tail(_alu_out_T_4, 1) @[Execute.scala 59:48]
    node _alu_out_T_6 = eq(exe_fun_reg, UInt<5>("h3")) @[Execute.scala 60:18]
    node _alu_out_T_7 = and(op1_data_reg, op2_data_reg) @[Execute.scala 60:48]
    node _alu_out_T_8 = eq(exe_fun_reg, UInt<5>("h4")) @[Execute.scala 61:18]
    node _alu_out_T_9 = or(op1_data_reg, op2_data_reg) @[Execute.scala 61:47]
    node _alu_out_T_10 = eq(exe_fun_reg, UInt<5>("h5")) @[Execute.scala 62:18]
    node _alu_out_T_11 = xor(op1_data_reg, op2_data_reg) @[Execute.scala 62:48]
    node _alu_out_T_12 = eq(exe_fun_reg, UInt<5>("h6")) @[Execute.scala 63:18]
    node _alu_out_T_13 = bits(op2_data_reg, 4, 0) @[Execute.scala 63:63]
    node _alu_out_T_14 = dshl(op1_data_reg, _alu_out_T_13) @[Execute.scala 63:48]
    node _alu_out_T_15 = eq(exe_fun_reg, UInt<5>("h7")) @[Execute.scala 64:18]
    node _alu_out_T_16 = bits(op2_data_reg, 4, 0) @[Execute.scala 64:63]
    node _alu_out_T_17 = dshr(op1_data_reg, _alu_out_T_16) @[Execute.scala 64:48]
    node _alu_out_T_18 = eq(exe_fun_reg, UInt<5>("h8")) @[Execute.scala 65:18]
    node _alu_out_T_19 = asSInt(op1_data_reg) @[Execute.scala 65:48]
    node _alu_out_T_20 = bits(op2_data_reg, 4, 0) @[Execute.scala 65:70]
    node _alu_out_T_21 = dshr(_alu_out_T_19, _alu_out_T_20) @[Execute.scala 65:55]
    node _alu_out_T_22 = asUInt(_alu_out_T_21) @[Execute.scala 65:78]
    node _alu_out_T_23 = eq(exe_fun_reg, UInt<5>("h9")) @[Execute.scala 66:18]
    node _alu_out_T_24 = asSInt(op1_data_reg) @[Execute.scala 66:48]
    node _alu_out_T_25 = asSInt(op2_data_reg) @[Execute.scala 66:70]
    node _alu_out_T_26 = lt(_alu_out_T_24, _alu_out_T_25) @[Execute.scala 66:55]
    node _alu_out_T_27 = eq(exe_fun_reg, UInt<5>("ha")) @[Execute.scala 67:18]
    node _alu_out_T_28 = lt(op1_data_reg, op2_data_reg) @[Execute.scala 67:49]
    node _alu_out_T_29 = eq(exe_fun_reg, UInt<5>("hb")) @[Execute.scala 68:18]
    node _alu_out_T_30 = add(op1_data_reg, op2_data_reg) @[Execute.scala 68:50]
    node _alu_out_T_31 = tail(_alu_out_T_30, 1) @[Execute.scala 68:50]
    node _alu_out_T_32 = and(_alu_out_T_31, inv_one) @[Execute.scala 68:66]
    node _alu_out_T_33 = eq(exe_fun_reg, UInt<5>("hc")) @[Execute.scala 69:18]
    node _alu_out_T_34 = mux(_alu_out_T_33, op1_data_reg, UInt<32>("h0")) @[Mux.scala 101:16]
    node _alu_out_T_35 = mux(_alu_out_T_29, _alu_out_T_32, _alu_out_T_34) @[Mux.scala 101:16]
    node _alu_out_T_36 = mux(_alu_out_T_27, _alu_out_T_28, _alu_out_T_35) @[Mux.scala 101:16]
    node _alu_out_T_37 = mux(_alu_out_T_23, _alu_out_T_26, _alu_out_T_36) @[Mux.scala 101:16]
    node _alu_out_T_38 = mux(_alu_out_T_18, _alu_out_T_22, _alu_out_T_37) @[Mux.scala 101:16]
    node _alu_out_T_39 = mux(_alu_out_T_15, _alu_out_T_17, _alu_out_T_38) @[Mux.scala 101:16]
    node _alu_out_T_40 = mux(_alu_out_T_12, _alu_out_T_14, _alu_out_T_39) @[Mux.scala 101:16]
    node _alu_out_T_41 = mux(_alu_out_T_10, _alu_out_T_11, _alu_out_T_40) @[Mux.scala 101:16]
    node _alu_out_T_42 = mux(_alu_out_T_8, _alu_out_T_9, _alu_out_T_41) @[Mux.scala 101:16]
    node _alu_out_T_43 = mux(_alu_out_T_6, _alu_out_T_7, _alu_out_T_42) @[Mux.scala 101:16]
    node _alu_out_T_44 = mux(_alu_out_T_3, _alu_out_T_5, _alu_out_T_43) @[Mux.scala 101:16]
    node _alu_out_T_45 = mux(_alu_out_T, _alu_out_T_2, _alu_out_T_44) @[Mux.scala 101:16]
    node _br_flag_T = eq(exe_fun_reg, UInt<5>("hd")) @[Execute.scala 73:18]
    node _br_flag_T_1 = eq(op1_data_reg, op2_data_reg) @[Execute.scala 73:47]
    node _br_flag_T_2 = eq(exe_fun_reg, UInt<5>("he")) @[Execute.scala 74:18]
    node _br_flag_T_3 = neq(op1_data_reg, op2_data_reg) @[Execute.scala 74:47]
    node _br_flag_T_4 = eq(exe_fun_reg, UInt<5>("hf")) @[Execute.scala 75:18]
    node _br_flag_T_5 = lt(op1_data_reg, op2_data_reg) @[Execute.scala 75:48]
    node _br_flag_T_6 = eq(exe_fun_reg, UInt<5>("h11")) @[Execute.scala 76:18]
    node _br_flag_T_7 = asSInt(op1_data_reg) @[Execute.scala 76:47]
    node _br_flag_T_8 = asSInt(op2_data_reg) @[Execute.scala 76:69]
    node _br_flag_T_9 = lt(_br_flag_T_7, _br_flag_T_8) @[Execute.scala 76:54]
    node _br_flag_T_10 = eq(exe_fun_reg, UInt<5>("h10")) @[Execute.scala 77:18]
    node _br_flag_T_11 = geq(op1_data_reg, op2_data_reg) @[Execute.scala 77:48]
    node _br_flag_T_12 = eq(exe_fun_reg, UInt<5>("h12")) @[Execute.scala 78:18]
    node _br_flag_T_13 = asSInt(op1_data_reg) @[Execute.scala 78:47]
    node _br_flag_T_14 = asSInt(op2_data_reg) @[Execute.scala 78:70]
    node _br_flag_T_15 = geq(_br_flag_T_13, _br_flag_T_14) @[Execute.scala 78:54]
    node _br_flag_T_16 = mux(_br_flag_T_12, _br_flag_T_15, UInt<1>("h0")) @[Mux.scala 101:16]
    node _br_flag_T_17 = mux(_br_flag_T_10, _br_flag_T_11, _br_flag_T_16) @[Mux.scala 101:16]
    node _br_flag_T_18 = mux(_br_flag_T_6, _br_flag_T_9, _br_flag_T_17) @[Mux.scala 101:16]
    node _br_flag_T_19 = mux(_br_flag_T_4, _br_flag_T_5, _br_flag_T_18) @[Mux.scala 101:16]
    node _br_flag_T_20 = mux(_br_flag_T_2, _br_flag_T_3, _br_flag_T_19) @[Mux.scala 101:16]
    node _br_flag_T_21 = mux(_br_flag_T, _br_flag_T_1, _br_flag_T_20) @[Mux.scala 101:16]
    node _br_target_T = add(ex_pc_reg, imm_b_sext_reg) @[Execute.scala 80:26]
    node _br_target_T_1 = tail(_br_target_T, 1) @[Execute.scala 80:26]
    node _jmp_flag_T = eq(wb_sel_reg, UInt<3>("h3")) @[Execute.scala 82:27]
    node alu_out = bits(_alu_out_T_45, 31, 0) @[Execute.scala 50:21 57:11]
    node br_flag = _br_flag_T_21 @[Execute.scala 51:21 72:11]
    node br_target = _br_target_T_1 @[Execute.scala 52:23 80:13]
    node jmp_flag = pad(_jmp_flag_T, 32) @[Execute.scala 53:22 82:12]
    io_exifIO_alu_out <= alu_out @[Execute.scala 85:21]
    io_exifIO_br_flag <= br_flag @[Execute.scala 86:21]
    io_exifIO_br_target <= br_target @[Execute.scala 87:23]
    io_exifIO_jmp_flag <= bits(jmp_flag, 0, 0) @[Execute.scala 88:22]
    io_passby_exe_pc_reg <= pad(ex_pc_reg, 32) @[Execute.scala 91:24]
    io_passby_wb_addr <= wb_addr_reg @[Execute.scala 92:21]
    io_passby_op1_data <= op1_data_reg @[Execute.scala 93:22]
    io_passby_rs2_data <= rs2_data_reg @[Execute.scala 94:22]
    io_passby_mem_wen <= mem_wen_reg @[Execute.scala 95:21]
    io_passby_reg_wen <= reg_wen_reg @[Execute.scala 96:21]
    io_passby_wb_sel <= wb_sel_reg @[Execute.scala 97:20]
    io_passby_csr_addr <= pad(csr_addr_reg, 12) @[Execute.scala 98:22]
    io_passby_csr_cmd <= csr_cmd_reg @[Execute.scala 99:21]
    io_passby_imm_z_uext <= imm_z_uext_reg @[Execute.scala 100:24]
    io_passby_alu_out <= alu_out @[Execute.scala 101:21]
    ex_pc_reg <= bits(mux(reset, UInt<5>("h0"), io_extend_id_pc_reg), 4, 0) @[Execute.scala 15:{26,26} 33:13]
    exe_fun_reg <= mux(reset, UInt<5>("h0"), io_extend_exe_fun) @[Execute.scala 16:{28,28} 34:15]
    op1_data_reg <= mux(reset, UInt<32>("h0"), io_extend_op1_data) @[Execute.scala 17:{29,29} 35:16]
    op2_data_reg <= mux(reset, UInt<32>("h0"), io_extend_op2_data) @[Execute.scala 18:{29,29} 36:16]
    rs2_data_reg <= mux(reset, UInt<32>("h0"), io_extend_rs2_data) @[Execute.scala 19:{29,29} 37:16]
    wb_addr_reg <= mux(reset, UInt<5>("h0"), io_extend_wb_addr) @[Execute.scala 20:{28,28} 38:15]
    mem_wen_reg <= mux(reset, UInt<2>("h0"), io_extend_mem_wen) @[Execute.scala 21:{28,28} 40:15]
    reg_wen_reg <= mux(reset, UInt<2>("h0"), io_extend_reg_wen) @[Execute.scala 22:{28,28} 41:15]
    wb_sel_reg <= mux(reset, UInt<3>("h0"), io_extend_wb_sel) @[Execute.scala 23:{27,27} 39:14]
    csr_addr_reg <= bits(mux(reset, UInt<1>("h0"), io_extend_csr_addr), 0, 0) @[Execute.scala 24:{29,29} 42:16]
    csr_cmd_reg <= mux(reset, UInt<3>("h0"), io_extend_csr_cmd) @[Execute.scala 25:{28,28} 43:15]
    imm_i_sext_reg <= mux(reset, UInt<32>("h0"), io_extend_imm_i_sext) @[Execute.scala 26:{31,31} 44:18]
    imm_s_sext_reg <= mux(reset, UInt<32>("h0"), io_extend_imm_s_sext) @[Execute.scala 27:{31,31} 45:18]
    imm_b_sext_reg <= mux(reset, UInt<32>("h0"), io_extend_imm_b_sext) @[Execute.scala 28:{31,31} 46:18]
    imm_u_shifted_reg <= mux(reset, UInt<32>("h0"), io_extend_imm_u_shifted) @[Execute.scala 29:{34,34} 47:21]
    imm_z_uext_reg <= mux(reset, UInt<32>("h0"), io_extend_imm_z_uext) @[Execute.scala 30:{31,31} 48:18]

  module MemAccess :
    input clock : Clock
    input reset : UInt<1>
    input io_extend_exe_pc_reg : UInt<32>
    input io_extend_wb_addr : UInt<5>
    input io_extend_op1_data : UInt<32>
    input io_extend_rs2_data : UInt<32>
    input io_extend_mem_wen : UInt<2>
    input io_extend_reg_wen : UInt<2>
    input io_extend_wb_sel : UInt<3>
    input io_extend_csr_addr : UInt<12>
    input io_extend_csr_cmd : UInt<3>
    input io_extend_imm_z_uext : UInt<32>
    input io_extend_alu_out : UInt<32>
    output io_csr_read_reg_raddr : UInt<12>
    input io_csr_read_reg_rdata : UInt<32>
    output io_csr_write_reg_waddr : UInt<12>
    output io_csr_write_reg_wdata : UInt<32>
    output io_csr_write_wen : UInt<1>
    output io_mem_write_waddr : UInt<32>
    output io_mem_write_wdata : UInt<32>
    output io_mem_write_write_en : UInt<1>
    output io_mem_read_raddr : UInt<32>
    input io_mem_read_rdata : UInt<32>
    output io_passby_reg_wb_addr : UInt<5>
    output io_passby_reg_wen : UInt<2>
    output io_passby_reg_wb_data : UInt<32>

    reg mem_pc_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), mem_pc_reg) @[MemAccess.scala 17:27]
    reg wb_addr_reg : UInt<5>, clock with :
      reset => (UInt<1>("h0"), wb_addr_reg) @[MemAccess.scala 18:28]
    reg op1_data_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), op1_data_reg) @[MemAccess.scala 19:29]
    reg rs2_data_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), rs2_data_reg) @[MemAccess.scala 20:29]
    reg mem_wen_reg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), mem_wen_reg) @[MemAccess.scala 21:28]
    reg reg_wen_reg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), reg_wen_reg) @[MemAccess.scala 22:28]
    reg wb_sel_reg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), wb_sel_reg) @[MemAccess.scala 23:27]
    reg csr_addr_reg : UInt<12>, clock with :
      reset => (UInt<1>("h0"), csr_addr_reg) @[MemAccess.scala 24:29]
    reg csr_cmd_reg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), csr_cmd_reg) @[MemAccess.scala 25:28]
    reg imm_z_uext_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), imm_z_uext_reg) @[MemAccess.scala 26:31]
    reg alu_out_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), alu_out_reg) @[MemAccess.scala 27:28]
    node _io_csr_write_reg_wdata_T = eq(csr_cmd_reg, UInt<3>("h1")) @[MemAccess.scala 55:18]
    node _io_csr_write_reg_wdata_T_1 = eq(csr_cmd_reg, UInt<3>("h2")) @[MemAccess.scala 56:18]
    node _io_csr_write_reg_wdata_T_2 = or(op1_data_reg, io_csr_read_reg_rdata) @[MemAccess.scala 56:46]
    node _io_csr_write_reg_wdata_T_3 = eq(csr_cmd_reg, UInt<3>("h3")) @[MemAccess.scala 57:18]
    node _io_csr_write_reg_wdata_T_4 = not(op1_data_reg) @[MemAccess.scala 57:34]
    node _io_csr_write_reg_wdata_T_5 = and(_io_csr_write_reg_wdata_T_4, io_csr_read_reg_rdata) @[MemAccess.scala 57:56]
    node _io_csr_write_reg_wdata_T_6 = eq(csr_cmd_reg, UInt<3>("h4")) @[MemAccess.scala 58:18]
    node _io_csr_write_reg_wdata_T_7 = mux(_io_csr_write_reg_wdata_T_6, UInt<32>("hb"), UInt<32>("h0")) @[Mux.scala 101:16]
    node _io_csr_write_reg_wdata_T_8 = mux(_io_csr_write_reg_wdata_T_3, _io_csr_write_reg_wdata_T_5, _io_csr_write_reg_wdata_T_7) @[Mux.scala 101:16]
    node _io_csr_write_reg_wdata_T_9 = mux(_io_csr_write_reg_wdata_T_1, _io_csr_write_reg_wdata_T_2, _io_csr_write_reg_wdata_T_8) @[Mux.scala 101:16]
    node _io_csr_write_reg_wdata_T_10 = mux(_io_csr_write_reg_wdata_T, op1_data_reg, _io_csr_write_reg_wdata_T_9) @[Mux.scala 101:16]
    node _T = gt(csr_cmd_reg, UInt<3>("h0")) @[MemAccess.scala 60:20]
    node _GEN_0 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[MemAccess.scala 60:36 61:22 63:22]
    node _mem_wb_data_T = eq(wb_sel_reg, UInt<3>("h2")) @[MemAccess.scala 67:17]
    node _mem_wb_data_T_1 = eq(wb_sel_reg, UInt<3>("h3")) @[MemAccess.scala 68:17]
    node _mem_wb_data_T_2 = add(mem_pc_reg, UInt<32>("h4")) @[MemAccess.scala 68:43]
    node _mem_wb_data_T_3 = tail(_mem_wb_data_T_2, 1) @[MemAccess.scala 68:43]
    node _mem_wb_data_T_4 = eq(wb_sel_reg, UInt<3>("h4")) @[MemAccess.scala 69:17]
    node _mem_wb_data_T_5 = mux(_mem_wb_data_T_4, io_csr_read_reg_rdata, alu_out_reg) @[Mux.scala 101:16]
    node _mem_wb_data_T_6 = mux(_mem_wb_data_T_1, _mem_wb_data_T_3, _mem_wb_data_T_5) @[Mux.scala 101:16]
    node mem_wb_data = mux(_mem_wb_data_T, io_mem_read_rdata, _mem_wb_data_T_6) @[Mux.scala 101:16]
    io_csr_read_reg_raddr <= csr_addr_reg @[MemAccess.scala 50:25]
    io_csr_write_reg_waddr <= csr_addr_reg @[MemAccess.scala 52:26]
    io_csr_write_reg_wdata <= _io_csr_write_reg_wdata_T_10 @[MemAccess.scala 54:26]
    io_csr_write_wen <= _GEN_0
    io_mem_write_waddr <= alu_out_reg @[MemAccess.scala 43:22]
    io_mem_write_wdata <= rs2_data_reg @[MemAccess.scala 45:22]
    io_mem_write_write_en <= bits(mem_wen_reg, 0, 0) @[MemAccess.scala 44:25]
    io_mem_read_raddr <= alu_out_reg @[MemAccess.scala 46:21]
    io_passby_reg_wb_addr <= wb_addr_reg @[MemAccess.scala 73:25]
    io_passby_reg_wen <= reg_wen_reg @[MemAccess.scala 74:21]
    io_passby_reg_wb_data <= mem_wb_data @[MemAccess.scala 75:25]
    mem_pc_reg <= mux(reset, UInt<32>("h0"), io_extend_exe_pc_reg) @[MemAccess.scala 17:{27,27} 29:14]
    wb_addr_reg <= mux(reset, UInt<5>("h0"), io_extend_wb_addr) @[MemAccess.scala 18:{28,28} 30:15]
    op1_data_reg <= mux(reset, UInt<32>("h0"), io_extend_op1_data) @[MemAccess.scala 19:{29,29} 31:16]
    rs2_data_reg <= mux(reset, UInt<32>("h0"), io_extend_rs2_data) @[MemAccess.scala 20:{29,29} 32:16]
    mem_wen_reg <= mux(reset, UInt<2>("h0"), io_extend_mem_wen) @[MemAccess.scala 21:{28,28} 33:15]
    reg_wen_reg <= mux(reset, UInt<2>("h0"), io_extend_reg_wen) @[MemAccess.scala 22:{28,28} 35:15]
    wb_sel_reg <= mux(reset, UInt<3>("h0"), io_extend_wb_sel) @[MemAccess.scala 23:{27,27} 36:14]
    csr_addr_reg <= mux(reset, UInt<12>("h0"), io_extend_csr_addr) @[MemAccess.scala 24:{29,29} 37:16]
    csr_cmd_reg <= mux(reset, UInt<3>("h0"), io_extend_csr_cmd) @[MemAccess.scala 25:{28,28} 38:15]
    imm_z_uext_reg <= mux(reset, UInt<32>("h0"), io_extend_imm_z_uext) @[MemAccess.scala 26:{31,31} 39:18]
    alu_out_reg <= mux(reset, UInt<32>("h0"), io_extend_alu_out) @[MemAccess.scala 27:{28,28} 40:15]

  module WriteBack :
    input clock : Clock
    input reset : UInt<1>
    input io_extend_reg_wb_addr : UInt<5>
    input io_extend_reg_wen : UInt<2>
    input io_extend_reg_wb_data : UInt<32>
    output io_regIO_reg_waddr : UInt<32>
    output io_regIO_reg_wdata : UInt<32>
    output io_regIO_wen : UInt<1>
    output io_gp : UInt<32>

    reg reg_wen_reg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), reg_wen_reg) @[WriteBack.scala 13:28]
    reg wb_addr_reg : UInt<5>, clock with :
      reset => (UInt<1>("h0"), wb_addr_reg) @[WriteBack.scala 14:28]
    reg wb_data_reg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), wb_data_reg) @[WriteBack.scala 15:28]
    node _T = eq(reg_wen_reg, UInt<2>("h1")) @[WriteBack.scala 24:20]
    node _GEN_0 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[WriteBack.scala 24:31 25:18 27:18]
    io_regIO_reg_waddr <= pad(wb_addr_reg, 32) @[WriteBack.scala 22:22]
    io_regIO_reg_wdata <= wb_data_reg @[WriteBack.scala 23:22]
    io_regIO_wen <= _GEN_0
    io_gp <= wb_data_reg @[WriteBack.scala 30:9]
    reg_wen_reg <= mux(reset, UInt<2>("h0"), io_extend_reg_wen) @[WriteBack.scala 13:{28,28} 18:15]
    wb_addr_reg <= mux(reset, UInt<5>("h0"), io_extend_reg_wb_addr) @[WriteBack.scala 14:{28,28} 19:15]
    wb_data_reg <= mux(reset, UInt<32>("h0"), io_extend_reg_wb_data) @[WriteBack.scala 15:{28,28} 20:15]

  module Regs :
    input clock : Clock
    input reset : UInt<1>
    input io_regReadIO_reg_raddr1 : UInt<5>
    input io_regReadIO_reg_raddr2 : UInt<5>
    output io_regReadIO_reg_rdata1 : UInt<32>
    output io_regReadIO_reg_rdata2 : UInt<32>
    input io_regWriteIO_reg_waddr : UInt<5>
    input io_regWriteIO_reg_wdata : UInt<32>
    input io_regWriteIO_wen : UInt<1>

    mem registers : @[Regs.scala 12:22]
      data-type => UInt<32>
      depth => 32
      read-latency => 0
      write-latency => 1
      reader => io_regReadIO_reg_rdata1_MPORT
      reader => io_regReadIO_reg_rdata2_MPORT
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_regWriteIO_wen, io_regWriteIO_reg_waddr) @[Regs.scala 17:26 18:14]
    node _GEN_1 = validif(io_regWriteIO_wen, clock) @[Regs.scala 17:26 18:14]
    node _GEN_2 = mux(io_regWriteIO_wen, UInt<1>("h1"), UInt<1>("h0")) @[Regs.scala 17:26 18:14 12:22]
    node _GEN_3 = validif(io_regWriteIO_wen, UInt<1>("h1")) @[Regs.scala 17:26 18:40]
    node _GEN_4 = validif(io_regWriteIO_wen, io_regWriteIO_reg_wdata) @[Regs.scala 17:26 18:40]
    io_regReadIO_reg_rdata1 <= registers.io_regReadIO_reg_rdata1_MPORT.data @[Regs.scala 14:27]
    io_regReadIO_reg_rdata2 <= registers.io_regReadIO_reg_rdata2_MPORT.data @[Regs.scala 15:27]
    registers.io_regReadIO_reg_rdata1_MPORT.addr <= io_regReadIO_reg_raddr1 @[Regs.scala 14:39]
    registers.io_regReadIO_reg_rdata1_MPORT.en <= UInt<1>("h1") @[Regs.scala 14:39]
    registers.io_regReadIO_reg_rdata1_MPORT.clk <= clock @[Regs.scala 14:39]
    registers.io_regReadIO_reg_rdata2_MPORT.addr <= io_regReadIO_reg_raddr2 @[Regs.scala 15:39]
    registers.io_regReadIO_reg_rdata2_MPORT.en <= UInt<1>("h1") @[Regs.scala 15:39]
    registers.io_regReadIO_reg_rdata2_MPORT.clk <= clock @[Regs.scala 15:39]
    registers.MPORT.addr <= _GEN_0
    registers.MPORT.en <= _GEN_2
    registers.MPORT.clk <= _GEN_1
    registers.MPORT.data <= _GEN_4
    registers.MPORT.mask <= _GEN_3

  module CSR :
    input clock : Clock
    input reset : UInt<1>
    input io_read1IO_reg_raddr : UInt<12>
    output io_read1IO_reg_rdata : UInt<32>
    input io_read2IO_reg_raddr : UInt<12>
    output io_read2IO_reg_rdata : UInt<32>
    input io_writeIO_reg_waddr : UInt<12>
    input io_writeIO_reg_wdata : UInt<32>
    input io_writeIO_wen : UInt<1>

    mem csr_register : @[CSR.scala 12:25]
      data-type => UInt<32>
      depth => 4096
      read-latency => 0
      write-latency => 1
      reader => io_read1IO_reg_rdata_MPORT
      reader => io_read2IO_reg_rdata_MPORT
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_writeIO_wen, io_writeIO_reg_waddr) @[CSR.scala 17:24 18:17]
    node _GEN_1 = validif(io_writeIO_wen, clock) @[CSR.scala 17:24 18:17]
    node _GEN_2 = mux(io_writeIO_wen, UInt<1>("h1"), UInt<1>("h0")) @[CSR.scala 17:24 18:17 12:25]
    node _GEN_3 = validif(io_writeIO_wen, UInt<1>("h1")) @[CSR.scala 17:24 18:40]
    node _GEN_4 = validif(io_writeIO_wen, io_writeIO_reg_wdata) @[CSR.scala 17:24 18:40]
    io_read1IO_reg_rdata <= csr_register.io_read1IO_reg_rdata_MPORT.data @[CSR.scala 14:24]
    io_read2IO_reg_rdata <= csr_register.io_read2IO_reg_rdata_MPORT.data @[CSR.scala 15:24]
    csr_register.io_read1IO_reg_rdata_MPORT.addr <= io_read1IO_reg_raddr @[CSR.scala 14:39]
    csr_register.io_read1IO_reg_rdata_MPORT.en <= UInt<1>("h1") @[CSR.scala 14:39]
    csr_register.io_read1IO_reg_rdata_MPORT.clk <= clock @[CSR.scala 14:39]
    csr_register.io_read2IO_reg_rdata_MPORT.addr <= io_read2IO_reg_raddr @[CSR.scala 15:39]
    csr_register.io_read2IO_reg_rdata_MPORT.en <= UInt<1>("h1") @[CSR.scala 15:39]
    csr_register.io_read2IO_reg_rdata_MPORT.clk <= clock @[CSR.scala 15:39]
    csr_register.MPORT.addr <= _GEN_0
    csr_register.MPORT.en <= _GEN_2
    csr_register.MPORT.clk <= _GEN_1
    csr_register.MPORT.data <= _GEN_4
    csr_register.MPORT.mask <= _GEN_3

  module Memory :
    input clock : Clock
    input reset : UInt<1>
    input io_imem_inst_addr : UInt<32>
    output io_imem_inst_o : UInt<32>
    input io_aread_raddr : UInt<32>
    output io_aread_rdata : UInt<32>
    input io_awrite_waddr : UInt<32>
    input io_awrite_wdata : UInt<32>
    input io_awrite_write_en : UInt<1>

    mem mem : @[Memory.scala 13:16]
      data-type => UInt<8>
      depth => 16384
      read-latency => 0
      write-latency => 1
      reader => io_imem_inst_o_MPORT
      reader => io_imem_inst_o_MPORT_1
      reader => io_imem_inst_o_MPORT_2
      reader => io_imem_inst_o_MPORT_3
      reader => io_aread_rdata_MPORT
      reader => io_aread_rdata_MPORT_1
      reader => io_aread_rdata_MPORT_2
      reader => io_aread_rdata_MPORT_3
      writer => MPORT
      writer => MPORT_1
      writer => MPORT_2
      writer => MPORT_3
      read-under-write => undefined
    node _T = asUInt(reset) @[Memory.scala 15:14]
    node _io_imem_inst_o_T = add(io_imem_inst_addr, UInt<8>("h3")) @[Memory.scala 18:49]
    node _io_imem_inst_o_T_1 = tail(_io_imem_inst_o_T, 1) @[Memory.scala 18:49]
    node _io_imem_inst_o_T_2 = bits(_io_imem_inst_o_T_1, 13, 0) @[Memory.scala 18:30]
    node _io_imem_inst_o_T_3 = add(io_imem_inst_addr, UInt<8>("h2")) @[Memory.scala 19:29]
    node _io_imem_inst_o_T_4 = tail(_io_imem_inst_o_T_3, 1) @[Memory.scala 19:29]
    node _io_imem_inst_o_T_5 = bits(_io_imem_inst_o_T_4, 13, 0) @[Memory.scala 19:10]
    node _io_imem_inst_o_T_6 = add(io_imem_inst_addr, UInt<8>("h1")) @[Memory.scala 20:29]
    node _io_imem_inst_o_T_7 = tail(_io_imem_inst_o_T_6, 1) @[Memory.scala 20:29]
    node _io_imem_inst_o_T_8 = bits(_io_imem_inst_o_T_7, 13, 0) @[Memory.scala 20:10]
    node _io_imem_inst_o_T_9 = bits(io_imem_inst_addr, 13, 0) @[Memory.scala 21:10]
    node io_imem_inst_o_lo = cat(mem.io_imem_inst_o_MPORT_2.data, mem.io_imem_inst_o_MPORT_3.data) @[Cat.scala 31:58]
    node io_imem_inst_o_hi = cat(mem.io_imem_inst_o_MPORT.data, mem.io_imem_inst_o_MPORT_1.data) @[Cat.scala 31:58]
    node _io_imem_inst_o_T_10 = cat(io_imem_inst_o_hi, io_imem_inst_o_lo) @[Cat.scala 31:58]
    node _GEN_0 = mux(_T, UInt<32>("h0"), _io_imem_inst_o_T_10) @[Memory.scala 15:21 16:20 18:20]
    node _GEN_1 = validif(eq(_T, UInt<1>("h0")), _io_imem_inst_o_T_2) @[Memory.scala 15:21 18:30]
    node _GEN_2 = validif(eq(_T, UInt<1>("h0")), clock) @[Memory.scala 15:21 18:30]
    node _GEN_3 = mux(_T, UInt<1>("h0"), UInt<1>("h1")) @[Memory.scala 13:16 15:21 18:30]
    node _GEN_4 = validif(eq(_T, UInt<1>("h0")), _io_imem_inst_o_T_5) @[Memory.scala 15:21 19:10]
    node _GEN_5 = validif(eq(_T, UInt<1>("h0")), _io_imem_inst_o_T_8) @[Memory.scala 15:21 20:10]
    node _GEN_6 = validif(eq(_T, UInt<1>("h0")), _io_imem_inst_o_T_9) @[Memory.scala 15:21 21:10]
    node _io_aread_rdata_T = add(io_aread_raddr, UInt<8>("h3")) @[Memory.scala 24:44]
    node _io_aread_rdata_T_1 = tail(_io_aread_rdata_T, 1) @[Memory.scala 24:44]
    node _io_aread_rdata_T_2 = bits(_io_aread_rdata_T_1, 13, 0) @[Memory.scala 24:28]
    node _io_aread_rdata_T_3 = add(io_aread_raddr, UInt<8>("h2")) @[Memory.scala 25:24]
    node _io_aread_rdata_T_4 = tail(_io_aread_rdata_T_3, 1) @[Memory.scala 25:24]
    node _io_aread_rdata_T_5 = bits(_io_aread_rdata_T_4, 13, 0) @[Memory.scala 25:8]
    node _io_aread_rdata_T_6 = add(io_aread_raddr, UInt<8>("h1")) @[Memory.scala 26:24]
    node _io_aread_rdata_T_7 = tail(_io_aread_rdata_T_6, 1) @[Memory.scala 26:24]
    node _io_aread_rdata_T_8 = bits(_io_aread_rdata_T_7, 13, 0) @[Memory.scala 26:8]
    node _io_aread_rdata_T_9 = bits(io_aread_raddr, 13, 0) @[Memory.scala 27:8]
    node io_aread_rdata_lo = cat(mem.io_aread_rdata_MPORT_2.data, mem.io_aread_rdata_MPORT_3.data) @[Cat.scala 31:58]
    node io_aread_rdata_hi = cat(mem.io_aread_rdata_MPORT.data, mem.io_aread_rdata_MPORT_1.data) @[Cat.scala 31:58]
    node _io_aread_rdata_T_10 = cat(io_aread_rdata_hi, io_aread_rdata_lo) @[Cat.scala 31:58]
    node _T_1 = add(io_awrite_waddr, UInt<8>("h3")) @[Memory.scala 30:25]
    node _T_2 = tail(_T_1, 1) @[Memory.scala 30:25]
    node _T_3 = bits(_T_2, 13, 0) @[Memory.scala 30:8]
    node _T_4 = bits(io_awrite_wdata, 31, 24) @[Memory.scala 30:55]
    node _T_5 = add(io_awrite_waddr, UInt<8>("h2")) @[Memory.scala 31:25]
    node _T_6 = tail(_T_5, 1) @[Memory.scala 31:25]
    node _T_7 = bits(_T_6, 13, 0) @[Memory.scala 31:8]
    node _T_8 = bits(io_awrite_wdata, 23, 16) @[Memory.scala 31:55]
    node _T_9 = add(io_awrite_waddr, UInt<8>("h1")) @[Memory.scala 32:25]
    node _T_10 = tail(_T_9, 1) @[Memory.scala 32:25]
    node _T_11 = bits(_T_10, 13, 0) @[Memory.scala 32:8]
    node _T_12 = bits(io_awrite_wdata, 15, 8) @[Memory.scala 32:55]
    node _T_13 = bits(io_awrite_waddr, 13, 0) @[Memory.scala 33:8]
    node _T_14 = bits(io_awrite_wdata, 7, 0) @[Memory.scala 33:44]
    node _GEN_7 = validif(io_awrite_write_en, _T_3) @[Memory.scala 29:27 30:8]
    node _GEN_8 = validif(io_awrite_write_en, clock) @[Memory.scala 29:27 30:8]
    node _GEN_9 = mux(io_awrite_write_en, UInt<1>("h1"), UInt<1>("h0")) @[Memory.scala 13:16 29:27 30:8]
    node _GEN_10 = validif(io_awrite_write_en, UInt<1>("h1")) @[Memory.scala 29:27 30:37]
    node _GEN_11 = validif(io_awrite_write_en, _T_4) @[Memory.scala 29:27 30:37]
    node _GEN_12 = validif(io_awrite_write_en, _T_7) @[Memory.scala 29:27 31:8]
    node _GEN_13 = validif(io_awrite_write_en, _T_8) @[Memory.scala 29:27 31:37]
    node _GEN_14 = validif(io_awrite_write_en, _T_11) @[Memory.scala 29:27 32:8]
    node _GEN_15 = validif(io_awrite_write_en, _T_12) @[Memory.scala 29:27 32:37]
    node _GEN_16 = validif(io_awrite_write_en, _T_13) @[Memory.scala 29:27 33:8]
    node _GEN_17 = validif(io_awrite_write_en, _T_14) @[Memory.scala 29:27 33:26]
    io_imem_inst_o <= _GEN_0
    io_aread_rdata <= _io_aread_rdata_T_10 @[Memory.scala 24:18]
    mem.io_imem_inst_o_MPORT.addr <= _GEN_1
    mem.io_imem_inst_o_MPORT.en <= _GEN_3
    mem.io_imem_inst_o_MPORT.clk <= _GEN_2
    mem.io_imem_inst_o_MPORT_1.addr <= _GEN_4
    mem.io_imem_inst_o_MPORT_1.en <= _GEN_3
    mem.io_imem_inst_o_MPORT_1.clk <= _GEN_2
    mem.io_imem_inst_o_MPORT_2.addr <= _GEN_5
    mem.io_imem_inst_o_MPORT_2.en <= _GEN_3
    mem.io_imem_inst_o_MPORT_2.clk <= _GEN_2
    mem.io_imem_inst_o_MPORT_3.addr <= _GEN_6
    mem.io_imem_inst_o_MPORT_3.en <= _GEN_3
    mem.io_imem_inst_o_MPORT_3.clk <= _GEN_2
    mem.io_aread_rdata_MPORT.addr <= _io_aread_rdata_T_2 @[Memory.scala 24:28]
    mem.io_aread_rdata_MPORT.en <= UInt<1>("h1") @[Memory.scala 24:28]
    mem.io_aread_rdata_MPORT.clk <= clock @[Memory.scala 24:28]
    mem.io_aread_rdata_MPORT_1.addr <= _io_aread_rdata_T_5 @[Memory.scala 25:8]
    mem.io_aread_rdata_MPORT_1.en <= UInt<1>("h1") @[Memory.scala 25:8]
    mem.io_aread_rdata_MPORT_1.clk <= clock @[Memory.scala 25:8]
    mem.io_aread_rdata_MPORT_2.addr <= _io_aread_rdata_T_8 @[Memory.scala 26:8]
    mem.io_aread_rdata_MPORT_2.en <= UInt<1>("h1") @[Memory.scala 26:8]
    mem.io_aread_rdata_MPORT_2.clk <= clock @[Memory.scala 26:8]
    mem.io_aread_rdata_MPORT_3.addr <= _io_aread_rdata_T_9 @[Memory.scala 27:8]
    mem.io_aread_rdata_MPORT_3.en <= UInt<1>("h1") @[Memory.scala 27:8]
    mem.io_aread_rdata_MPORT_3.clk <= clock @[Memory.scala 27:8]
    mem.MPORT.addr <= _GEN_7
    mem.MPORT.en <= _GEN_9
    mem.MPORT.clk <= _GEN_8
    mem.MPORT.data <= _GEN_11
    mem.MPORT.mask <= _GEN_10
    mem.MPORT_1.addr <= _GEN_12
    mem.MPORT_1.en <= _GEN_9
    mem.MPORT_1.clk <= _GEN_8
    mem.MPORT_1.data <= _GEN_13
    mem.MPORT_1.mask <= _GEN_10
    mem.MPORT_2.addr <= _GEN_14
    mem.MPORT_2.en <= _GEN_9
    mem.MPORT_2.clk <= _GEN_8
    mem.MPORT_2.data <= _GEN_15
    mem.MPORT_2.mask <= _GEN_10
    mem.MPORT_3.addr <= _GEN_16
    mem.MPORT_3.en <= _GEN_9
    mem.MPORT_3.clk <= _GEN_8
    mem.MPORT_3.data <= _GEN_17
    mem.MPORT_3.mask <= _GEN_10

  module Top :
    input clock : Clock
    input reset : UInt<1>
    output io_gp : UInt<32>

    inst module_inst_fetch of InstFetch @[Top.scala 11:33]
    inst module_decode of Decode @[Top.scala 12:29]
    inst module_execute of Execute @[Top.scala 13:30]
    inst module_memory_access of MemAccess @[Top.scala 14:36]
    inst module_write_back of WriteBack @[Top.scala 15:33]
    inst module_reg of Regs @[Top.scala 17:26]
    inst module_csr of CSR @[Top.scala 18:26]
    inst module_memory of Memory @[Top.scala 19:29]
    io_gp <= module_write_back.io_gp @[Top.scala 46:9]
    module_inst_fetch.clock <= clock
    module_inst_fetch.reset <= reset
    module_inst_fetch.io_inst_mem_inst_o <= module_memory.io_imem_inst_o @[Top.scala 22:33]
    module_inst_fetch.io_csr_read_reg_rdata <= module_csr.io_read1IO_reg_rdata @[Top.scala 26:33]
    module_inst_fetch.io_exio_alu_out <= module_execute.io_exifIO_alu_out @[Top.scala 24:29]
    module_inst_fetch.io_exio_br_flag <= module_execute.io_exifIO_br_flag @[Top.scala 24:29]
    module_inst_fetch.io_exio_br_target <= module_execute.io_exifIO_br_target @[Top.scala 24:29]
    module_inst_fetch.io_exio_jmp_flag <= module_execute.io_exifIO_jmp_flag @[Top.scala 24:29]
    module_decode.clock <= clock
    module_decode.reset <= reset
    module_decode.io_extend_if_pc_reg <= module_inst_fetch.io_passby_if_pc_reg @[Top.scala 28:31]
    module_decode.io_extend_if_inst <= module_inst_fetch.io_passby_if_inst @[Top.scala 28:31]
    module_decode.io_regs_reg_rdata1 <= module_reg.io_regReadIO_reg_rdata1 @[Top.scala 30:25]
    module_decode.io_regs_reg_rdata2 <= module_reg.io_regReadIO_reg_rdata2 @[Top.scala 30:25]
    module_execute.clock <= clock
    module_execute.reset <= reset
    module_execute.io_extend_id_pc_reg <= module_decode.io_passby_id_pc_reg @[Top.scala 32:27]
    module_execute.io_extend_imm_i_sext <= module_decode.io_passby_imm_i_sext @[Top.scala 32:27]
    module_execute.io_extend_imm_s_sext <= module_decode.io_passby_imm_s_sext @[Top.scala 32:27]
    module_execute.io_extend_imm_b_sext <= module_decode.io_passby_imm_b_sext @[Top.scala 32:27]
    module_execute.io_extend_imm_u_shifted <= module_decode.io_passby_imm_u_shifted @[Top.scala 32:27]
    module_execute.io_extend_imm_z_uext <= module_decode.io_passby_imm_z_uext @[Top.scala 32:27]
    module_execute.io_extend_op1_data <= module_decode.io_passby_op1_data @[Top.scala 32:27]
    module_execute.io_extend_op2_data <= module_decode.io_passby_op2_data @[Top.scala 32:27]
    module_execute.io_extend_rs2_data <= module_decode.io_passby_rs2_data @[Top.scala 32:27]
    module_execute.io_extend_wb_addr <= module_decode.io_passby_wb_addr @[Top.scala 32:27]
    module_execute.io_extend_exe_fun <= module_decode.io_passby_exe_fun @[Top.scala 32:27]
    module_execute.io_extend_mem_wen <= module_decode.io_passby_mem_wen @[Top.scala 32:27]
    module_execute.io_extend_reg_wen <= module_decode.io_passby_reg_wen @[Top.scala 32:27]
    module_execute.io_extend_wb_sel <= module_decode.io_passby_wb_sel @[Top.scala 32:27]
    module_execute.io_extend_csr_cmd <= module_decode.io_passby_csr_cmd @[Top.scala 32:27]
    module_execute.io_extend_csr_addr <= module_decode.io_passby_csr_addr @[Top.scala 32:27]
    module_memory_access.clock <= clock
    module_memory_access.reset <= reset
    module_memory_access.io_extend_exe_pc_reg <= module_execute.io_passby_exe_pc_reg @[Top.scala 34:28]
    module_memory_access.io_extend_wb_addr <= module_execute.io_passby_wb_addr @[Top.scala 34:28]
    module_memory_access.io_extend_op1_data <= module_execute.io_passby_op1_data @[Top.scala 34:28]
    module_memory_access.io_extend_rs2_data <= module_execute.io_passby_rs2_data @[Top.scala 34:28]
    module_memory_access.io_extend_mem_wen <= module_execute.io_passby_mem_wen @[Top.scala 34:28]
    module_memory_access.io_extend_reg_wen <= module_execute.io_passby_reg_wen @[Top.scala 34:28]
    module_memory_access.io_extend_wb_sel <= module_execute.io_passby_wb_sel @[Top.scala 34:28]
    module_memory_access.io_extend_csr_addr <= module_execute.io_passby_csr_addr @[Top.scala 34:28]
    module_memory_access.io_extend_csr_cmd <= module_execute.io_passby_csr_cmd @[Top.scala 34:28]
    module_memory_access.io_extend_imm_z_uext <= module_execute.io_passby_imm_z_uext @[Top.scala 34:28]
    module_memory_access.io_extend_alu_out <= module_execute.io_passby_alu_out @[Top.scala 34:28]
    module_memory_access.io_csr_read_reg_rdata <= module_csr.io_read2IO_reg_rdata @[Top.scala 36:36]
    module_memory_access.io_mem_read_rdata <= module_memory.io_aread_rdata @[Top.scala 40:36]
    module_write_back.clock <= clock
    module_write_back.reset <= reset
    module_write_back.io_extend_reg_wb_addr <= module_memory_access.io_passby_reg_wb_addr @[Top.scala 42:34]
    module_write_back.io_extend_reg_wen <= module_memory_access.io_passby_reg_wen @[Top.scala 42:34]
    module_write_back.io_extend_reg_wb_data <= module_memory_access.io_passby_reg_wb_data @[Top.scala 42:34]
    module_reg.clock <= clock
    module_reg.reset <= reset
    module_reg.io_regReadIO_reg_raddr1 <= module_decode.io_regs_reg_raddr1 @[Top.scala 30:25]
    module_reg.io_regReadIO_reg_raddr2 <= module_decode.io_regs_reg_raddr2 @[Top.scala 30:25]
    module_reg.io_regWriteIO_reg_waddr <= bits(module_write_back.io_regIO_reg_waddr, 4, 0) @[Top.scala 44:30]
    module_reg.io_regWriteIO_reg_wdata <= module_write_back.io_regIO_reg_wdata @[Top.scala 44:30]
    module_reg.io_regWriteIO_wen <= module_write_back.io_regIO_wen @[Top.scala 44:30]
    module_csr.clock <= clock
    module_csr.reset <= reset
    module_csr.io_read1IO_reg_raddr <= module_inst_fetch.io_csr_read_reg_raddr @[Top.scala 26:33]
    module_csr.io_read2IO_reg_raddr <= module_memory_access.io_csr_read_reg_raddr @[Top.scala 36:36]
    module_csr.io_writeIO_reg_waddr <= module_memory_access.io_csr_write_reg_waddr @[Top.scala 37:37]
    module_csr.io_writeIO_reg_wdata <= module_memory_access.io_csr_write_reg_wdata @[Top.scala 37:37]
    module_csr.io_writeIO_wen <= module_memory_access.io_csr_write_wen @[Top.scala 37:37]
    module_memory.clock <= clock
    module_memory.reset <= reset
    module_memory.io_imem_inst_addr <= module_inst_fetch.io_inst_mem_inst_addr @[Top.scala 22:33]
    module_memory.io_aread_raddr <= module_memory_access.io_mem_read_raddr @[Top.scala 40:36]
    module_memory.io_awrite_waddr <= module_memory_access.io_mem_write_waddr @[Top.scala 39:37]
    module_memory.io_awrite_wdata <= module_memory_access.io_mem_write_wdata @[Top.scala 39:37]
    module_memory.io_awrite_write_en <= module_memory_access.io_mem_write_write_en @[Top.scala 39:37]
