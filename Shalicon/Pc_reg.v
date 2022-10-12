module Pc_reg(
  input         clock,
  input         reset,
  input  [31:0] io_inst_i,
  output [31:0] io_inst_addr,
  output        io_ce
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] pc_reg; // @[Pc_reg.scala 12:23]
  wire [31:0] _pc_reg_T_1 = pc_reg + 32'h4; // @[Pc_reg.scala 13:20]
  assign io_inst_addr = pc_reg; // @[Pc_reg.scala 14:16]
  assign io_ce = io_inst_i == 32'h13136f97; // @[Pc_reg.scala 16:18]
  always @(posedge clock) begin
    if (reset) begin // @[Pc_reg.scala 12:23]
      pc_reg <= 32'h0; // @[Pc_reg.scala 12:23]
    end else begin
      pc_reg <= _pc_reg_T_1; // @[Pc_reg.scala 13:10]
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
  pc_reg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
