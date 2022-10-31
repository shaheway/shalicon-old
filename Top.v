module Core(
  input         clock,
  input         reset,
  output [31:0] io_imem_inst_addr,
  input  [31:0] io_imem_inst_o,
  output [31:0] io_wbio_raddr,
  input  [31:0] io_wbio_rdata,
  output [31:0] io_wbio_waddr,
  output [31:0] io_wbio_wdata,
  output        io_wbio_write_en,
  output        io_ce
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] registers [0:31]; // @[Core.scala 13:22]
  wire  registers_rs1_data_MPORT_en; // @[Core.scala 13:22]
  wire [4:0] registers_rs1_data_MPORT_addr; // @[Core.scala 13:22]
  wire [31:0] registers_rs1_data_MPORT_data; // @[Core.scala 13:22]
  wire  registers_rs2_data_MPORT_en; // @[Core.scala 13:22]
  wire [4:0] registers_rs2_data_MPORT_addr; // @[Core.scala 13:22]
  wire [31:0] registers_rs2_data_MPORT_data; // @[Core.scala 13:22]
  wire [31:0] registers_MPORT_data; // @[Core.scala 13:22]
  wire [4:0] registers_MPORT_addr; // @[Core.scala 13:22]
  wire  registers_MPORT_mask; // @[Core.scala 13:22]
  wire  registers_MPORT_en; // @[Core.scala 13:22]
  reg [31:0] pc_reg; // @[Core.scala 16:23]
  wire [31:0] _pc_reg_T_1 = pc_reg + 32'h4; // @[Core.scala 17:20]
  wire [4:0] rs1_addr = io_imem_inst_o[19:15]; // @[Core.scala 23:22]
  wire [4:0] rs2_addr = io_imem_inst_o[24:20]; // @[Core.scala 24:22]
  wire [4:0] wb_addr = io_imem_inst_o[11:7]; // @[Core.scala 25:21]
  wire [31:0] rs1_data = rs1_addr != 5'h0 ? registers_rs1_data_MPORT_data : 32'h0; // @[Core.scala 26:21]
  wire [31:0] rs2_data = rs2_addr != 5'h0 ? registers_rs2_data_MPORT_data : 32'h0; // @[Core.scala 27:21]
  wire [11:0] imm_i = io_imem_inst_o[31:20]; // @[Core.scala 28:19]
  wire [19:0] _imm_i_sext_T_2 = imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_i_sext = {_imm_i_sext_T_2,imm_i}; // @[Cat.scala 31:58]
  wire [11:0] imm_s = {io_imem_inst_o[31:25],wb_addr}; // @[Cat.scala 31:58]
  wire [19:0] _imm_s_sext_T_2 = imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_s_sext = {_imm_s_sext_T_2,io_imem_inst_o[31:25],wb_addr}; // @[Cat.scala 31:58]
  wire [19:0] imm_j = {io_imem_inst_o[31],io_imem_inst_o[19:12],io_imem_inst_o[20],io_imem_inst_o[30:21]}; // @[Cat.scala 31:58]
  wire [10:0] _imm_j_sext_T_2 = imm_j[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_j_sext = {_imm_j_sext_T_2,io_imem_inst_o[31],io_imem_inst_o[19:12],io_imem_inst_o[20],io_imem_inst_o[
    30:21],1'h0}; // @[Cat.scala 31:58]
  wire [19:0] imm_u = io_imem_inst_o[31:12]; // @[Core.scala 36:19]
  wire [31:0] imm_u_shifted = {imm_u,12'h0}; // @[Cat.scala 31:58]
  wire [31:0] imm_z_uext = {27'h0,rs1_addr}; // @[Cat.scala 31:58]
  wire [31:0] _decoded_inst_T = io_imem_inst_o & 32'h707f; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_1 = 32'h2023 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire  _decoded_inst_T_3 = 32'h2003 == _decoded_inst_T; // @[Lookup.scala 31:38]
  wire [31:0] _decoded_inst_T_4 = io_imem_inst_o & 32'hfe00707f; // @[Lookup.scala 31:38]
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
  wire [4:0] _decoded_inst_T_42 = _decoded_inst_T_41 ? 5'h9 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_43 = _decoded_inst_T_39 ? 5'h9 : _decoded_inst_T_42; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_44 = _decoded_inst_T_37 ? 5'h9 : _decoded_inst_T_43; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_45 = _decoded_inst_T_35 ? 5'h9 : _decoded_inst_T_44; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_46 = _decoded_inst_T_33 ? 5'h8 : _decoded_inst_T_45; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_47 = _decoded_inst_T_31 ? 5'h8 : _decoded_inst_T_46; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_48 = _decoded_inst_T_29 ? 5'h7 : _decoded_inst_T_47; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_49 = _decoded_inst_T_27 ? 5'h7 : _decoded_inst_T_48; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_50 = _decoded_inst_T_25 ? 5'h6 : _decoded_inst_T_49; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_51 = _decoded_inst_T_23 ? 5'h6 : _decoded_inst_T_50; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_52 = _decoded_inst_T_21 ? 5'h4 : _decoded_inst_T_51; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_53 = _decoded_inst_T_19 ? 5'h5 : _decoded_inst_T_52; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_54 = _decoded_inst_T_17 ? 5'h4 : _decoded_inst_T_53; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_55 = _decoded_inst_T_15 ? 5'h4 : _decoded_inst_T_54; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_56 = _decoded_inst_T_13 ? 5'h3 : _decoded_inst_T_55; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_57 = _decoded_inst_T_11 ? 5'h3 : _decoded_inst_T_56; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_58 = _decoded_inst_T_9 ? 5'h1 : _decoded_inst_T_57; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_59 = _decoded_inst_T_7 ? 5'h2 : _decoded_inst_T_58; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_60 = _decoded_inst_T_5 ? 5'h1 : _decoded_inst_T_59; // @[Lookup.scala 34:39]
  wire [4:0] _decoded_inst_T_61 = _decoded_inst_T_3 ? 5'h1 : _decoded_inst_T_60; // @[Lookup.scala 34:39]
  wire [4:0] decoded_inst_0 = _decoded_inst_T_1 ? 5'h1 : _decoded_inst_T_61; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_62 = _decoded_inst_T_41 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_63 = _decoded_inst_T_39 ? 2'h1 : _decoded_inst_T_62; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_64 = _decoded_inst_T_37 ? 2'h1 : _decoded_inst_T_63; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_65 = _decoded_inst_T_35 ? 2'h1 : _decoded_inst_T_64; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_66 = _decoded_inst_T_33 ? 2'h1 : _decoded_inst_T_65; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_67 = _decoded_inst_T_31 ? 2'h1 : _decoded_inst_T_66; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_68 = _decoded_inst_T_29 ? 2'h1 : _decoded_inst_T_67; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_69 = _decoded_inst_T_27 ? 2'h1 : _decoded_inst_T_68; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_70 = _decoded_inst_T_25 ? 2'h1 : _decoded_inst_T_69; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_71 = _decoded_inst_T_23 ? 2'h1 : _decoded_inst_T_70; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_72 = _decoded_inst_T_21 ? 2'h1 : _decoded_inst_T_71; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_73 = _decoded_inst_T_19 ? 2'h1 : _decoded_inst_T_72; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_74 = _decoded_inst_T_17 ? 2'h1 : _decoded_inst_T_73; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_75 = _decoded_inst_T_15 ? 2'h1 : _decoded_inst_T_74; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_76 = _decoded_inst_T_13 ? 2'h1 : _decoded_inst_T_75; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_77 = _decoded_inst_T_11 ? 2'h1 : _decoded_inst_T_76; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_78 = _decoded_inst_T_9 ? 2'h1 : _decoded_inst_T_77; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_79 = _decoded_inst_T_7 ? 2'h1 : _decoded_inst_T_78; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_80 = _decoded_inst_T_5 ? 2'h1 : _decoded_inst_T_79; // @[Lookup.scala 34:39]
  wire [1:0] _decoded_inst_T_81 = _decoded_inst_T_3 ? 2'h1 : _decoded_inst_T_80; // @[Lookup.scala 34:39]
  wire [1:0] decoded_inst_1 = _decoded_inst_T_1 ? 2'h1 : _decoded_inst_T_81; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_82 = _decoded_inst_T_41 ? 3'h2 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_83 = _decoded_inst_T_39 ? 3'h1 : _decoded_inst_T_82; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_84 = _decoded_inst_T_37 ? 3'h2 : _decoded_inst_T_83; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_85 = _decoded_inst_T_35 ? 3'h1 : _decoded_inst_T_84; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_86 = _decoded_inst_T_33 ? 3'h2 : _decoded_inst_T_85; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_87 = _decoded_inst_T_31 ? 3'h1 : _decoded_inst_T_86; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_88 = _decoded_inst_T_29 ? 3'h2 : _decoded_inst_T_87; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_89 = _decoded_inst_T_27 ? 3'h1 : _decoded_inst_T_88; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_90 = _decoded_inst_T_25 ? 3'h2 : _decoded_inst_T_89; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_91 = _decoded_inst_T_23 ? 3'h1 : _decoded_inst_T_90; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_92 = _decoded_inst_T_21 ? 3'h2 : _decoded_inst_T_91; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_93 = _decoded_inst_T_19 ? 3'h1 : _decoded_inst_T_92; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_94 = _decoded_inst_T_17 ? 3'h2 : _decoded_inst_T_93; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_95 = _decoded_inst_T_15 ? 3'h1 : _decoded_inst_T_94; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_96 = _decoded_inst_T_13 ? 3'h2 : _decoded_inst_T_95; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_97 = _decoded_inst_T_11 ? 3'h1 : _decoded_inst_T_96; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_98 = _decoded_inst_T_9 ? 3'h2 : _decoded_inst_T_97; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_99 = _decoded_inst_T_7 ? 3'h1 : _decoded_inst_T_98; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_100 = _decoded_inst_T_5 ? 3'h1 : _decoded_inst_T_99; // @[Lookup.scala 34:39]
  wire [2:0] _decoded_inst_T_101 = _decoded_inst_T_3 ? 3'h2 : _decoded_inst_T_100; // @[Lookup.scala 34:39]
  wire [2:0] decoded_inst_2 = _decoded_inst_T_1 ? 3'h4 : _decoded_inst_T_101; // @[Lookup.scala 34:39]
  wire [1:0] decoded_inst_3 = _decoded_inst_T_1 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire  _op1_data_T = decoded_inst_1 == 2'h1; // @[Core.scala 71:14]
  wire  _op1_data_T_1 = decoded_inst_1 == 2'h2; // @[Core.scala 72:14]
  wire  _op1_data_T_2 = decoded_inst_1 == 2'h3; // @[Core.scala 73:14]
  wire [31:0] _op1_data_T_3 = _op1_data_T_2 ? imm_z_uext : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _op1_data_T_4 = _op1_data_T_1 ? pc_reg : _op1_data_T_3; // @[Mux.scala 101:16]
  wire [31:0] op1_data = _op1_data_T ? rs1_data : _op1_data_T_4; // @[Mux.scala 101:16]
  wire  _op2_data_T = decoded_inst_2 == 3'h1; // @[Core.scala 76:14]
  wire  _op2_data_T_1 = decoded_inst_2 == 3'h2; // @[Core.scala 77:14]
  wire  _op2_data_T_2 = decoded_inst_2 == 3'h4; // @[Core.scala 78:14]
  wire  _op2_data_T_3 = decoded_inst_2 == 3'h3; // @[Core.scala 79:14]
  wire  _op2_data_T_4 = decoded_inst_2 == 3'h5; // @[Core.scala 80:14]
  wire [31:0] _op2_data_T_5 = _op2_data_T_4 ? imm_u_shifted : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _op2_data_T_6 = _op2_data_T_3 ? imm_j_sext : _op2_data_T_5; // @[Mux.scala 101:16]
  wire [31:0] _op2_data_T_7 = _op2_data_T_2 ? imm_s_sext : _op2_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _op2_data_T_8 = _op2_data_T_1 ? imm_i_sext : _op2_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] op2_data = _op2_data_T ? rs2_data : _op2_data_T_8; // @[Mux.scala 101:16]
  wire  _alu_out_T = decoded_inst_0 == 5'h1; // @[Core.scala 85:14]
  wire [31:0] _alu_out_T_2 = op1_data + op2_data; // @[Core.scala 85:44]
  wire  _alu_out_T_3 = decoded_inst_0 == 5'h2; // @[Core.scala 86:14]
  wire [31:0] _alu_out_T_5 = op1_data - op2_data; // @[Core.scala 86:44]
  wire  _alu_out_T_6 = decoded_inst_0 == 5'h3; // @[Core.scala 87:14]
  wire [31:0] _alu_out_T_7 = op1_data & op2_data; // @[Core.scala 87:44]
  wire  _alu_out_T_8 = decoded_inst_0 == 5'h4; // @[Core.scala 88:14]
  wire [31:0] _alu_out_T_9 = op1_data | op2_data; // @[Core.scala 88:44]
  wire  _alu_out_T_10 = decoded_inst_0 == 5'h5; // @[Core.scala 89:14]
  wire [31:0] _alu_out_T_11 = op1_data ^ op2_data; // @[Core.scala 89:44]
  wire  _alu_out_T_12 = decoded_inst_0 == 5'h6; // @[Core.scala 90:14]
  wire [62:0] _GEN_0 = {{31'd0}, op1_data}; // @[Core.scala 90:44]
  wire [62:0] _alu_out_T_14 = _GEN_0 << op2_data[4:0]; // @[Core.scala 90:44]
  wire  _alu_out_T_15 = decoded_inst_0 == 5'h7; // @[Core.scala 91:14]
  wire [31:0] _alu_out_T_17 = op1_data >> op2_data[4:0]; // @[Core.scala 91:44]
  wire  _alu_out_T_18 = decoded_inst_0 == 5'h8; // @[Core.scala 92:14]
  wire [31:0] _alu_out_T_19 = _alu_out_T_18 ? op1_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _alu_out_T_20 = _alu_out_T_15 ? _alu_out_T_17 : _alu_out_T_19; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_21 = _alu_out_T_12 ? _alu_out_T_14 : {{31'd0}, _alu_out_T_20}; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_22 = _alu_out_T_10 ? {{31'd0}, _alu_out_T_11} : _alu_out_T_21; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_23 = _alu_out_T_8 ? {{31'd0}, _alu_out_T_9} : _alu_out_T_22; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_24 = _alu_out_T_6 ? {{31'd0}, _alu_out_T_7} : _alu_out_T_23; // @[Mux.scala 101:16]
  wire [62:0] _alu_out_T_25 = _alu_out_T_3 ? {{31'd0}, _alu_out_T_5} : _alu_out_T_24; // @[Mux.scala 101:16]
  wire [62:0] alu_out = _alu_out_T ? {{31'd0}, _alu_out_T_2} : _alu_out_T_25; // @[Mux.scala 101:16]
  wire  _io_wbio_write_en_T = decoded_inst_3 == 2'h1; // @[Core.scala 97:14]
  wire  _io_wbio_write_en_T_1 = decoded_inst_3 == 2'h0; // @[Core.scala 98:14]
  assign registers_rs1_data_MPORT_en = 1'h1;
  assign registers_rs1_data_MPORT_addr = io_imem_inst_o[19:15];
  assign registers_rs1_data_MPORT_data = registers[registers_rs1_data_MPORT_addr]; // @[Core.scala 13:22]
  assign registers_rs2_data_MPORT_en = 1'h1;
  assign registers_rs2_data_MPORT_addr = io_imem_inst_o[24:20];
  assign registers_rs2_data_MPORT_data = registers[registers_rs2_data_MPORT_addr]; // @[Core.scala 13:22]
  assign registers_MPORT_data = io_wbio_rdata;
  assign registers_MPORT_addr = io_imem_inst_o[11:7];
  assign registers_MPORT_mask = 1'h1;
  assign registers_MPORT_en = 32'h2003 == _decoded_inst_T;
  assign io_imem_inst_addr = pc_reg; // @[Core.scala 18:21]
  assign io_wbio_raddr = alu_out[31:0]; // @[Core.scala 100:17]
  assign io_wbio_waddr = alu_out[31:0]; // @[Core.scala 102:17]
  assign io_wbio_wdata = rs2_addr != 5'h0 ? registers_rs2_data_MPORT_data : 32'h0; // @[Core.scala 27:21]
  assign io_wbio_write_en = _io_wbio_write_en_T ? 1'h0 : _io_wbio_write_en_T_1; // @[Mux.scala 101:16]
  assign io_ce = io_imem_inst_o == 32'h13136f97; // @[Core.scala 20:18]
  always @(posedge clock) begin
    if (registers_MPORT_en & registers_MPORT_mask) begin
      registers[registers_MPORT_addr] <= registers_MPORT_data; // @[Core.scala 13:22]
    end
    if (reset) begin // @[Core.scala 16:23]
      pc_reg <= 32'h0; // @[Core.scala 16:23]
    end else begin
      pc_reg <= _pc_reg_T_1; // @[Core.scala 17:10]
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
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  pc_reg = _RAND_1[31:0];
`endif // RANDOMIZE_REG_INIT
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
  input  [31:0] io_wbio_raddr,
  output [31:0] io_wbio_rdata,
  input  [31:0] io_wbio_waddr,
  input  [31:0] io_wbio_wdata,
  input         io_wbio_write_en
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
  wire  mem_io_wbio_rdata_MPORT_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_wbio_rdata_MPORT_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_wbio_rdata_MPORT_data; // @[Memory.scala 13:16]
  wire  mem_io_wbio_rdata_MPORT_1_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_wbio_rdata_MPORT_1_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_wbio_rdata_MPORT_1_data; // @[Memory.scala 13:16]
  wire  mem_io_wbio_rdata_MPORT_2_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_wbio_rdata_MPORT_2_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_wbio_rdata_MPORT_2_data; // @[Memory.scala 13:16]
  wire  mem_io_wbio_rdata_MPORT_3_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_wbio_rdata_MPORT_3_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_wbio_rdata_MPORT_3_data; // @[Memory.scala 13:16]
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
  wire [31:0] _io_wbio_rdata_T_1 = io_wbio_raddr + 32'h3; // @[Memory.scala 24:42]
  wire [31:0] _io_wbio_rdata_T_4 = io_wbio_raddr + 32'h2; // @[Memory.scala 25:23]
  wire [31:0] _io_wbio_rdata_T_7 = io_wbio_raddr + 32'h1; // @[Memory.scala 26:23]
  wire [15:0] io_wbio_rdata_lo = {mem_io_wbio_rdata_MPORT_2_data,mem_io_wbio_rdata_MPORT_3_data}; // @[Cat.scala 31:58]
  wire [15:0] io_wbio_rdata_hi = {mem_io_wbio_rdata_MPORT_data,mem_io_wbio_rdata_MPORT_1_data}; // @[Cat.scala 31:58]
  wire [31:0] _T_2 = io_wbio_waddr + 32'h3; // @[Memory.scala 30:23]
  wire [31:0] _T_6 = io_wbio_waddr + 32'h2; // @[Memory.scala 31:23]
  wire [31:0] _T_10 = io_wbio_waddr + 32'h1; // @[Memory.scala 32:23]
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
  assign mem_io_wbio_rdata_MPORT_en = 1'h1;
  assign mem_io_wbio_rdata_MPORT_addr = _io_wbio_rdata_T_1[13:0];
  assign mem_io_wbio_rdata_MPORT_data = mem[mem_io_wbio_rdata_MPORT_addr]; // @[Memory.scala 13:16]
  assign mem_io_wbio_rdata_MPORT_1_en = 1'h1;
  assign mem_io_wbio_rdata_MPORT_1_addr = _io_wbio_rdata_T_4[13:0];
  assign mem_io_wbio_rdata_MPORT_1_data = mem[mem_io_wbio_rdata_MPORT_1_addr]; // @[Memory.scala 13:16]
  assign mem_io_wbio_rdata_MPORT_2_en = 1'h1;
  assign mem_io_wbio_rdata_MPORT_2_addr = _io_wbio_rdata_T_7[13:0];
  assign mem_io_wbio_rdata_MPORT_2_data = mem[mem_io_wbio_rdata_MPORT_2_addr]; // @[Memory.scala 13:16]
  assign mem_io_wbio_rdata_MPORT_3_en = 1'h1;
  assign mem_io_wbio_rdata_MPORT_3_addr = io_wbio_raddr[13:0];
  assign mem_io_wbio_rdata_MPORT_3_data = mem[mem_io_wbio_rdata_MPORT_3_addr]; // @[Memory.scala 13:16]
  assign mem_MPORT_data = io_wbio_wdata[31:24];
  assign mem_MPORT_addr = _T_2[13:0];
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_wbio_write_en;
  assign mem_MPORT_1_data = io_wbio_wdata[23:16];
  assign mem_MPORT_1_addr = _T_6[13:0];
  assign mem_MPORT_1_mask = 1'h1;
  assign mem_MPORT_1_en = io_wbio_write_en;
  assign mem_MPORT_2_data = io_wbio_wdata[15:8];
  assign mem_MPORT_2_addr = _T_10[13:0];
  assign mem_MPORT_2_mask = 1'h1;
  assign mem_MPORT_2_en = io_wbio_write_en;
  assign mem_MPORT_3_data = io_wbio_wdata[7:0];
  assign mem_MPORT_3_addr = io_wbio_waddr[13:0];
  assign mem_MPORT_3_mask = 1'h1;
  assign mem_MPORT_3_en = io_wbio_write_en;
  assign io_imem_inst_o = reset ? 32'h0 : _io_imem_inst_o_T_10; // @[Memory.scala 15:21 16:20 18:20]
  assign io_wbio_rdata = {io_wbio_rdata_hi,io_wbio_rdata_lo}; // @[Cat.scala 31:58]
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
  input   clock,
  input   reset,
  output  io_ce
);
  wire  CORE_clock; // @[Top.scala 9:20]
  wire  CORE_reset; // @[Top.scala 9:20]
  wire [31:0] CORE_io_imem_inst_addr; // @[Top.scala 9:20]
  wire [31:0] CORE_io_imem_inst_o; // @[Top.scala 9:20]
  wire [31:0] CORE_io_wbio_raddr; // @[Top.scala 9:20]
  wire [31:0] CORE_io_wbio_rdata; // @[Top.scala 9:20]
  wire [31:0] CORE_io_wbio_waddr; // @[Top.scala 9:20]
  wire [31:0] CORE_io_wbio_wdata; // @[Top.scala 9:20]
  wire  CORE_io_wbio_write_en; // @[Top.scala 9:20]
  wire  CORE_io_ce; // @[Top.scala 9:20]
  wire  MEM_clock; // @[Top.scala 10:19]
  wire  MEM_reset; // @[Top.scala 10:19]
  wire [31:0] MEM_io_imem_inst_addr; // @[Top.scala 10:19]
  wire [31:0] MEM_io_imem_inst_o; // @[Top.scala 10:19]
  wire [31:0] MEM_io_wbio_raddr; // @[Top.scala 10:19]
  wire [31:0] MEM_io_wbio_rdata; // @[Top.scala 10:19]
  wire [31:0] MEM_io_wbio_waddr; // @[Top.scala 10:19]
  wire [31:0] MEM_io_wbio_wdata; // @[Top.scala 10:19]
  wire  MEM_io_wbio_write_en; // @[Top.scala 10:19]
  Core CORE ( // @[Top.scala 9:20]
    .clock(CORE_clock),
    .reset(CORE_reset),
    .io_imem_inst_addr(CORE_io_imem_inst_addr),
    .io_imem_inst_o(CORE_io_imem_inst_o),
    .io_wbio_raddr(CORE_io_wbio_raddr),
    .io_wbio_rdata(CORE_io_wbio_rdata),
    .io_wbio_waddr(CORE_io_wbio_waddr),
    .io_wbio_wdata(CORE_io_wbio_wdata),
    .io_wbio_write_en(CORE_io_wbio_write_en),
    .io_ce(CORE_io_ce)
  );
  Memory MEM ( // @[Top.scala 10:19]
    .clock(MEM_clock),
    .reset(MEM_reset),
    .io_imem_inst_addr(MEM_io_imem_inst_addr),
    .io_imem_inst_o(MEM_io_imem_inst_o),
    .io_wbio_raddr(MEM_io_wbio_raddr),
    .io_wbio_rdata(MEM_io_wbio_rdata),
    .io_wbio_waddr(MEM_io_wbio_waddr),
    .io_wbio_wdata(MEM_io_wbio_wdata),
    .io_wbio_write_en(MEM_io_wbio_write_en)
  );
  assign io_ce = CORE_io_ce; // @[Top.scala 13:9]
  assign CORE_clock = clock;
  assign CORE_reset = reset;
  assign CORE_io_imem_inst_o = MEM_io_imem_inst_o; // @[Top.scala 11:16]
  assign CORE_io_wbio_rdata = MEM_io_wbio_rdata; // @[Top.scala 12:16]
  assign MEM_clock = clock;
  assign MEM_reset = reset;
  assign MEM_io_imem_inst_addr = CORE_io_imem_inst_addr; // @[Top.scala 11:16]
  assign MEM_io_wbio_raddr = CORE_io_wbio_raddr; // @[Top.scala 12:16]
  assign MEM_io_wbio_waddr = CORE_io_wbio_waddr; // @[Top.scala 12:16]
  assign MEM_io_wbio_wdata = CORE_io_wbio_wdata; // @[Top.scala 12:16]
  assign MEM_io_wbio_write_en = CORE_io_wbio_write_en; // @[Top.scala 12:16]
endmodule
