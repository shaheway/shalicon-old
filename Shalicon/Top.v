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
  wire [11:0] imm_i = io_imem_inst_o[31:20]; // @[Core.scala 28:19]
  wire [19:0] _imm_i_sext_T_2 = imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_i_sext = {_imm_i_sext_T_2,imm_i}; // @[Cat.scala 31:58]
  wire [11:0] imm_s = {io_imem_inst_o[31:25],wb_addr}; // @[Cat.scala 31:58]
  wire [19:0] _imm_s_sext_T_2 = imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] imm_s_sext = {_imm_s_sext_T_2,io_imem_inst_o[31:25],wb_addr}; // @[Cat.scala 31:58]
  wire [31:0] _alu_out_T = io_imem_inst_o & 32'h707f; // @[Core.scala 35:11]
  wire  _alu_out_T_1 = 32'h2003 == _alu_out_T; // @[Core.scala 35:11]
  wire [31:0] _alu_out_T_3 = rs1_data + imm_i_sext; // @[Core.scala 35:32]
  wire  _alu_out_T_5 = 32'h2023 == _alu_out_T; // @[Core.scala 36:11]
  wire [31:0] _alu_out_T_7 = rs1_data + imm_s_sext; // @[Core.scala 36:32]
  wire [31:0] _alu_out_T_8 = _alu_out_T_5 ? _alu_out_T_7 : 32'h0; // @[Mux.scala 101:16]
  assign registers_rs1_data_MPORT_en = 1'h1;
  assign registers_rs1_data_MPORT_addr = io_imem_inst_o[19:15];
  assign registers_rs1_data_MPORT_data = registers[registers_rs1_data_MPORT_addr]; // @[Core.scala 13:22]
  assign registers_rs2_data_MPORT_en = 1'h1;
  assign registers_rs2_data_MPORT_addr = io_imem_inst_o[24:20];
  assign registers_rs2_data_MPORT_data = registers[registers_rs2_data_MPORT_addr]; // @[Core.scala 13:22]
  assign registers_MPORT_data = io_wbio_rdata;
  assign registers_MPORT_addr = io_imem_inst_o[11:7];
  assign registers_MPORT_mask = 1'h1;
  assign registers_MPORT_en = 32'h2003 == _alu_out_T;
  assign io_imem_inst_addr = pc_reg; // @[Core.scala 18:21]
  assign io_wbio_raddr = _alu_out_T_1 ? _alu_out_T_3 : _alu_out_T_8; // @[Mux.scala 101:16]
  assign io_wbio_waddr = _alu_out_T_1 ? _alu_out_T_3 : _alu_out_T_8; // @[Mux.scala 101:16]
  assign io_wbio_wdata = rs2_addr != 5'h0 ? registers_rs2_data_MPORT_data : 32'h0; // @[Core.scala 27:21]
  assign io_wbio_write_en = _alu_out_T_1 ? 1'h0 : _alu_out_T_5; // @[Mux.scala 101:16]
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
