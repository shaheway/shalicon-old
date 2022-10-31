circuit Pc_reg :
  module Pc_reg :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip inst_i : UInt<32>, inst_addr : UInt<32>, ce : UInt<1>}

    cmem registers : UInt<32> [32] @[Pc_reg.scala 11:22]
    reg pc_reg : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[Pc_reg.scala 12:23]
    node _pc_reg_T = add(pc_reg, UInt<32>("h4")) @[Pc_reg.scala 13:20]
    node _pc_reg_T_1 = tail(_pc_reg_T, 1) @[Pc_reg.scala 13:20]
    pc_reg <= _pc_reg_T_1 @[Pc_reg.scala 13:10]
    io.inst_addr <= pc_reg @[Pc_reg.scala 14:16]
    node _io_ce_T = eq(io.inst_i, UInt<32>("h13136f97")) @[Pc_reg.scala 16:18]
    io.ce <= _io_ce_T @[Pc_reg.scala 16:9]

