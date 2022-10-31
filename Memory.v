module Memory(
  input         clock,
  input         reset,
  input         io_ce,
  input  [31:0] io_inst_addr,
  output [31:0] io_inst_o
);
  reg [7:0] mem [0:16383]; // @[Memory.scala 13:16]
  wire  mem_io_inst_o_MPORT_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_inst_o_MPORT_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_inst_o_MPORT_data; // @[Memory.scala 13:16]
  wire  mem_io_inst_o_MPORT_1_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_inst_o_MPORT_1_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_inst_o_MPORT_1_data; // @[Memory.scala 13:16]
  wire  mem_io_inst_o_MPORT_2_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_inst_o_MPORT_2_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_inst_o_MPORT_2_data; // @[Memory.scala 13:16]
  wire  mem_io_inst_o_MPORT_3_en; // @[Memory.scala 13:16]
  wire [13:0] mem_io_inst_o_MPORT_3_addr; // @[Memory.scala 13:16]
  wire [7:0] mem_io_inst_o_MPORT_3_data; // @[Memory.scala 13:16]
  wire  _T_1 = ~reset; // @[Memory.scala 15:18]
  wire [31:0] _io_inst_o_T_1 = io_inst_addr + 32'h3; // @[Memory.scala 16:39]
  wire [31:0] _io_inst_o_T_4 = io_inst_addr + 32'h2; // @[Memory.scala 17:24]
  wire [31:0] _io_inst_o_T_7 = io_inst_addr + 32'h1; // @[Memory.scala 18:24]
  wire [31:0] _io_inst_o_T_10 = {mem_io_inst_o_MPORT_data,mem_io_inst_o_MPORT_1_data,mem_io_inst_o_MPORT_2_data,
    mem_io_inst_o_MPORT_3_data}; // @[Cat.scala 31:58]
  assign mem_io_inst_o_MPORT_en = io_ce | _T_1;
  assign mem_io_inst_o_MPORT_addr = _io_inst_o_T_1[13:0];
  assign mem_io_inst_o_MPORT_data = mem[mem_io_inst_o_MPORT_addr]; // @[Memory.scala 13:16]
  assign mem_io_inst_o_MPORT_1_en = io_ce | _T_1;
  assign mem_io_inst_o_MPORT_1_addr = _io_inst_o_T_4[13:0];
  assign mem_io_inst_o_MPORT_1_data = mem[mem_io_inst_o_MPORT_1_addr]; // @[Memory.scala 13:16]
  assign mem_io_inst_o_MPORT_2_en = io_ce | _T_1;
  assign mem_io_inst_o_MPORT_2_addr = _io_inst_o_T_7[13:0];
  assign mem_io_inst_o_MPORT_2_data = mem[mem_io_inst_o_MPORT_2_addr]; // @[Memory.scala 13:16]
  assign mem_io_inst_o_MPORT_3_en = io_ce | _T_1;
  assign mem_io_inst_o_MPORT_3_addr = io_inst_addr[13:0];
  assign mem_io_inst_o_MPORT_3_data = mem[mem_io_inst_o_MPORT_3_addr]; // @[Memory.scala 13:16]
  assign io_inst_o = io_ce | ~reset ? _io_inst_o_T_10 : 32'h0; // @[Memory.scala 15:33 16:15 21:15]
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
