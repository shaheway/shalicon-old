module InstFetch(
  input         clock,
  input         reset,
  output [31:0] io_inst_mem_inst_addr,
  input  [31:0] io_inst_mem_inst_o,
  input  [31:0] io_csr_read_reg_rdata,
  input  [31:0] io_exio_alu_out,
  input         io_exio_br_flag,
  input  [31:0] io_exio_br_target,
  input         io_exio_jmp_flag,
  output [31:0] io_passby_if_pc_reg,
  output [31:0] io_passby_if_inst
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] if_pc_reg; // @[InstFetch.scala 19:26]
  wire [31:0] _pc_next_T_1 = if_pc_reg + 32'h4; // @[InstFetch.scala 22:35]
  wire  _pc_next_T_3 = 32'h73 == io_inst_mem_inst_o; // @[InstFetch.scala 25:14]
  assign io_inst_mem_inst_addr = if_pc_reg; // @[InstFetch.scala 20:25]
  assign io_passby_if_pc_reg = if_pc_reg; // @[InstFetch.scala 30:23]
  assign io_passby_if_inst = io_inst_mem_inst_o; // @[InstFetch.scala 31:21]
  always @(posedge clock) begin
    if (reset) begin // @[InstFetch.scala 19:26]
      if_pc_reg <= 32'h0; // @[InstFetch.scala 19:26]
    end else if (io_exio_br_flag) begin // @[Mux.scala 101:16]
      if_pc_reg <= io_exio_br_target;
    end else if (io_exio_jmp_flag) begin // @[Mux.scala 101:16]
      if_pc_reg <= io_exio_alu_out;
    end else if (_pc_next_T_3) begin // @[Mux.scala 101:16]
      if_pc_reg <= io_csr_read_reg_rdata;
    end else begin
      if_pc_reg <= _pc_next_T_1;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  if_pc_reg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Decode(
  input         clock,
  input         reset,
  input  [31:0] io_extend_if_inst,
  output [4:0]  io_regs_reg_raddr1,
  output [4:0]  io_regs_reg_raddr2,
  input  [31:0] io_regs_reg_rdata1,
  input  [31:0] io_regs_reg_rdata2,
  output [31:0] io_passby_id_pc_reg,
  output [31:0] io_passby_imm_b_sext,
  output [31:0] io_passby_op1_data,
  output [31:0] io_passby_op2_data,
  output [31:0] io_passby_rs2_data,
  output [4:0]  io_passby_wb_addr,
  output [4:0]  io_passby_exe_fun,
  output [1:0]  io_passby_mem_wen,
  output [1:0]  io_passby_reg_wen,
  output [2:0]  io_passby_wb_sel,
  output [2:0]  io_passby_csr_cmd,
  output [11:0] io_passby_csr_addr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] id_inst_reg; // @[Decode.scala 15:28]
  reg [31:0] id_pc_reg; // @[Decode.scala 16:26]
  wire [4:0] rs1_addr = id_inst_reg[19:15]; // @[Decode.scala 21:29]
  wire [4:0] rs2_addr = id_inst_reg[24:20]; // @[Decode.scala 22:29]
  wire [31:0] _GEN_0 = {{27'd0}, rs1_addr}; // @[Decode.scala 29:31]
  wire [31:0] rs1_data = _GEN_0 != 32'h0 ? io_regs_reg_rdata1 : 32'h0; // @[Decode.scala 29:21]
  wire [31:0] _GEN_1 = {{27'd0}, rs2_addr}; // @[Decode.scala 30:31]
  wire [31:0] rs2_data = _GEN_1 != 32'h0 ? io_regs_reg_rdata2 : 32'h0; // @[Decode.scala 30:21]
  wire [4:0] wb_addr = id_inst_reg[11:7]; // @[Decode.scala 33:28]
  wire [11:0] imm_i = id_inst_reg[31:20]; // @[Decode.scala 35:26]
  wire [19:0] _imm_i_sext_T_2 = imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_i_sext = {_imm_i_sext_T_2,imm_i}; // @[Cat.scala 31:58]
  wire [11:0] imm_s = {id_inst_reg[31:25],wb_addr}; // @[Cat.scala 31:58]
  wire [19:0] _imm_s_sext_T_2 = imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_s_sext = {_imm_s_sext_T_2,id_inst_reg[31:25],wb_addr}; // @[Cat.scala 31:58]
  wire [11:0] imm_b = {id_inst_reg[31],id_inst_reg[7],id_inst_reg[30:25],id_inst_reg[11:8]}; // @[Cat.scala 31:58]
  wire [18:0] _imm_b_sext_T_2 = imm_b[11] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 74:12]
  wire [30:0] imm_b_sext_hi = {_imm_b_sext_T_2,id_inst_reg[31],id_inst_reg[7],id_inst_reg[30:25],id_inst_reg[11:8]}; // @[Cat.scala 31:58]
  wire [19:0] imm_j = {id_inst_reg[31],id_inst_reg[19:12],id_inst_reg[20],id_inst_reg[30:21]}; // @[Cat.scala 31:58]
  wire [10:0] _imm_j_sext_T_2 = imm_j[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_j_sext = {_imm_j_sext_T_2,id_inst_reg[31],id_inst_reg[19:12],id_inst_reg[20],id_inst_reg[30:21],1'h0}; // @[Cat.scala 31:58]
  wire [19:0] imm_u = id_inst_reg[31:12]; // @[Decode.scala 43:26]
  wire [31:0] imm_u_shifted = {imm_u,12'h0}; // @[Cat.scala 31:58]
  wire [31:0] imm_z_uext = {27'h0,rs1_addr}; // @[Cat.scala 31:58]
  wire [31:0] _decoded_inst_T = id_inst_reg & 32'h707f; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_1 = 32'h2023 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_3 = 32'h2003 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire [31:0] _decoded_inst_T_4 = id_inst_reg & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_5 = 32'h33 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_7 = 32'h40000033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_9 = 32'h13 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_11 = 32'h7033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_13 = 32'h7013 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_15 = 32'h6033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_17 = 32'h6013 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_19 = 32'h4033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_21 = 32'h4013 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_23 = 32'h1033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_25 = 32'h1013 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_27 = 32'h5033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_29 = 32'h5013 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_31 = 32'h40001033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_33 = 32'h40005013 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_35 = 32'h2033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_37 = 32'h2013 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_39 = 32'h3033 == _decoded_inst_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_41 = 32'h3013 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire [31:0] _decoded_inst_T_42 = id_inst_reg & 32'h7f; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_43 = 32'h6f == _decoded_inst_T_42; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_45 = 32'h37 == _decoded_inst_T_42; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_47 = 32'h17 == _decoded_inst_T_42; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_49 = 32'h67 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_51 = 32'h63 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_53 = 32'h1063 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_55 = 32'h6063 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_57 = 32'h7063 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_59 = 32'h4063 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_61 = 32'h5063 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_63 = 32'h1073 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_65 = 32'h5073 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_67 = 32'h2073 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_69 = 32'h6073 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_71 = 32'h3073 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_73 = 32'h7073 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_75 = 32'h73 == id_inst_reg; // @[Lookup.scala 31:38]
  wire [4:0] _decoded_inst_T_77 = _decoded_inst_T_73 ? 5'hc : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_78 = _decoded_inst_T_71 ? 5'hc : _decoded_inst_T_77; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_79 = _decoded_inst_T_69 ? 5'hc : _decoded_inst_T_78; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_80 = _decoded_inst_T_67 ? 5'hc : _decoded_inst_T_79; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_81 = _decoded_inst_T_65 ? 5'hc : _decoded_inst_T_80; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_82 = _decoded_inst_T_63 ? 5'hc : _decoded_inst_T_81; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_83 = _decoded_inst_T_61 ? 5'h12 : _decoded_inst_T_82; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_84 = _decoded_inst_T_59 ? 5'h11 : _decoded_inst_T_83; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_85 = _decoded_inst_T_57 ? 5'h10 : _decoded_inst_T_84; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_86 = _decoded_inst_T_55 ? 5'hf : _decoded_inst_T_85; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_87 = _decoded_inst_T_53 ? 5'he : _decoded_inst_T_86; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_88 = _decoded_inst_T_51 ? 5'hd : _decoded_inst_T_87; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_89 = _decoded_inst_T_49 ? 5'hb : _decoded_inst_T_88; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_90 = _decoded_inst_T_47 ? 5'h1 : _decoded_inst_T_89; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_91 = _decoded_inst_T_45 ? 5'h1 : _decoded_inst_T_90; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_92 = _decoded_inst_T_43 ? 5'h1 : _decoded_inst_T_91; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_93 = _decoded_inst_T_41 ? 5'h9 : _decoded_inst_T_92; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_94 = _decoded_inst_T_39 ? 5'h9 : _decoded_inst_T_93; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_95 = _decoded_inst_T_37 ? 5'h9 : _decoded_inst_T_94; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_96 = _decoded_inst_T_35 ? 5'h9 : _decoded_inst_T_95; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_97 = _decoded_inst_T_33 ? 5'h8 : _decoded_inst_T_96; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_98 = _decoded_inst_T_31 ? 5'h8 : _decoded_inst_T_97; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_99 = _decoded_inst_T_29 ? 5'h7 : _decoded_inst_T_98; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_100 = _decoded_inst_T_27 ? 5'h7 : _decoded_inst_T_99; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_101 = _decoded_inst_T_25 ? 5'h6 : _decoded_inst_T_100; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_102 = _decoded_inst_T_23 ? 5'h6 : _decoded_inst_T_101; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_103 = _decoded_inst_T_21 ? 5'h4 : _decoded_inst_T_102; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_104 = _decoded_inst_T_19 ? 5'h5 : _decoded_inst_T_103; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_105 = _decoded_inst_T_17 ? 5'h4 : _decoded_inst_T_104; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_106 = _decoded_inst_T_15 ? 5'h4 : _decoded_inst_T_105; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_107 = _decoded_inst_T_13 ? 5'h3 : _decoded_inst_T_106; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_108 = _decoded_inst_T_11 ? 5'h3 : _decoded_inst_T_107; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_109 = _decoded_inst_T_9 ? 5'h1 : _decoded_inst_T_108; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_110 = _decoded_inst_T_7 ? 5'h2 : _decoded_inst_T_109; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_111 = _decoded_inst_T_5 ? 5'h1 : _decoded_inst_T_110; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_112 = _decoded_inst_T_3 ? 5'h1 : _decoded_inst_T_111; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_114 = _decoded_inst_T_73 ? 2'h3 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_115 = _decoded_inst_T_71 ? 2'h1 : _decoded_inst_T_114; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_116 = _decoded_inst_T_69 ? 2'h3 : _decoded_inst_T_115; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_117 = _decoded_inst_T_67 ? 2'h1 : _decoded_inst_T_116; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_118 = _decoded_inst_T_65 ? 2'h3 : _decoded_inst_T_117; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_119 = _decoded_inst_T_63 ? 2'h1 : _decoded_inst_T_118; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_120 = _decoded_inst_T_61 ? 2'h1 : _decoded_inst_T_119; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_121 = _decoded_inst_T_59 ? 2'h1 : _decoded_inst_T_120; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_122 = _decoded_inst_T_57 ? 2'h1 : _decoded_inst_T_121; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_123 = _decoded_inst_T_55 ? 2'h1 : _decoded_inst_T_122; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_124 = _decoded_inst_T_53 ? 2'h1 : _decoded_inst_T_123; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_125 = _decoded_inst_T_51 ? 2'h1 : _decoded_inst_T_124; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_126 = _decoded_inst_T_49 ? 2'h2 : _decoded_inst_T_125; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_127 = _decoded_inst_T_47 ? 2'h2 : _decoded_inst_T_126; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_128 = _decoded_inst_T_45 ? 2'h0 : _decoded_inst_T_127; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_129 = _decoded_inst_T_43 ? 2'h2 : _decoded_inst_T_128; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_130 = _decoded_inst_T_41 ? 2'h1 : _decoded_inst_T_129; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_131 = _decoded_inst_T_39 ? 2'h1 : _decoded_inst_T_130; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_132 = _decoded_inst_T_37 ? 2'h1 : _decoded_inst_T_131; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_133 = _decoded_inst_T_35 ? 2'h1 : _decoded_inst_T_132; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_134 = _decoded_inst_T_33 ? 2'h1 : _decoded_inst_T_133; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_135 = _decoded_inst_T_31 ? 2'h1 : _decoded_inst_T_134; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_136 = _decoded_inst_T_29 ? 2'h1 : _decoded_inst_T_135; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_137 = _decoded_inst_T_27 ? 2'h1 : _decoded_inst_T_136; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_138 = _decoded_inst_T_25 ? 2'h1 : _decoded_inst_T_137; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_139 = _decoded_inst_T_23 ? 2'h1 : _decoded_inst_T_138; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_140 = _decoded_inst_T_21 ? 2'h1 : _decoded_inst_T_139; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_141 = _decoded_inst_T_19 ? 2'h1 : _decoded_inst_T_140; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_142 = _decoded_inst_T_17 ? 2'h1 : _decoded_inst_T_141; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_143 = _decoded_inst_T_15 ? 2'h1 : _decoded_inst_T_142; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_144 = _decoded_inst_T_13 ? 2'h1 : _decoded_inst_T_143; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_145 = _decoded_inst_T_11 ? 2'h1 : _decoded_inst_T_144; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_146 = _decoded_inst_T_9 ? 2'h1 : _decoded_inst_T_145; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_147 = _decoded_inst_T_7 ? 2'h1 : _decoded_inst_T_146; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_148 = _decoded_inst_T_5 ? 2'h1 : _decoded_inst_T_147; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_149 = _decoded_inst_T_3 ? 2'h1 : _decoded_inst_T_148; // @[Lookup.scala 34:39]
  wire [1:0] decoded_inst_1 = _decoded_inst_T_1 ? 2'h1 : _decoded_inst_T_149; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_152 = _decoded_inst_T_71 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_153 = _decoded_inst_T_69 ? 3'h0 : _decoded_inst_T_152; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_154 = _decoded_inst_T_67 ? 3'h0 : _decoded_inst_T_153; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_155 = _decoded_inst_T_65 ? 3'h0 : _decoded_inst_T_154; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_156 = _decoded_inst_T_63 ? 3'h0 : _decoded_inst_T_155; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_157 = _decoded_inst_T_61 ? 3'h1 : _decoded_inst_T_156; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_158 = _decoded_inst_T_59 ? 3'h1 : _decoded_inst_T_157; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_159 = _decoded_inst_T_57 ? 3'h1 : _decoded_inst_T_158; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_160 = _decoded_inst_T_55 ? 3'h1 : _decoded_inst_T_159; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_161 = _decoded_inst_T_53 ? 3'h1 : _decoded_inst_T_160; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_162 = _decoded_inst_T_51 ? 3'h1 : _decoded_inst_T_161; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_163 = _decoded_inst_T_49 ? 3'h3 : _decoded_inst_T_162; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_164 = _decoded_inst_T_47 ? 3'h5 : _decoded_inst_T_163; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_165 = _decoded_inst_T_45 ? 3'h5 : _decoded_inst_T_164; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_166 = _decoded_inst_T_43 ? 3'h3 : _decoded_inst_T_165; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_167 = _decoded_inst_T_41 ? 3'h2 : _decoded_inst_T_166; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_168 = _decoded_inst_T_39 ? 3'h1 : _decoded_inst_T_167; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_169 = _decoded_inst_T_37 ? 3'h2 : _decoded_inst_T_168; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_170 = _decoded_inst_T_35 ? 3'h1 : _decoded_inst_T_169; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_171 = _decoded_inst_T_33 ? 3'h2 : _decoded_inst_T_170; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_172 = _decoded_inst_T_31 ? 3'h1 : _decoded_inst_T_171; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_173 = _decoded_inst_T_29 ? 3'h2 : _decoded_inst_T_172; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_174 = _decoded_inst_T_27 ? 3'h1 : _decoded_inst_T_173; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_175 = _decoded_inst_T_25 ? 3'h2 : _decoded_inst_T_174; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_176 = _decoded_inst_T_23 ? 3'h1 : _decoded_inst_T_175; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_177 = _decoded_inst_T_21 ? 3'h2 : _decoded_inst_T_176; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_178 = _decoded_inst_T_19 ? 3'h1 : _decoded_inst_T_177; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_179 = _decoded_inst_T_17 ? 3'h2 : _decoded_inst_T_178; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_180 = _decoded_inst_T_15 ? 3'h1 : _decoded_inst_T_179; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_181 = _decoded_inst_T_13 ? 3'h2 : _decoded_inst_T_180; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_182 = _decoded_inst_T_11 ? 3'h1 : _decoded_inst_T_181; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_183 = _decoded_inst_T_9 ? 3'h2 : _decoded_inst_T_182; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_184 = _decoded_inst_T_7 ? 3'h1 : _decoded_inst_T_183; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_185 = _decoded_inst_T_5 ? 3'h1 : _decoded_inst_T_184; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_186 = _decoded_inst_T_3 ? 3'h2 : _decoded_inst_T_185; // @[Lookup.scala 34:39]
  wire [2:0] decoded_inst_2 = _decoded_inst_T_1 ? 3'h4 : _decoded_inst_T_186; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_225 = _decoded_inst_T_73 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_226 = _decoded_inst_T_71 ? 2'h1 : _decoded_inst_T_225; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_227 = _decoded_inst_T_69 ? 2'h1 : _decoded_inst_T_226; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_228 = _decoded_inst_T_67 ? 2'h1 : _decoded_inst_T_227; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_229 = _decoded_inst_T_65 ? 2'h1 : _decoded_inst_T_228; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_230 = _decoded_inst_T_63 ? 2'h1 : _decoded_inst_T_229; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_231 = _decoded_inst_T_61 ? 2'h0 : _decoded_inst_T_230; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_232 = _decoded_inst_T_59 ? 2'h0 : _decoded_inst_T_231; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_233 = _decoded_inst_T_57 ? 2'h0 : _decoded_inst_T_232; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_234 = _decoded_inst_T_55 ? 2'h0 : _decoded_inst_T_233; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_235 = _decoded_inst_T_53 ? 2'h0 : _decoded_inst_T_234; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_236 = _decoded_inst_T_51 ? 2'h0 : _decoded_inst_T_235; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_237 = _decoded_inst_T_49 ? 2'h1 : _decoded_inst_T_236; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_238 = _decoded_inst_T_47 ? 2'h1 : _decoded_inst_T_237; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_239 = _decoded_inst_T_45 ? 2'h1 : _decoded_inst_T_238; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_240 = _decoded_inst_T_43 ? 2'h1 : _decoded_inst_T_239; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_241 = _decoded_inst_T_41 ? 2'h1 : _decoded_inst_T_240; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_242 = _decoded_inst_T_39 ? 2'h1 : _decoded_inst_T_241; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_243 = _decoded_inst_T_37 ? 2'h1 : _decoded_inst_T_242; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_244 = _decoded_inst_T_35 ? 2'h1 : _decoded_inst_T_243; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_245 = _decoded_inst_T_33 ? 2'h1 : _decoded_inst_T_244; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_246 = _decoded_inst_T_31 ? 2'h1 : _decoded_inst_T_245; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_247 = _decoded_inst_T_29 ? 2'h1 : _decoded_inst_T_246; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_248 = _decoded_inst_T_27 ? 2'h1 : _decoded_inst_T_247; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_249 = _decoded_inst_T_25 ? 2'h1 : _decoded_inst_T_248; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_250 = _decoded_inst_T_23 ? 2'h1 : _decoded_inst_T_249; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_251 = _decoded_inst_T_21 ? 2'h1 : _decoded_inst_T_250; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_252 = _decoded_inst_T_19 ? 2'h1 : _decoded_inst_T_251; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_253 = _decoded_inst_T_17 ? 2'h1 : _decoded_inst_T_252; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_254 = _decoded_inst_T_15 ? 2'h1 : _decoded_inst_T_253; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_255 = _decoded_inst_T_13 ? 2'h1 : _decoded_inst_T_254; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_256 = _decoded_inst_T_11 ? 2'h1 : _decoded_inst_T_255; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_257 = _decoded_inst_T_9 ? 2'h1 : _decoded_inst_T_256; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_258 = _decoded_inst_T_7 ? 2'h1 : _decoded_inst_T_257; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_259 = _decoded_inst_T_5 ? 2'h1 : _decoded_inst_T_258; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_260 = _decoded_inst_T_3 ? 2'h1 : _decoded_inst_T_259; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_262 = _decoded_inst_T_73 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_263 = _decoded_inst_T_71 ? 3'h4 : _decoded_inst_T_262; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_264 = _decoded_inst_T_69 ? 3'h4 : _decoded_inst_T_263; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_265 = _decoded_inst_T_67 ? 3'h4 : _decoded_inst_T_264; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_266 = _decoded_inst_T_65 ? 3'h4 : _decoded_inst_T_265; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_267 = _decoded_inst_T_63 ? 3'h4 : _decoded_inst_T_266; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_268 = _decoded_inst_T_61 ? 3'h0 : _decoded_inst_T_267; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_269 = _decoded_inst_T_59 ? 3'h0 : _decoded_inst_T_268; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_270 = _decoded_inst_T_57 ? 3'h0 : _decoded_inst_T_269; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_271 = _decoded_inst_T_55 ? 3'h0 : _decoded_inst_T_270; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_272 = _decoded_inst_T_53 ? 3'h0 : _decoded_inst_T_271; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_273 = _decoded_inst_T_51 ? 3'h0 : _decoded_inst_T_272; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_274 = _decoded_inst_T_49 ? 3'h3 : _decoded_inst_T_273; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_275 = _decoded_inst_T_47 ? 3'h1 : _decoded_inst_T_274; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_276 = _decoded_inst_T_45 ? 3'h1 : _decoded_inst_T_275; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_277 = _decoded_inst_T_43 ? 3'h3 : _decoded_inst_T_276; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_278 = _decoded_inst_T_41 ? 3'h1 : _decoded_inst_T_277; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_279 = _decoded_inst_T_39 ? 3'h1 : _decoded_inst_T_278; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_280 = _decoded_inst_T_37 ? 3'h1 : _decoded_inst_T_279; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_281 = _decoded_inst_T_35 ? 3'h1 : _decoded_inst_T_280; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_282 = _decoded_inst_T_33 ? 3'h1 : _decoded_inst_T_281; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_283 = _decoded_inst_T_31 ? 3'h1 : _decoded_inst_T_282; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_284 = _decoded_inst_T_29 ? 3'h1 : _decoded_inst_T_283; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_285 = _decoded_inst_T_27 ? 3'h1 : _decoded_inst_T_284; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_286 = _decoded_inst_T_25 ? 3'h1 : _decoded_inst_T_285; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_287 = _decoded_inst_T_23 ? 3'h1 : _decoded_inst_T_286; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_288 = _decoded_inst_T_21 ? 3'h1 : _decoded_inst_T_287; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_289 = _decoded_inst_T_19 ? 3'h1 : _decoded_inst_T_288; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_290 = _decoded_inst_T_17 ? 3'h1 : _decoded_inst_T_289; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_291 = _decoded_inst_T_15 ? 3'h1 : _decoded_inst_T_290; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_292 = _decoded_inst_T_13 ? 3'h1 : _decoded_inst_T_291; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_293 = _decoded_inst_T_11 ? 3'h1 : _decoded_inst_T_292; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_294 = _decoded_inst_T_9 ? 3'h1 : _decoded_inst_T_293; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_295 = _decoded_inst_T_7 ? 3'h1 : _decoded_inst_T_294; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_296 = _decoded_inst_T_5 ? 3'h1 : _decoded_inst_T_295; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_297 = _decoded_inst_T_3 ? 3'h2 : _decoded_inst_T_296; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_298 = _decoded_inst_T_75 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_299 = _decoded_inst_T_73 ? 3'h3 : _decoded_inst_T_298; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_300 = _decoded_inst_T_71 ? 3'h3 : _decoded_inst_T_299; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_301 = _decoded_inst_T_69 ? 3'h2 : _decoded_inst_T_300; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_302 = _decoded_inst_T_67 ? 3'h2 : _decoded_inst_T_301; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_303 = _decoded_inst_T_65 ? 3'h1 : _decoded_inst_T_302; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_304 = _decoded_inst_T_63 ? 3'h1 : _decoded_inst_T_303; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_305 = _decoded_inst_T_61 ? 3'h0 : _decoded_inst_T_304; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_306 = _decoded_inst_T_59 ? 3'h0 : _decoded_inst_T_305; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_307 = _decoded_inst_T_57 ? 3'h0 : _decoded_inst_T_306; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_308 = _decoded_inst_T_55 ? 3'h0 : _decoded_inst_T_307; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_309 = _decoded_inst_T_53 ? 3'h0 : _decoded_inst_T_308; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_310 = _decoded_inst_T_51 ? 3'h0 : _decoded_inst_T_309; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_311 = _decoded_inst_T_49 ? 3'h0 : _decoded_inst_T_310; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_312 = _decoded_inst_T_47 ? 3'h0 : _decoded_inst_T_311; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_313 = _decoded_inst_T_45 ? 3'h0 : _decoded_inst_T_312; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_314 = _decoded_inst_T_43 ? 3'h0 : _decoded_inst_T_313; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_315 = _decoded_inst_T_41 ? 3'h0 : _decoded_inst_T_314; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_316 = _decoded_inst_T_39 ? 3'h0 : _decoded_inst_T_315; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_317 = _decoded_inst_T_37 ? 3'h0 : _decoded_inst_T_316; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_318 = _decoded_inst_T_35 ? 3'h0 : _decoded_inst_T_317; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_319 = _decoded_inst_T_33 ? 3'h0 : _decoded_inst_T_318; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_320 = _decoded_inst_T_31 ? 3'h0 : _decoded_inst_T_319; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_321 = _decoded_inst_T_29 ? 3'h0 : _decoded_inst_T_320; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_322 = _decoded_inst_T_27 ? 3'h0 : _decoded_inst_T_321; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_323 = _decoded_inst_T_25 ? 3'h0 : _decoded_inst_T_322; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_324 = _decoded_inst_T_23 ? 3'h0 : _decoded_inst_T_323; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_325 = _decoded_inst_T_21 ? 3'h0 : _decoded_inst_T_324; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_326 = _decoded_inst_T_19 ? 3'h0 : _decoded_inst_T_325; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_327 = _decoded_inst_T_17 ? 3'h0 : _decoded_inst_T_326; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_328 = _decoded_inst_T_15 ? 3'h0 : _decoded_inst_T_327; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_329 = _decoded_inst_T_13 ? 3'h0 : _decoded_inst_T_328; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_330 = _decoded_inst_T_11 ? 3'h0 : _decoded_inst_T_329; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_331 = _decoded_inst_T_9 ? 3'h0 : _decoded_inst_T_330; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_332 = _decoded_inst_T_7 ? 3'h0 : _decoded_inst_T_331; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_333 = _decoded_inst_T_5 ? 3'h0 : _decoded_inst_T_332; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_334 = _decoded_inst_T_3 ? 3'h0 : _decoded_inst_T_333; // @[Lookup.scala 34:39]
  wire [2:0] csr_cmd = _decoded_inst_T_1 ? 3'h0 : _decoded_inst_T_334; // @[Lookup.scala 34:39]
  wire  _op1_data_T = decoded_inst_1 == 2'h1; // @[Decode.scala 101:14]
  wire  _op1_data_T_1 = decoded_inst_1 == 2'h2; // @[Decode.scala 102:14]
  wire  _op1_data_T_2 = decoded_inst_1 == 2'h3; // @[Decode.scala 103:14]
  wire [31:0] _op1_data_T_3 = _op1_data_T_2 ? imm_z_uext : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _op1_data_T_4 = _op1_data_T_1 ? id_pc_reg : _op1_data_T_3; // @[Mux.scala 101:16]
  wire  _op2_data_T = decoded_inst_2 == 3'h1; // @[Decode.scala 107:14]
  wire  _op2_data_T_1 = decoded_inst_2 == 3'h2; // @[Decode.scala 108:14]
  wire  _op2_data_T_2 = decoded_inst_2 == 3'h4; // @[Decode.scala 109:14]
  wire  _op2_data_T_3 = decoded_inst_2 == 3'h3; // @[Decode.scala 110:14]
  wire  _op2_data_T_4 = decoded_inst_2 == 3'h5; // @[Decode.scala 111:14]
  wire [31:0] _op2_data_T_5 = _op2_data_T_4 ? imm_u_shifted : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _op2_data_T_6 = _op2_data_T_3 ? imm_j_sext : _op2_data_T_5; // @[Mux.scala 101:16]
  wire [31:0] _op2_data_T_7 = _op2_data_T_2 ? imm_s_sext : _op2_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _op2_data_T_8 = _op2_data_T_1 ? imm_i_sext : _op2_data_T_7; // @[Mux.scala 101:16]
  assign io_regs_reg_raddr1 = id_inst_reg[19:15]; // @[Decode.scala 21:29]
  assign io_regs_reg_raddr2 = id_inst_reg[24:20]; // @[Decode.scala 22:29]
  assign io_passby_id_pc_reg = id_pc_reg; // @[Decode.scala 117:23]
  assign io_passby_imm_b_sext = {imm_b_sext_hi,1'h0}; // @[Cat.scala 31:58]
  assign io_passby_op1_data = _op1_data_T ? rs1_data : _op1_data_T_4; // @[Mux.scala 101:16]
  assign io_passby_op2_data = _op2_data_T ? rs2_data : _op2_data_T_8; // @[Mux.scala 101:16]
  assign io_passby_rs2_data = _GEN_1 != 32'h0 ? io_regs_reg_rdata2 : 32'h0; // @[Decode.scala 30:21]
  assign io_passby_wb_addr = id_inst_reg[11:7]; // @[Decode.scala 33:28]
  assign io_passby_exe_fun = _decoded_inst_T_1 ? 5'h1 : _decoded_inst_T_112; // @[Lookup.scala 34:39]
  assign io_passby_mem_wen = _decoded_inst_T_1 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  assign io_passby_reg_wen = _decoded_inst_T_1 ? 2'h0 : _decoded_inst_T_260; // @[Lookup.scala 34:39]
  assign io_passby_wb_sel = _decoded_inst_T_1 ? 3'h0 : _decoded_inst_T_297; // @[Lookup.scala 34:39]
  assign io_passby_csr_cmd = _decoded_inst_T_1 ? 3'h0 : _decoded_inst_T_334; // @[Lookup.scala 34:39]
  assign io_passby_csr_addr = csr_cmd == 3'h4 ? 12'h0 : imm_i; // @[Decode.scala 114:21]
  always @(posedge clock) begin
    if (reset) begin // @[Decode.scala 15:28]
      id_inst_reg <= 32'h0; // @[Decode.scala 15:28]
    end else begin
      id_inst_reg <= io_extend_if_inst; // @[Decode.scala 17:15]
    end
    if (reset) begin // @[Decode.scala 16:26]
      id_pc_reg <= 32'h0; // @[Decode.scala 16:26]
    end else begin
      id_pc_reg <= io_extend_if_inst; // @[Decode.scala 18:13]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  id_inst_reg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  id_pc_reg = _RAND_1[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Execute(
  input         clock,
  input         reset,
  input  [31:0] io_extend_id_pc_reg,
  input  [31:0] io_extend_imm_b_sext,
  input  [31:0] io_extend_op1_data,
  input  [31:0] io_extend_op2_data,
  input  [31:0] io_extend_rs2_data,
  input  [4:0]  io_extend_wb_addr,
  input  [4:0]  io_extend_exe_fun,
  input  [1:0]  io_extend_mem_wen,
  input  [1:0]  io_extend_reg_wen,
  input  [2:0]  io_extend_wb_sel,
  input  [2:0]  io_extend_csr_cmd,
  input  [11:0] io_extend_csr_addr,
  output [31:0] io_exifIO_alu_out,
  output        io_exifIO_br_flag,
  output [31:0] io_exifIO_br_target,
  output        io_exifIO_jmp_flag,
  output [31:0] io_passby_exe_pc_reg,
  output [4:0]  io_passby_wb_addr,
  output [31:0] io_passby_op1_data,
  output [31:0] io_passby_rs2_data,
  output [1:0]  io_passby_mem_wen,
  output [1:0]  io_passby_reg_wen,
  output [2:0]  io_passby_wb_sel,
  output [11:0] io_passby_csr_addr,
  output [2:0]  io_passby_csr_cmd,
  output [31:0] io_passby_alu_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  reg [4:0] ex_pc_reg; // @[Execute.scala 15:26]
  reg [4:0] exe_fun_reg; // @[Execute.scala 16:28]
  reg [31:0] op1_data_reg; // @[Execute.scala 17:29]
  reg [31:0] op2_data_reg; // @[Execute.scala 18:29]
  reg [31:0] rs2_data_reg; // @[Execute.scala 19:29]
  reg [4:0] wb_addr_reg; // @[Execute.scala 20:28]
  reg [1:0] mem_wen_reg; // @[Execute.scala 21:28]
  reg [1:0] reg_wen_reg; // @[Execute.scala 22:28]
  reg [2:0] wb_sel_reg; // @[Execute.scala 23:27]
  reg  csr_addr_reg; // @[Execute.scala 24:29]
  reg [2:0] csr_cmd_reg; // @[Execute.scala 25:28]
  reg [31:0] imm_b_sext_reg; // @[Execute.scala 28:31]
  wire  _alu_out_T = exe_fun_reg == 5'h1; // @[Execute.scala 58:18]
  wire [31:0] _alu_out_T_2 = op1_data_reg + op2_data_reg; // @[Execute.scala 58:48]
  wire  _alu_out_T_3 = exe_fun_reg == 5'h2; // @[Execute.scala 59:18]
  wire [31:0] _alu_out_T_5 = op1_data_reg - op2_data_reg; // @[Execute.scala 59:48]
  wire  _alu_out_T_6 = exe_fun_reg == 5'h3; // @[Execute.scala 60:18]
  wire [31:0] _alu_out_T_7 = op1_data_reg & op2_data_reg; // @[Execute.scala 60:48]
  wire  _alu_out_T_8 = exe_fun_reg == 5'h4; // @[Execute.scala 61:18]
  wire [31:0] _alu_out_T_9 = op1_data_reg | op2_data_reg; // @[Execute.scala 61:47]
  wire  _alu_out_T_10 = exe_fun_reg == 5'h5; // @[Execute.scala 62:18]
  wire [31:0] _alu_out_T_11 = op1_data_reg ^ op2_data_reg; // @[Execute.scala 62:48]
  wire  _alu_out_T_12 = exe_fun_reg == 5'h6; // @[Execute.scala 63:18]
  wire [62:0] _GEN_3 = {{31'd0}, op1_data_reg}; // @[Execute.scala 63:48]
  wire [62:0] _alu_out_T_14 = _GEN_3 << op2_data_reg[4:0]; // @[Execute.scala 63:48]
  wire  _alu_out_T_15 = exe_fun_reg == 5'h7; // @[Execute.scala 64:18]
  wire [31:0] _alu_out_T_17 = op1_data_reg >> op2_data_reg[4:0]; // @[Execute.scala 64:48]
  wire  _alu_out_T_18 = exe_fun_reg == 5'h8; // @[Execute.scala 65:18]
  wire [31:0] _alu_out_T_22 = $signed(op1_data_reg) >>> op2_data_reg[4:0]; // @[Execute.scala 65:78]
  wire  _alu_out_T_23 = exe_fun_reg == 5'h9; // @[Execute.scala 66:18]
  wire  _alu_out_T_26 = $signed(op1_data_reg) < $signed(op2_data_reg); // @[Execute.scala 66:55]
  wire  _alu_out_T_27 = exe_fun_reg == 5'ha; // @[Execute.scala 67:18]
  wire  _alu_out_T_28 = op1_data_reg < op2_data_reg; // @[Execute.scala 67:49]
  wire  _alu_out_T_29 = exe_fun_reg == 5'hb; // @[Execute.scala 68:18]
  wire [31:0] _alu_out_T_32 = _alu_out_T_2 & 32'hfffffffe; // @[Execute.scala 68:66]
  wire  _alu_out_T_33 = exe_fun_reg == 5'hc; // @[Execute.scala 69:18]
  wire [31:0] _alu_out_T_34 = _alu_out_T_33 ? op1_data_reg : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _alu_out_T_35 = _alu_out_T_29 ? _alu_out_T_32 : _alu_out_T_34; // @[Mux.scala 101:16]
  wire [31:0] _alu_out_T_36 = _alu_out_T_27 ? {{31'd0}, _alu_out_T_28} : _alu_out_T_35; // @[Mux.scala 101:16]
  wire [31:0] _alu_out_T_37 = _alu_out_T_23 ? {{31'd0}, _alu_out_T_26} : _alu_out_T_36; // @[Mux.scala 101:16]
  wire [31:0] _alu_out_T_38 = _alu_out_T_18 ? _alu_out_T_22 : _alu_out_T_37; // @[Mux.scala 101:16]
  wire [31:0] _alu_out_T_39 = _alu_out_T_15 ? _alu_out_T_17 : _alu_out_T_38; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_40 = _alu_out_T_12 ? _alu_out_T_14 : {{31'd0}, _alu_out_T_39}; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_41 = _alu_out_T_10 ? {{31'd0}, _alu_out_T_11} : _alu_out_T_40; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_42 = _alu_out_T_8 ? {{31'd0}, _alu_out_T_9} : _alu_out_T_41; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_43 = _alu_out_T_6 ? {{31'd0}, _alu_out_T_7} : _alu_out_T_42; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_44 = _alu_out_T_3 ? {{31'd0}, _alu_out_T_5} : _alu_out_T_43; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_45 = _alu_out_T ? {{31'd0}, _alu_out_T_2} : _alu_out_T_44; // @[Mux.scala 101:16]
  wire  _br_flag_T = exe_fun_reg == 5'hd; // @[Execute.scala 73:18]
  wire  _br_flag_T_1 = op1_data_reg == op2_data_reg; // @[Execute.scala 73:47]
  wire  _br_flag_T_2 = exe_fun_reg == 5'he; // @[Execute.scala 74:18]
  wire  _br_flag_T_3 = op1_data_reg != op2_data_reg; // @[Execute.scala 74:47]
  wire  _br_flag_T_4 = exe_fun_reg == 5'hf; // @[Execute.scala 75:18]
  wire  _br_flag_T_6 = exe_fun_reg == 5'h11; // @[Execute.scala 76:18]
  wire  _br_flag_T_10 = exe_fun_reg == 5'h10; // @[Execute.scala 77:18]
  wire  _br_flag_T_11 = op1_data_reg >= op2_data_reg; // @[Execute.scala 77:48]
  wire  _br_flag_T_12 = exe_fun_reg == 5'h12; // @[Execute.scala 78:18]
  wire  _br_flag_T_15 = $signed(op1_data_reg) >= $signed(op2_data_reg); // @[Execute.scala 78:54]
  wire  _br_flag_T_17 = _br_flag_T_10 ? _br_flag_T_11 : _br_flag_T_12 & _br_flag_T_15; // @[Mux.scala 101:16]
  wire  _br_flag_T_18 = _br_flag_T_6 ? _alu_out_T_26 : _br_flag_T_17; // @[Mux.scala 101:16]
  wire  _br_flag_T_19 = _br_flag_T_4 ? _alu_out_T_28 : _br_flag_T_18; // @[Mux.scala 101:16]
  wire  _br_flag_T_20 = _br_flag_T_2 ? _br_flag_T_3 : _br_flag_T_19; // @[Mux.scala 101:16]
  wire [31:0] _GEN_0 = {{27'd0}, ex_pc_reg}; // @[Execute.scala 80:26]
  wire [31:0] jmp_flag = {{31'd0}, wb_sel_reg == 3'h3}; // @[Execute.scala 53:22 82:12]
  wire [31:0] _GEN_1 = reset ? 32'h0 : io_extend_id_pc_reg; // @[Execute.scala 15:{26,26} 33:13]
  wire [11:0] _GEN_2 = reset ? 12'h0 : io_extend_csr_addr; // @[Execute.scala 24:{29,29} 42:16]
  assign io_exifIO_alu_out = _alu_out_T_45[31:0]; // @[Execute.scala 50:21 57:11]
  assign io_exifIO_br_flag = _br_flag_T ? _br_flag_T_1 : _br_flag_T_20; // @[Mux.scala 101:16]
  assign io_exifIO_br_target = _GEN_0 + imm_b_sext_reg; // @[Execute.scala 80:26]
  assign io_exifIO_jmp_flag = jmp_flag[0]; // @[Execute.scala 88:22]
  assign io_passby_exe_pc_reg = {{27'd0}, ex_pc_reg}; // @[Execute.scala 91:24]
  assign io_passby_wb_addr = wb_addr_reg; // @[Execute.scala 92:21]
  assign io_passby_op1_data = op1_data_reg; // @[Execute.scala 93:22]
  assign io_passby_rs2_data = rs2_data_reg; // @[Execute.scala 94:22]
  assign io_passby_mem_wen = mem_wen_reg; // @[Execute.scala 95:21]
  assign io_passby_reg_wen = reg_wen_reg; // @[Execute.scala 96:21]
  assign io_passby_wb_sel = wb_sel_reg; // @[Execute.scala 97:20]
  assign io_passby_csr_addr = {{11'd0}, csr_addr_reg}; // @[Execute.scala 98:22]
  assign io_passby_csr_cmd = csr_cmd_reg; // @[Execute.scala 99:21]
  assign io_passby_alu_out = _alu_out_T_45[31:0]; // @[Execute.scala 50:21 57:11]
  always @(posedge clock) begin
    ex_pc_reg <= _GEN_1[4:0]; // @[Execute.scala 15:{26,26} 33:13]
    if (reset) begin // @[Execute.scala 16:28]
      exe_fun_reg <= 5'h0; // @[Execute.scala 16:28]
    end else begin
      exe_fun_reg <= io_extend_exe_fun; // @[Execute.scala 34:15]
    end
    if (reset) begin // @[Execute.scala 17:29]
      op1_data_reg <= 32'h0; // @[Execute.scala 17:29]
    end else begin
      op1_data_reg <= io_extend_op1_data; // @[Execute.scala 35:16]
    end
    if (reset) begin // @[Execute.scala 18:29]
      op2_data_reg <= 32'h0; // @[Execute.scala 18:29]
    end else begin
      op2_data_reg <= io_extend_op2_data; // @[Execute.scala 36:16]
    end
    if (reset) begin // @[Execute.scala 19:29]
      rs2_data_reg <= 32'h0; // @[Execute.scala 19:29]
    end else begin
      rs2_data_reg <= io_extend_rs2_data; // @[Execute.scala 37:16]
    end
    if (reset) begin // @[Execute.scala 20:28]
      wb_addr_reg <= 5'h0; // @[Execute.scala 20:28]
    end else begin
      wb_addr_reg <= io_extend_wb_addr; // @[Execute.scala 38:15]
    end
    if (reset) begin // @[Execute.scala 21:28]
      mem_wen_reg <= 2'h0; // @[Execute.scala 21:28]
    end else begin
      mem_wen_reg <= io_extend_mem_wen; // @[Execute.scala 40:15]
    end
    if (reset) begin // @[Execute.scala 22:28]
      reg_wen_reg <= 2'h0; // @[Execute.scala 22:28]
    end else begin
      reg_wen_reg <= io_extend_reg_wen; // @[Execute.scala 41:15]
    end
    if (reset) begin // @[Execute.scala 23:27]
      wb_sel_reg <= 3'h0; // @[Execute.scala 23:27]
    end else begin
      wb_sel_reg <= io_extend_wb_sel; // @[Execute.scala 39:14]
    end
    csr_addr_reg <= _GEN_2[0]; // @[Execute.scala 24:{29,29} 42:16]
    if (reset) begin // @[Execute.scala 25:28]
      csr_cmd_reg <= 3'h0; // @[Execute.scala 25:28]
    end else begin
      csr_cmd_reg <= io_extend_csr_cmd; // @[Execute.scala 43:15]
    end
    if (reset) begin // @[Execute.scala 28:31]
      imm_b_sext_reg <= 32'h0; // @[Execute.scala 28:31]
    end else begin
      imm_b_sext_reg <= io_extend_imm_b_sext; // @[Execute.scala 46:18]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ex_pc_reg = _RAND_0[4:0];
  _RAND_1 = {1{`RANDOM}};
  exe_fun_reg = _RAND_1[4:0];
  _RAND_2 = {1{`RANDOM}};
  op1_data_reg = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  op2_data_reg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  rs2_data_reg = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  wb_addr_reg = _RAND_5[4:0];
  _RAND_6 = {1{`RANDOM}};
  mem_wen_reg = _RAND_6[1:0];
  _RAND_7 = {1{`RANDOM}};
  reg_wen_reg = _RAND_7[1:0];
  _RAND_8 = {1{`RANDOM}};
  wb_sel_reg = _RAND_8[2:0];
  _RAND_9 = {1{`RANDOM}};
  csr_addr_reg = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  csr_cmd_reg = _RAND_10[2:0];
  _RAND_11 = {1{`RANDOM}};
  imm_b_sext_reg = _RAND_11[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MemAccess(
  input         clock,
  input         reset,
  input  [31:0] io_extend_exe_pc_reg,
  input  [4:0]  io_extend_wb_addr,
  input  [31:0] io_extend_op1_data,
  input  [31:0] io_extend_rs2_data,
  input  [1:0]  io_extend_mem_wen,
  input  [1:0]  io_extend_reg_wen,
  input  [2:0]  io_extend_wb_sel,
  input  [11:0] io_extend_csr_addr,
  input  [2:0]  io_extend_csr_cmd,
  input  [31:0] io_extend_alu_out,
  output [11:0] io_csr_read_reg_raddr,
  input  [31:0] io_csr_read_reg_rdata,
  output [11:0] io_csr_write_reg_waddr,
  output [31:0] io_csr_write_reg_wdata,
  output        io_csr_write_wen,
  output [31:0] io_mem_write_waddr,
  output [31:0] io_mem_write_wdata,
  output        io_mem_write_write_en,
  output [31:0] io_mem_read_raddr,
  input  [31:0] io_mem_read_rdata,
  output [4:0]  io_passby_reg_wb_addr,
  output [1:0]  io_passby_reg_wen,
  output [31:0] io_passby_reg_wb_data
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] mem_pc_reg; // @[MemAccess.scala 17:27]
  reg [4:0] wb_addr_reg; // @[MemAccess.scala 18:28]
  reg [31:0] op1_data_reg; // @[MemAccess.scala 19:29]
  reg [31:0] rs2_data_reg; // @[MemAccess.scala 20:29]
  reg [1:0] mem_wen_reg; // @[MemAccess.scala 21:28]
  reg [1:0] reg_wen_reg; // @[MemAccess.scala 22:28]
  reg [2:0] wb_sel_reg; // @[MemAccess.scala 23:27]
  reg [11:0] csr_addr_reg; // @[MemAccess.scala 24:29]
  reg [2:0] csr_cmd_reg; // @[MemAccess.scala 25:28]
  reg [31:0] alu_out_reg; // @[MemAccess.scala 27:28]
  wire  _io_csr_write_reg_wdata_T = csr_cmd_reg == 3'h1; // @[MemAccess.scala 55:18]
  wire  _io_csr_write_reg_wdata_T_1 = csr_cmd_reg == 3'h2; // @[MemAccess.scala 56:18]
  wire [31:0] _io_csr_write_reg_wdata_T_2 = op1_data_reg | io_csr_read_reg_rdata; // @[MemAccess.scala 56:46]
  wire  _io_csr_write_reg_wdata_T_3 = csr_cmd_reg == 3'h3; // @[MemAccess.scala 57:18]
  wire [31:0] _io_csr_write_reg_wdata_T_4 = ~op1_data_reg; // @[MemAccess.scala 57:34]
  wire [31:0] _io_csr_write_reg_wdata_T_5 = _io_csr_write_reg_wdata_T_4 & io_csr_read_reg_rdata; // @[MemAccess.scala 57:56]
  wire  _io_csr_write_reg_wdata_T_6 = csr_cmd_reg == 3'h4; // @[MemAccess.scala 58:18]
  wire [31:0] _io_csr_write_reg_wdata_T_7 = _io_csr_write_reg_wdata_T_6 ? 32'hb : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _io_csr_write_reg_wdata_T_8 = _io_csr_write_reg_wdata_T_3 ? _io_csr_write_reg_wdata_T_5 :
    _io_csr_write_reg_wdata_T_7; // @[Mux.scala 101:16]
  wire [31:0] _io_csr_write_reg_wdata_T_9 = _io_csr_write_reg_wdata_T_1 ? _io_csr_write_reg_wdata_T_2 :
    _io_csr_write_reg_wdata_T_8; // @[Mux.scala 101:16]
  wire  _mem_wb_data_T = wb_sel_reg == 3'h2; // @[MemAccess.scala 67:17]
  wire  _mem_wb_data_T_1 = wb_sel_reg == 3'h3; // @[MemAccess.scala 68:17]
  wire [31:0] _mem_wb_data_T_3 = mem_pc_reg + 32'h4; // @[MemAccess.scala 68:43]
  wire  _mem_wb_data_T_4 = wb_sel_reg == 3'h4; // @[MemAccess.scala 69:17]
  wire [31:0] _mem_wb_data_T_5 = _mem_wb_data_T_4 ? io_csr_read_reg_rdata : alu_out_reg; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_6 = _mem_wb_data_T_1 ? _mem_wb_data_T_3 : _mem_wb_data_T_5; // @[Mux.scala 101:16]
  assign io_csr_read_reg_raddr = csr_addr_reg; // @[MemAccess.scala 50:25]
  assign io_csr_write_reg_waddr = csr_addr_reg; // @[MemAccess.scala 52:26]
  assign io_csr_write_reg_wdata = _io_csr_write_reg_wdata_T ? op1_data_reg : _io_csr_write_reg_wdata_T_9; // @[Mux.scala 101:16]
  assign io_csr_write_wen = csr_cmd_reg > 3'h0; // @[MemAccess.scala 60:20]
  assign io_mem_write_waddr = alu_out_reg; // @[MemAccess.scala 43:22]
  assign io_mem_write_wdata = rs2_data_reg; // @[MemAccess.scala 45:22]
  assign io_mem_write_write_en = mem_wen_reg[0]; // @[MemAccess.scala 44:25]
  assign io_mem_read_raddr = alu_out_reg; // @[MemAccess.scala 46:21]
  assign io_passby_reg_wb_addr = wb_addr_reg; // @[MemAccess.scala 73:25]
  assign io_passby_reg_wen = reg_wen_reg; // @[MemAccess.scala 74:21]
  assign io_passby_reg_wb_data = _mem_wb_data_T ? io_mem_read_rdata : _mem_wb_data_T_6; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (reset) begin // @[MemAccess.scala 17:27]
      mem_pc_reg <= 32'h0; // @[MemAccess.scala 17:27]
    end else begin
      mem_pc_reg <= io_extend_exe_pc_reg; // @[MemAccess.scala 29:14]
    end
    if (reset) begin // @[MemAccess.scala 18:28]
      wb_addr_reg <= 5'h0; // @[MemAccess.scala 18:28]
    end else begin
      wb_addr_reg <= io_extend_wb_addr; // @[MemAccess.scala 30:15]
    end
    if (reset) begin // @[MemAccess.scala 19:29]
      op1_data_reg <= 32'h0; // @[MemAccess.scala 19:29]
    end else begin
      op1_data_reg <= io_extend_op1_data; // @[MemAccess.scala 31:16]
    end
    if (reset) begin // @[MemAccess.scala 20:29]
      rs2_data_reg <= 32'h0; // @[MemAccess.scala 20:29]
    end else begin
      rs2_data_reg <= io_extend_rs2_data; // @[MemAccess.scala 32:16]
    end
    if (reset) begin // @[MemAccess.scala 21:28]
      mem_wen_reg <= 2'h0; // @[MemAccess.scala 21:28]
    end else begin
      mem_wen_reg <= io_extend_mem_wen; // @[MemAccess.scala 33:15]
    end
    if (reset) begin // @[MemAccess.scala 22:28]
      reg_wen_reg <= 2'h0; // @[MemAccess.scala 22:28]
    end else begin
      reg_wen_reg <= io_extend_reg_wen; // @[MemAccess.scala 35:15]
    end
    if (reset) begin // @[MemAccess.scala 23:27]
      wb_sel_reg <= 3'h0; // @[MemAccess.scala 23:27]
    end else begin
      wb_sel_reg <= io_extend_wb_sel; // @[MemAccess.scala 36:14]
    end
    if (reset) begin // @[MemAccess.scala 24:29]
      csr_addr_reg <= 12'h0; // @[MemAccess.scala 24:29]
    end else begin
      csr_addr_reg <= io_extend_csr_addr; // @[MemAccess.scala 37:16]
    end
    if (reset) begin // @[MemAccess.scala 25:28]
      csr_cmd_reg <= 3'h0; // @[MemAccess.scala 25:28]
    end else begin
      csr_cmd_reg <= io_extend_csr_cmd; // @[MemAccess.scala 38:15]
    end
    if (reset) begin // @[MemAccess.scala 27:28]
      alu_out_reg <= 32'h0; // @[MemAccess.scala 27:28]
    end else begin
      alu_out_reg <= io_extend_alu_out; // @[MemAccess.scala 40:15]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  mem_pc_reg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  wb_addr_reg = _RAND_1[4:0];
  _RAND_2 = {1{`RANDOM}};
  op1_data_reg = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  rs2_data_reg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  mem_wen_reg = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  reg_wen_reg = _RAND_5[1:0];
  _RAND_6 = {1{`RANDOM}};
  wb_sel_reg = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  csr_addr_reg = _RAND_7[11:0];
  _RAND_8 = {1{`RANDOM}};
  csr_cmd_reg = _RAND_8[2:0];
  _RAND_9 = {1{`RANDOM}};
  alu_out_reg = _RAND_9[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WriteBack(
  input         clock,
  input         reset,
  input  [4:0]  io_extend_reg_wb_addr,
  input  [1:0]  io_extend_reg_wen,
  input  [31:0] io_extend_reg_wb_data,
  output [31:0] io_regIO_reg_waddr,
  output [31:0] io_regIO_reg_wdata,
  output        io_regIO_wen
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] reg_wen_reg; // @[WriteBack.scala 13:28]
  reg [4:0] wb_addr_reg; // @[WriteBack.scala 14:28]
  reg [31:0] wb_data_reg; // @[WriteBack.scala 15:28]
  assign io_regIO_reg_waddr = {{27'd0}, wb_addr_reg}; // @[WriteBack.scala 22:22]
  assign io_regIO_reg_wdata = wb_data_reg; // @[WriteBack.scala 23:22]
  assign io_regIO_wen = reg_wen_reg == 2'h1; // @[WriteBack.scala 24:20]
  always @(posedge clock) begin
    if (reset) begin // @[WriteBack.scala 13:28]
      reg_wen_reg <= 2'h0; // @[WriteBack.scala 13:28]
    end else begin
      reg_wen_reg <= io_extend_reg_wen; // @[WriteBack.scala 18:15]
    end
    if (reset) begin // @[WriteBack.scala 14:28]
      wb_addr_reg <= 5'h0; // @[WriteBack.scala 14:28]
    end else begin
      wb_addr_reg <= io_extend_reg_wb_addr; // @[WriteBack.scala 19:15]
    end
    if (reset) begin // @[WriteBack.scala 15:28]
      wb_data_reg <= 32'h0; // @[WriteBack.scala 15:28]
    end else begin
      wb_data_reg <= io_extend_reg_wb_data; // @[WriteBack.scala 20:15]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_wen_reg = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  wb_addr_reg = _RAND_1[4:0];
  _RAND_2 = {1{`RANDOM}};
  wb_data_reg = _RAND_2[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Regs(
  input         clock,
  input  [4:0]  io_regReadIO_reg_raddr1,
  input  [4:0]  io_regReadIO_reg_raddr2,
  output [31:0] io_regReadIO_reg_rdata1,
  output [31:0] io_regReadIO_reg_rdata2,
  input  [4:0]  io_regWriteIO_reg_waddr,
  input  [31:0] io_regWriteIO_reg_wdata,
  input         io_regWriteIO_wen,
  output [31:0] io_probe
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [31:0] registers [0:31]; // @[Regs.scala 13:22]
  wire  registers_io_regReadIO_reg_rdata1_MPORT_en; // @[Regs.scala 13:22]
  wire [4:0] registers_io_regReadIO_reg_rdata1_MPORT_addr; // @[Regs.scala 13:22]
  wire [31:0] registers_io_regReadIO_reg_rdata1_MPORT_data; // @[Regs.scala 13:22]
  wire  registers_io_regReadIO_reg_rdata2_MPORT_en; // @[Regs.scala 13:22]
  wire [4:0] registers_io_regReadIO_reg_rdata2_MPORT_addr; // @[Regs.scala 13:22]
  wire [31:0] registers_io_regReadIO_reg_rdata2_MPORT_data; // @[Regs.scala 13:22]
  wire  registers_io_probe_MPORT_en; // @[Regs.scala 13:22]
  wire [4:0] registers_io_probe_MPORT_addr; // @[Regs.scala 13:22]
  wire [31:0] registers_io_probe_MPORT_data; // @[Regs.scala 13:22]
  wire [31:0] registers_MPORT_data; // @[Regs.scala 13:22]
  wire [4:0] registers_MPORT_addr; // @[Regs.scala 13:22]
  wire  registers_MPORT_mask; // @[Regs.scala 13:22]
  wire  registers_MPORT_en; // @[Regs.scala 13:22]
  assign registers_io_regReadIO_reg_rdata1_MPORT_en = 1'h1;
  assign registers_io_regReadIO_reg_rdata1_MPORT_addr = io_regReadIO_reg_raddr1;
  assign registers_io_regReadIO_reg_rdata1_MPORT_data = registers[registers_io_regReadIO_reg_rdata1_MPORT_addr]; // @[Regs.scala 13:22]
  assign registers_io_regReadIO_reg_rdata2_MPORT_en = 1'h1;
  assign registers_io_regReadIO_reg_rdata2_MPORT_addr = io_regReadIO_reg_raddr2;
  assign registers_io_regReadIO_reg_rdata2_MPORT_data = registers[registers_io_regReadIO_reg_rdata2_MPORT_addr]; // @[Regs.scala 13:22]
  assign registers_io_probe_MPORT_en = 1'h1;
  assign registers_io_probe_MPORT_addr = 5'h6;
  assign registers_io_probe_MPORT_data = registers[registers_io_probe_MPORT_addr]; // @[Regs.scala 13:22]
  assign registers_MPORT_data = io_regWriteIO_reg_wdata;
  assign registers_MPORT_addr = io_regWriteIO_reg_waddr;
  assign registers_MPORT_mask = 1'h1;
  assign registers_MPORT_en = io_regWriteIO_wen;
  assign io_regReadIO_reg_rdata1 = registers_io_regReadIO_reg_rdata1_MPORT_data; // @[Regs.scala 15:27]
  assign io_regReadIO_reg_rdata2 = registers_io_regReadIO_reg_rdata2_MPORT_data; // @[Regs.scala 16:27]
  assign io_probe = registers_io_probe_MPORT_data; // @[Regs.scala 22:12]
  always @(posedge clock) begin
    if (registers_MPORT_en & registers_MPORT_mask) begin
      registers[registers_MPORT_addr] <= registers_MPORT_data; // @[Regs.scala 13:22]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    registers[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CSR(
  input         clock,
  output [31:0] io_read1IO_reg_rdata,
  input  [11:0] io_read2IO_reg_raddr,
  output [31:0] io_read2IO_reg_rdata,
  input  [11:0] io_writeIO_reg_waddr,
  input  [31:0] io_writeIO_reg_wdata,
  input         io_writeIO_wen
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [31:0] csr_register [0:4095]; // @[CSR.scala 12:25]
  wire  csr_register_io_read1IO_reg_rdata_MPORT_en; // @[CSR.scala 12:25]
  wire [11:0] csr_register_io_read1IO_reg_rdata_MPORT_addr; // @[CSR.scala 12:25]
  wire [31:0] csr_register_io_read1IO_reg_rdata_MPORT_data; // @[CSR.scala 12:25]
  wire  csr_register_io_read2IO_reg_rdata_MPORT_en; // @[CSR.scala 12:25]
  wire [11:0] csr_register_io_read2IO_reg_rdata_MPORT_addr; // @[CSR.scala 12:25]
  wire [31:0] csr_register_io_read2IO_reg_rdata_MPORT_data; // @[CSR.scala 12:25]
  wire [31:0] csr_register_MPORT_data; // @[CSR.scala 12:25]
  wire [11:0] csr_register_MPORT_addr; // @[CSR.scala 12:25]
  wire  csr_register_MPORT_mask; // @[CSR.scala 12:25]
  wire  csr_register_MPORT_en; // @[CSR.scala 12:25]
  assign csr_register_io_read1IO_reg_rdata_MPORT_en = 1'h1;
  assign csr_register_io_read1IO_reg_rdata_MPORT_addr = 12'h305;
  assign csr_register_io_read1IO_reg_rdata_MPORT_data = csr_register[csr_register_io_read1IO_reg_rdata_MPORT_addr]; // @[CSR.scala 12:25]
  assign csr_register_io_read2IO_reg_rdata_MPORT_en = 1'h1;
  assign csr_register_io_read2IO_reg_rdata_MPORT_addr = io_read2IO_reg_raddr;
  assign csr_register_io_read2IO_reg_rdata_MPORT_data = csr_register[csr_register_io_read2IO_reg_rdata_MPORT_addr]; // @[CSR.scala 12:25]
  assign csr_register_MPORT_data = io_writeIO_reg_wdata;
  assign csr_register_MPORT_addr = io_writeIO_reg_waddr;
  assign csr_register_MPORT_mask = 1'h1;
  assign csr_register_MPORT_en = io_writeIO_wen;
  assign io_read1IO_reg_rdata = csr_register_io_read1IO_reg_rdata_MPORT_data; // @[CSR.scala 14:24]
  assign io_read2IO_reg_rdata = csr_register_io_read2IO_reg_rdata_MPORT_data; // @[CSR.scala 15:24]
  always @(posedge clock) begin
    if (csr_register_MPORT_en & csr_register_MPORT_mask) begin
      csr_register[csr_register_MPORT_addr] <= csr_register_MPORT_data; // @[CSR.scala 12:25]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    csr_register[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Memory(
  input         clock,
  input         reset,
  input  [31:0] io_imem_inst_addr,
  output [31:0] io_imem_inst_o,
  input  [31:0] io_aread_raddr,
  output [31:0] io_aread_rdata,
  input  [31:0] io_awrite_waddr,
  input  [31:0] io_awrite_wdata,
  input         io_awrite_write_en
);
  reg [7:0] mem [0:16383]; // @[Memory.scala 13:16]
  wire  mem_io_imem_inst_o_MPORT_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_imem_inst_o_MPORT_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_imem_inst_o_MPORT_data; // @[Memory.scala 13:16]
  wire  mem_io_imem_inst_o_MPORT_1_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_imem_inst_o_MPORT_1_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_imem_inst_o_MPORT_1_data; // @[Memory.scala 13:16]
  wire  mem_io_imem_inst_o_MPORT_2_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_imem_inst_o_MPORT_2_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_imem_inst_o_MPORT_2_data; // @[Memory.scala 13:16]
  wire  mem_io_imem_inst_o_MPORT_3_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_imem_inst_o_MPORT_3_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_imem_inst_o_MPORT_3_data; // @[Memory.scala 13:16]
  wire  mem_io_aread_rdata_MPORT_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_aread_rdata_MPORT_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_aread_rdata_MPORT_data; // @[Memory.scala 13:16]
  wire  mem_io_aread_rdata_MPORT_1_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_aread_rdata_MPORT_1_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_aread_rdata_MPORT_1_data; // @[Memory.scala 13:16]
  wire  mem_io_aread_rdata_MPORT_2_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_aread_rdata_MPORT_2_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_aread_rdata_MPORT_2_data; // @[Memory.scala 13:16]
  wire  mem_io_aread_rdata_MPORT_3_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_aread_rdata_MPORT_3_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_aread_rdata_MPORT_3_data; // @[Memory.scala 13:16]
  wire [7:0] mem_MPORT_data; // @[Memory.scala 13:16]
  wire [13:0] mem_MPORT_addr; // @[Memory.scala 13:16]
  wire  mem_MPORT_mask; // @[Memory.scala 13:16]
  wire  mem_MPORT_en; // @[Memory.scala 13:16]
  wire [7:0] mem_MPORT_1_data; // @[Memory.scala 13:16]
  wire [13:0] mem_MPORT_1_addr; // @[Memory.scala 13:16]
  wire  mem_MPORT_1_mask; // @[Memory.scala 13:16]
  wire  mem_MPORT_1_en; // @[Memory.scala 13:16]
  wire [7:0] mem_MPORT_2_data; // @[Memory.scala 13:16]
  wire [13:0] mem_MPORT_2_addr; // @[Memory.scala 13:16]
  wire  mem_MPORT_2_mask; // @[Memory.scala 13:16]
  wire  mem_MPORT_2_en; // @[Memory.scala 13:16]
  wire [7:0] mem_MPORT_3_data; // @[Memory.scala 13:16]
  wire [13:0] mem_MPORT_3_addr; // @[Memory.scala 13:16]
  wire  mem_MPORT_3_mask; // @[Memory.scala 13:16]
  wire  mem_MPORT_3_en; // @[Memory.scala 13:16]
  wire [31:0] _io_imem_inst_o_T_1 = io_imem_inst_addr + 32'h3; // @[Memory.scala 18:49]
  wire [31:0] _io_imem_inst_o_T_4 = io_imem_inst_addr + 32'h2; // @[Memory.scala 19:29]
  wire [31:0] _io_imem_inst_o_T_7 = io_imem_inst_addr + 32'h1; // @[Memory.scala 20:29]
  wire [31:0] _io_imem_inst_o_T_10 = {mem_io_imem_inst_o_MPORT_data,mem_io_imem_inst_o_MPORT_1_data,
    mem_io_imem_inst_o_MPORT_2_data,mem_io_imem_inst_o_MPORT_3_data}; // @[Cat.scala 31:58]
  wire [31:0] _io_aread_rdata_T_1 = io_aread_raddr + 32'h3; // @[Memory.scala 24:44]
  wire [31:0] _io_aread_rdata_T_4 = io_aread_raddr + 32'h2; // @[Memory.scala 25:24]
  wire [31:0] _io_aread_rdata_T_7 = io_aread_raddr + 32'h1; // @[Memory.scala 26:24]
  wire [15:0] io_aread_rdata_lo = {mem_io_aread_rdata_MPORT_2_data,mem_io_aread_rdata_MPORT_3_data}; // @[Cat.scala 31:58]
  wire [15:0] io_aread_rdata_hi = {mem_io_aread_rdata_MPORT_data,mem_io_aread_rdata_MPORT_1_data}; // @[Cat.scala 31:58]
  wire [31:0] _T_2 = io_awrite_waddr + 32'h3; // @[Memory.scala 30:25]
  wire [31:0] _T_6 = io_awrite_waddr + 32'h2; // @[Memory.scala 31:25]
  wire [31:0] _T_10 = io_awrite_waddr + 32'h1; // @[Memory.scala 32:25]
  assign mem_io_imem_inst_o_MPORT_en = reset ? 1'h0 : 1'h1;
  assign mem_io_imem_inst_o_MPORT_addr = _io_imem_inst_o_T_1[13:0];
  assign mem_io_imem_inst_o_MPORT_data = mem[mem_io_imem_inst_o_MPORT_addr]; // @[Memory.scala 13:16]
  assign mem_io_imem_inst_o_MPORT_1_en = reset ? 1'h0 : 1'h1;
  assign mem_io_imem_inst_o_MPORT_1_addr = _io_imem_inst_o_T_4[13:0];
  assign mem_io_imem_inst_o_MPORT_1_data = mem[mem_io_imem_inst_o_MPORT_1_addr]; // @[Memory.scala 13:16]
  assign mem_io_imem_inst_o_MPORT_2_en = reset ? 1'h0 : 1'h1;
  assign mem_io_imem_inst_o_MPORT_2_addr = _io_imem_inst_o_T_7[13:0];
  assign mem_io_imem_inst_o_MPORT_2_data = mem[mem_io_imem_inst_o_MPORT_2_addr]; // @[Memory.scala 13:16]
  assign mem_io_imem_inst_o_MPORT_3_en = reset ? 1'h0 : 1'h1;
  assign mem_io_imem_inst_o_MPORT_3_addr = io_imem_inst_addr[13:0];
  assign mem_io_imem_inst_o_MPORT_3_data = mem[mem_io_imem_inst_o_MPORT_3_addr]; // @[Memory.scala 13:16]
  assign mem_io_aread_rdata_MPORT_en = 1'h1;
  assign mem_io_aread_rdata_MPORT_addr = _io_aread_rdata_T_1[13:0];
  assign mem_io_aread_rdata_MPORT_data = mem[mem_io_aread_rdata_MPORT_addr]; // @[Memory.scala 13:16]
  assign mem_io_aread_rdata_MPORT_1_en = 1'h1;
  assign mem_io_aread_rdata_MPORT_1_addr = _io_aread_rdata_T_4[13:0];
  assign mem_io_aread_rdata_MPORT_1_data = mem[mem_io_aread_rdata_MPORT_1_addr]; // @[Memory.scala 13:16]
  assign mem_io_aread_rdata_MPORT_2_en = 1'h1;
  assign mem_io_aread_rdata_MPORT_2_addr = _io_aread_rdata_T_7[13:0];
  assign mem_io_aread_rdata_MPORT_2_data = mem[mem_io_aread_rdata_MPORT_2_addr]; // @[Memory.scala 13:16]
  assign mem_io_aread_rdata_MPORT_3_en = 1'h1;
  assign mem_io_aread_rdata_MPORT_3_addr = io_aread_raddr[13:0];
  assign mem_io_aread_rdata_MPORT_3_data = mem[mem_io_aread_rdata_MPORT_3_addr]; // @[Memory.scala 13:16]
  assign mem_MPORT_data = io_awrite_wdata[31:24];
  assign mem_MPORT_addr = _T_2[13:0];
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_awrite_write_en;
  assign mem_MPORT_1_data = io_awrite_wdata[23:16];
  assign mem_MPORT_1_addr = _T_6[13:0];
  assign mem_MPORT_1_mask = 1'h1;
  assign mem_MPORT_1_en = io_awrite_write_en;
  assign mem_MPORT_2_data = io_awrite_wdata[15:8];
  assign mem_MPORT_2_addr = _T_10[13:0];
  assign mem_MPORT_2_mask = 1'h1;
  assign mem_MPORT_2_en = io_awrite_write_en;
  assign mem_MPORT_3_data = io_awrite_wdata[7:0];
  assign mem_MPORT_3_addr = io_awrite_waddr[13:0];
  assign mem_MPORT_3_mask = 1'h1;
  assign mem_MPORT_3_en = io_awrite_write_en;
  assign io_imem_inst_o = reset ? 32'h0 : _io_imem_inst_o_T_10; // @[Memory.scala 15:21 16:20 18:20]
  assign io_aread_rdata = {io_aread_rdata_hi,io_aread_rdata_lo}; // @[Cat.scala 31:58]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[Memory.scala 13:16]
    end
    if (mem_MPORT_1_en & mem_MPORT_1_mask) begin
      mem[mem_MPORT_1_addr] <= mem_MPORT_1_data; // @[Memory.scala 13:16]
    end
    if (mem_MPORT_2_en & mem_MPORT_2_mask) begin
      mem[mem_MPORT_2_addr] <= mem_MPORT_2_data; // @[Memory.scala 13:16]
    end
    if (mem_MPORT_3_en & mem_MPORT_3_mask) begin
      mem[mem_MPORT_3_addr] <= mem_MPORT_3_data; // @[Memory.scala 13:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
  integer initvar;
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `endif // RANDOMIZE
  $readmemh("memoryFile.hex", mem);
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  output [31:0] io_probe,
  output        io_exit
);
  wire  module_inst_fetch_clock; // @[Top.scala 12:33]
  wire  module_inst_fetch_reset; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_inst_mem_inst_addr; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_inst_mem_inst_o; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_csr_read_reg_rdata; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_exio_alu_out; // @[Top.scala 12:33]
  wire  module_inst_fetch_io_exio_br_flag; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_exio_br_target; // @[Top.scala 12:33]
  wire  module_inst_fetch_io_exio_jmp_flag; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_passby_if_pc_reg; // @[Top.scala 12:33]
  wire [31:0] module_inst_fetch_io_passby_if_inst; // @[Top.scala 12:33]
  wire  module_decode_clock; // @[Top.scala 13:29]
  wire  module_decode_reset; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_extend_if_inst; // @[Top.scala 13:29]
  wire [4:0] module_decode_io_regs_reg_raddr1; // @[Top.scala 13:29]
  wire [4:0] module_decode_io_regs_reg_raddr2; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_regs_reg_rdata1; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_regs_reg_rdata2; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_passby_id_pc_reg; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_passby_imm_b_sext; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_passby_op1_data; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_passby_op2_data; // @[Top.scala 13:29]
  wire [31:0] module_decode_io_passby_rs2_data; // @[Top.scala 13:29]
  wire [4:0] module_decode_io_passby_wb_addr; // @[Top.scala 13:29]
  wire [4:0] module_decode_io_passby_exe_fun; // @[Top.scala 13:29]
  wire [1:0] module_decode_io_passby_mem_wen; // @[Top.scala 13:29]
  wire [1:0] module_decode_io_passby_reg_wen; // @[Top.scala 13:29]
  wire [2:0] module_decode_io_passby_wb_sel; // @[Top.scala 13:29]
  wire [2:0] module_decode_io_passby_csr_cmd; // @[Top.scala 13:29]
  wire [11:0] module_decode_io_passby_csr_addr; // @[Top.scala 13:29]
  wire  module_execute_clock; // @[Top.scala 14:30]
  wire  module_execute_reset; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_extend_id_pc_reg; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_extend_imm_b_sext; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_extend_op1_data; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_extend_op2_data; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_extend_rs2_data; // @[Top.scala 14:30]
  wire [4:0] module_execute_io_extend_wb_addr; // @[Top.scala 14:30]
  wire [4:0] module_execute_io_extend_exe_fun; // @[Top.scala 14:30]
  wire [1:0] module_execute_io_extend_mem_wen; // @[Top.scala 14:30]
  wire [1:0] module_execute_io_extend_reg_wen; // @[Top.scala 14:30]
  wire [2:0] module_execute_io_extend_wb_sel; // @[Top.scala 14:30]
  wire [2:0] module_execute_io_extend_csr_cmd; // @[Top.scala 14:30]
  wire [11:0] module_execute_io_extend_csr_addr; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_exifIO_alu_out; // @[Top.scala 14:30]
  wire  module_execute_io_exifIO_br_flag; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_exifIO_br_target; // @[Top.scala 14:30]
  wire  module_execute_io_exifIO_jmp_flag; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_passby_exe_pc_reg; // @[Top.scala 14:30]
  wire [4:0] module_execute_io_passby_wb_addr; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_passby_op1_data; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_passby_rs2_data; // @[Top.scala 14:30]
  wire [1:0] module_execute_io_passby_mem_wen; // @[Top.scala 14:30]
  wire [1:0] module_execute_io_passby_reg_wen; // @[Top.scala 14:30]
  wire [2:0] module_execute_io_passby_wb_sel; // @[Top.scala 14:30]
  wire [11:0] module_execute_io_passby_csr_addr; // @[Top.scala 14:30]
  wire [2:0] module_execute_io_passby_csr_cmd; // @[Top.scala 14:30]
  wire [31:0] module_execute_io_passby_alu_out; // @[Top.scala 14:30]
  wire  module_memory_access_clock; // @[Top.scala 15:36]
  wire  module_memory_access_reset; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_extend_exe_pc_reg; // @[Top.scala 15:36]
  wire [4:0] module_memory_access_io_extend_wb_addr; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_extend_op1_data; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_extend_rs2_data; // @[Top.scala 15:36]
  wire [1:0] module_memory_access_io_extend_mem_wen; // @[Top.scala 15:36]
  wire [1:0] module_memory_access_io_extend_reg_wen; // @[Top.scala 15:36]
  wire [2:0] module_memory_access_io_extend_wb_sel; // @[Top.scala 15:36]
  wire [11:0] module_memory_access_io_extend_csr_addr; // @[Top.scala 15:36]
  wire [2:0] module_memory_access_io_extend_csr_cmd; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_extend_alu_out; // @[Top.scala 15:36]
  wire [11:0] module_memory_access_io_csr_read_reg_raddr; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_csr_read_reg_rdata; // @[Top.scala 15:36]
  wire [11:0] module_memory_access_io_csr_write_reg_waddr; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_csr_write_reg_wdata; // @[Top.scala 15:36]
  wire  module_memory_access_io_csr_write_wen; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_mem_write_waddr; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_mem_write_wdata; // @[Top.scala 15:36]
  wire  module_memory_access_io_mem_write_write_en; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_mem_read_raddr; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_mem_read_rdata; // @[Top.scala 15:36]
  wire [4:0] module_memory_access_io_passby_reg_wb_addr; // @[Top.scala 15:36]
  wire [1:0] module_memory_access_io_passby_reg_wen; // @[Top.scala 15:36]
  wire [31:0] module_memory_access_io_passby_reg_wb_data; // @[Top.scala 15:36]
  wire  module_write_back_clock; // @[Top.scala 16:33]
  wire  module_write_back_reset; // @[Top.scala 16:33]
  wire [4:0] module_write_back_io_extend_reg_wb_addr; // @[Top.scala 16:33]
  wire [1:0] module_write_back_io_extend_reg_wen; // @[Top.scala 16:33]
  wire [31:0] module_write_back_io_extend_reg_wb_data; // @[Top.scala 16:33]
  wire [31:0] module_write_back_io_regIO_reg_waddr; // @[Top.scala 16:33]
  wire [31:0] module_write_back_io_regIO_reg_wdata; // @[Top.scala 16:33]
  wire  module_write_back_io_regIO_wen; // @[Top.scala 16:33]
  wire  module_reg_clock; // @[Top.scala 18:26]
  wire [4:0] module_reg_io_regReadIO_reg_raddr1; // @[Top.scala 18:26]
  wire [4:0] module_reg_io_regReadIO_reg_raddr2; // @[Top.scala 18:26]
  wire [31:0] module_reg_io_regReadIO_reg_rdata1; // @[Top.scala 18:26]
  wire [31:0] module_reg_io_regReadIO_reg_rdata2; // @[Top.scala 18:26]
  wire [4:0] module_reg_io_regWriteIO_reg_waddr; // @[Top.scala 18:26]
  wire [31:0] module_reg_io_regWriteIO_reg_wdata; // @[Top.scala 18:26]
  wire  module_reg_io_regWriteIO_wen; // @[Top.scala 18:26]
  wire [31:0] module_reg_io_probe; // @[Top.scala 18:26]
  wire  module_csr_clock; // @[Top.scala 19:26]
  wire [31:0] module_csr_io_read1IO_reg_rdata; // @[Top.scala 19:26]
  wire [11:0] module_csr_io_read2IO_reg_raddr; // @[Top.scala 19:26]
  wire [31:0] module_csr_io_read2IO_reg_rdata; // @[Top.scala 19:26]
  wire [11:0] module_csr_io_writeIO_reg_waddr; // @[Top.scala 19:26]
  wire [31:0] module_csr_io_writeIO_reg_wdata; // @[Top.scala 19:26]
  wire  module_csr_io_writeIO_wen; // @[Top.scala 19:26]
  wire  module_memory_clock; // @[Top.scala 20:29]
  wire  module_memory_reset; // @[Top.scala 20:29]
  wire [31:0] module_memory_io_imem_inst_addr; // @[Top.scala 20:29]
  wire [31:0] module_memory_io_imem_inst_o; // @[Top.scala 20:29]
  wire [31:0] module_memory_io_aread_raddr; // @[Top.scala 20:29]
  wire [31:0] module_memory_io_aread_rdata; // @[Top.scala 20:29]
  wire [31:0] module_memory_io_awrite_waddr; // @[Top.scala 20:29]
  wire [31:0] module_memory_io_awrite_wdata; // @[Top.scala 20:29]
  wire  module_memory_io_awrite_write_en; // @[Top.scala 20:29]
  wire  _T_1 = ~reset; // @[Top.scala 50:9]
  InstFetch module_inst_fetch ( // @[Top.scala 12:33]
    .clock(module_inst_fetch_clock),
    .reset(module_inst_fetch_reset),
    .io_inst_mem_inst_addr(module_inst_fetch_io_inst_mem_inst_addr),
    .io_inst_mem_inst_o(module_inst_fetch_io_inst_mem_inst_o),
    .io_csr_read_reg_rdata(module_inst_fetch_io_csr_read_reg_rdata),
    .io_exio_alu_out(module_inst_fetch_io_exio_alu_out),
    .io_exio_br_flag(module_inst_fetch_io_exio_br_flag),
    .io_exio_br_target(module_inst_fetch_io_exio_br_target),
    .io_exio_jmp_flag(module_inst_fetch_io_exio_jmp_flag),
    .io_passby_if_pc_reg(module_inst_fetch_io_passby_if_pc_reg),
    .io_passby_if_inst(module_inst_fetch_io_passby_if_inst)
  );
  Decode module_decode ( // @[Top.scala 13:29]
    .clock(module_decode_clock),
    .reset(module_decode_reset),
    .io_extend_if_inst(module_decode_io_extend_if_inst),
    .io_regs_reg_raddr1(module_decode_io_regs_reg_raddr1),
    .io_regs_reg_raddr2(module_decode_io_regs_reg_raddr2),
    .io_regs_reg_rdata1(module_decode_io_regs_reg_rdata1),
    .io_regs_reg_rdata2(module_decode_io_regs_reg_rdata2),
    .io_passby_id_pc_reg(module_decode_io_passby_id_pc_reg),
    .io_passby_imm_b_sext(module_decode_io_passby_imm_b_sext),
    .io_passby_op1_data(module_decode_io_passby_op1_data),
    .io_passby_op2_data(module_decode_io_passby_op2_data),
    .io_passby_rs2_data(module_decode_io_passby_rs2_data),
    .io_passby_wb_addr(module_decode_io_passby_wb_addr),
    .io_passby_exe_fun(module_decode_io_passby_exe_fun),
    .io_passby_mem_wen(module_decode_io_passby_mem_wen),
    .io_passby_reg_wen(module_decode_io_passby_reg_wen),
    .io_passby_wb_sel(module_decode_io_passby_wb_sel),
    .io_passby_csr_cmd(module_decode_io_passby_csr_cmd),
    .io_passby_csr_addr(module_decode_io_passby_csr_addr)
  );
  Execute module_execute ( // @[Top.scala 14:30]
    .clock(module_execute_clock),
    .reset(module_execute_reset),
    .io_extend_id_pc_reg(module_execute_io_extend_id_pc_reg),
    .io_extend_imm_b_sext(module_execute_io_extend_imm_b_sext),
    .io_extend_op1_data(module_execute_io_extend_op1_data),
    .io_extend_op2_data(module_execute_io_extend_op2_data),
    .io_extend_rs2_data(module_execute_io_extend_rs2_data),
    .io_extend_wb_addr(module_execute_io_extend_wb_addr),
    .io_extend_exe_fun(module_execute_io_extend_exe_fun),
    .io_extend_mem_wen(module_execute_io_extend_mem_wen),
    .io_extend_reg_wen(module_execute_io_extend_reg_wen),
    .io_extend_wb_sel(module_execute_io_extend_wb_sel),
    .io_extend_csr_cmd(module_execute_io_extend_csr_cmd),
    .io_extend_csr_addr(module_execute_io_extend_csr_addr),
    .io_exifIO_alu_out(module_execute_io_exifIO_alu_out),
    .io_exifIO_br_flag(module_execute_io_exifIO_br_flag),
    .io_exifIO_br_target(module_execute_io_exifIO_br_target),
    .io_exifIO_jmp_flag(module_execute_io_exifIO_jmp_flag),
    .io_passby_exe_pc_reg(module_execute_io_passby_exe_pc_reg),
    .io_passby_wb_addr(module_execute_io_passby_wb_addr),
    .io_passby_op1_data(module_execute_io_passby_op1_data),
    .io_passby_rs2_data(module_execute_io_passby_rs2_data),
    .io_passby_mem_wen(module_execute_io_passby_mem_wen),
    .io_passby_reg_wen(module_execute_io_passby_reg_wen),
    .io_passby_wb_sel(module_execute_io_passby_wb_sel),
    .io_passby_csr_addr(module_execute_io_passby_csr_addr),
    .io_passby_csr_cmd(module_execute_io_passby_csr_cmd),
    .io_passby_alu_out(module_execute_io_passby_alu_out)
  );
  MemAccess module_memory_access ( // @[Top.scala 15:36]
    .clock(module_memory_access_clock),
    .reset(module_memory_access_reset),
    .io_extend_exe_pc_reg(module_memory_access_io_extend_exe_pc_reg),
    .io_extend_wb_addr(module_memory_access_io_extend_wb_addr),
    .io_extend_op1_data(module_memory_access_io_extend_op1_data),
    .io_extend_rs2_data(module_memory_access_io_extend_rs2_data),
    .io_extend_mem_wen(module_memory_access_io_extend_mem_wen),
    .io_extend_reg_wen(module_memory_access_io_extend_reg_wen),
    .io_extend_wb_sel(module_memory_access_io_extend_wb_sel),
    .io_extend_csr_addr(module_memory_access_io_extend_csr_addr),
    .io_extend_csr_cmd(module_memory_access_io_extend_csr_cmd),
    .io_extend_alu_out(module_memory_access_io_extend_alu_out),
    .io_csr_read_reg_raddr(module_memory_access_io_csr_read_reg_raddr),
    .io_csr_read_reg_rdata(module_memory_access_io_csr_read_reg_rdata),
    .io_csr_write_reg_waddr(module_memory_access_io_csr_write_reg_waddr),
    .io_csr_write_reg_wdata(module_memory_access_io_csr_write_reg_wdata),
    .io_csr_write_wen(module_memory_access_io_csr_write_wen),
    .io_mem_write_waddr(module_memory_access_io_mem_write_waddr),
    .io_mem_write_wdata(module_memory_access_io_mem_write_wdata),
    .io_mem_write_write_en(module_memory_access_io_mem_write_write_en),
    .io_mem_read_raddr(module_memory_access_io_mem_read_raddr),
    .io_mem_read_rdata(module_memory_access_io_mem_read_rdata),
    .io_passby_reg_wb_addr(module_memory_access_io_passby_reg_wb_addr),
    .io_passby_reg_wen(module_memory_access_io_passby_reg_wen),
    .io_passby_reg_wb_data(module_memory_access_io_passby_reg_wb_data)
  );
  WriteBack module_write_back ( // @[Top.scala 16:33]
    .clock(module_write_back_clock),
    .reset(module_write_back_reset),
    .io_extend_reg_wb_addr(module_write_back_io_extend_reg_wb_addr),
    .io_extend_reg_wen(module_write_back_io_extend_reg_wen),
    .io_extend_reg_wb_data(module_write_back_io_extend_reg_wb_data),
    .io_regIO_reg_waddr(module_write_back_io_regIO_reg_waddr),
    .io_regIO_reg_wdata(module_write_back_io_regIO_reg_wdata),
    .io_regIO_wen(module_write_back_io_regIO_wen)
  );
  Regs module_reg ( // @[Top.scala 18:26]
    .clock(module_reg_clock),
    .io_regReadIO_reg_raddr1(module_reg_io_regReadIO_reg_raddr1),
    .io_regReadIO_reg_raddr2(module_reg_io_regReadIO_reg_raddr2),
    .io_regReadIO_reg_rdata1(module_reg_io_regReadIO_reg_rdata1),
    .io_regReadIO_reg_rdata2(module_reg_io_regReadIO_reg_rdata2),
    .io_regWriteIO_reg_waddr(module_reg_io_regWriteIO_reg_waddr),
    .io_regWriteIO_reg_wdata(module_reg_io_regWriteIO_reg_wdata),
    .io_regWriteIO_wen(module_reg_io_regWriteIO_wen),
    .io_probe(module_reg_io_probe)
  );
  CSR module_csr ( // @[Top.scala 19:26]
    .clock(module_csr_clock),
    .io_read1IO_reg_rdata(module_csr_io_read1IO_reg_rdata),
    .io_read2IO_reg_raddr(module_csr_io_read2IO_reg_raddr),
    .io_read2IO_reg_rdata(module_csr_io_read2IO_reg_rdata),
    .io_writeIO_reg_waddr(module_csr_io_writeIO_reg_waddr),
    .io_writeIO_reg_wdata(module_csr_io_writeIO_reg_wdata),
    .io_writeIO_wen(module_csr_io_writeIO_wen)
  );
  Memory module_memory ( // @[Top.scala 20:29]
    .clock(module_memory_clock),
    .reset(module_memory_reset),
    .io_imem_inst_addr(module_memory_io_imem_inst_addr),
    .io_imem_inst_o(module_memory_io_imem_inst_o),
    .io_aread_raddr(module_memory_io_aread_raddr),
    .io_aread_rdata(module_memory_io_aread_rdata),
    .io_awrite_waddr(module_memory_io_awrite_waddr),
    .io_awrite_wdata(module_memory_io_awrite_wdata),
    .io_awrite_write_en(module_memory_io_awrite_write_en)
  );
  assign io_probe = module_reg_io_probe; // @[Top.scala 48:12]
  assign io_exit = module_inst_fetch_io_inst_mem_inst_o == 32'hc0001073; // @[Top.scala 49:41]
  assign module_inst_fetch_clock = clock;
  assign module_inst_fetch_reset = reset;
  assign module_inst_fetch_io_inst_mem_inst_o = module_memory_io_imem_inst_o; // @[Top.scala 23:33]
  assign module_inst_fetch_io_csr_read_reg_rdata = module_csr_io_read1IO_reg_rdata; // @[Top.scala 27:33]
  assign module_inst_fetch_io_exio_alu_out = module_execute_io_exifIO_alu_out; // @[Top.scala 25:29]
  assign module_inst_fetch_io_exio_br_flag = module_execute_io_exifIO_br_flag; // @[Top.scala 25:29]
  assign module_inst_fetch_io_exio_br_target = module_execute_io_exifIO_br_target; // @[Top.scala 25:29]
  assign module_inst_fetch_io_exio_jmp_flag = module_execute_io_exifIO_jmp_flag; // @[Top.scala 25:29]
  assign module_decode_clock = clock;
  assign module_decode_reset = reset;
  assign module_decode_io_extend_if_inst = module_inst_fetch_io_passby_if_inst; // @[Top.scala 29:31]
  assign module_decode_io_regs_reg_rdata1 = module_reg_io_regReadIO_reg_rdata1; // @[Top.scala 31:25]
  assign module_decode_io_regs_reg_rdata2 = module_reg_io_regReadIO_reg_rdata2; // @[Top.scala 31:25]
  assign module_execute_clock = clock;
  assign module_execute_reset = reset;
  assign module_execute_io_extend_id_pc_reg = module_decode_io_passby_id_pc_reg; // @[Top.scala 33:27]
  assign module_execute_io_extend_imm_b_sext = module_decode_io_passby_imm_b_sext; // @[Top.scala 33:27]
  assign module_execute_io_extend_op1_data = module_decode_io_passby_op1_data; // @[Top.scala 33:27]
  assign module_execute_io_extend_op2_data = module_decode_io_passby_op2_data; // @[Top.scala 33:27]
  assign module_execute_io_extend_rs2_data = module_decode_io_passby_rs2_data; // @[Top.scala 33:27]
  assign module_execute_io_extend_wb_addr = module_decode_io_passby_wb_addr; // @[Top.scala 33:27]
  assign module_execute_io_extend_exe_fun = module_decode_io_passby_exe_fun; // @[Top.scala 33:27]
  assign module_execute_io_extend_mem_wen = module_decode_io_passby_mem_wen; // @[Top.scala 33:27]
  assign module_execute_io_extend_reg_wen = module_decode_io_passby_reg_wen; // @[Top.scala 33:27]
  assign module_execute_io_extend_wb_sel = module_decode_io_passby_wb_sel; // @[Top.scala 33:27]
  assign module_execute_io_extend_csr_cmd = module_decode_io_passby_csr_cmd; // @[Top.scala 33:27]
  assign module_execute_io_extend_csr_addr = module_decode_io_passby_csr_addr; // @[Top.scala 33:27]
  assign module_memory_access_clock = clock;
  assign module_memory_access_reset = reset;
  assign module_memory_access_io_extend_exe_pc_reg = module_execute_io_passby_exe_pc_reg; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_wb_addr = module_execute_io_passby_wb_addr; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_op1_data = module_execute_io_passby_op1_data; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_rs2_data = module_execute_io_passby_rs2_data; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_mem_wen = module_execute_io_passby_mem_wen; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_reg_wen = module_execute_io_passby_reg_wen; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_wb_sel = module_execute_io_passby_wb_sel; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_csr_addr = module_execute_io_passby_csr_addr; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_csr_cmd = module_execute_io_passby_csr_cmd; // @[Top.scala 35:28]
  assign module_memory_access_io_extend_alu_out = module_execute_io_passby_alu_out; // @[Top.scala 35:28]
  assign module_memory_access_io_csr_read_reg_rdata = module_csr_io_read2IO_reg_rdata; // @[Top.scala 37:36]
  assign module_memory_access_io_mem_read_rdata = module_memory_io_aread_rdata; // @[Top.scala 41:36]
  assign module_write_back_clock = clock;
  assign module_write_back_reset = reset;
  assign module_write_back_io_extend_reg_wb_addr = module_memory_access_io_passby_reg_wb_addr; // @[Top.scala 43:34]
  assign module_write_back_io_extend_reg_wen = module_memory_access_io_passby_reg_wen; // @[Top.scala 43:34]
  assign module_write_back_io_extend_reg_wb_data = module_memory_access_io_passby_reg_wb_data; // @[Top.scala 43:34]
  assign module_reg_clock = clock;
  assign module_reg_io_regReadIO_reg_raddr1 = module_decode_io_regs_reg_raddr1; // @[Top.scala 31:25]
  assign module_reg_io_regReadIO_reg_raddr2 = module_decode_io_regs_reg_raddr2; // @[Top.scala 31:25]
  assign module_reg_io_regWriteIO_reg_waddr = module_write_back_io_regIO_reg_waddr[4:0]; // @[Top.scala 45:30]
  assign module_reg_io_regWriteIO_reg_wdata = module_write_back_io_regIO_reg_wdata; // @[Top.scala 45:30]
  assign module_reg_io_regWriteIO_wen = module_write_back_io_regIO_wen; // @[Top.scala 45:30]
  assign module_csr_clock = clock;
  assign module_csr_io_read2IO_reg_raddr = module_memory_access_io_csr_read_reg_raddr; // @[Top.scala 37:36]
  assign module_csr_io_writeIO_reg_waddr = module_memory_access_io_csr_write_reg_waddr; // @[Top.scala 38:37]
  assign module_csr_io_writeIO_reg_wdata = module_memory_access_io_csr_write_reg_wdata; // @[Top.scala 38:37]
  assign module_csr_io_writeIO_wen = module_memory_access_io_csr_write_wen; // @[Top.scala 38:37]
  assign module_memory_clock = clock;
  assign module_memory_reset = reset;
  assign module_memory_io_imem_inst_addr = module_inst_fetch_io_inst_mem_inst_addr; // @[Top.scala 23:33]
  assign module_memory_io_aread_raddr = module_memory_access_io_mem_read_raddr; // @[Top.scala 41:36]
  assign module_memory_io_awrite_waddr = module_memory_access_io_mem_write_waddr; // @[Top.scala 40:37]
  assign module_memory_io_awrite_wdata = module_memory_access_io_mem_write_wdata; // @[Top.scala 40:37]
  assign module_memory_io_awrite_write_en = module_memory_access_io_mem_write_write_en; // @[Top.scala 40:37]
  always @(posedge clock) begin
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"if_reg_pc        : 0x%x\n",module_inst_fetch_io_passby_if_pc_reg); // @[Top.scala 50:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",module_decode_io_passby_id_pc_reg); // @[Top.scala 51:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"exe_reg_pc       : 0x%x\n",module_execute_io_passby_exe_pc_reg); // @[Top.scala 53:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"exe_reg_op1_data : 0x%x\n",module_execute_io_passby_op1_data); // @[Top.scala 54:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"exe_reg_rs2_data : 0x%x\n",module_execute_io_passby_rs2_data); // @[Top.scala 55:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"exe_alu_out      : 0x%x\n",module_execute_io_passby_alu_out); // @[Top.scala 56:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"reg_wb_data      : 0x%x\n",module_memory_access_io_passby_reg_wb_data); // @[Top.scala 58:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"register at position 6: 0x%x\n",io_probe); // @[Top.scala 59:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"---------\n"); // @[Top.scala 60:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
