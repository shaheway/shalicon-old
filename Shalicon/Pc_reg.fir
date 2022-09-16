circuit Pc_reg :
  module Pc_reg :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip inst_i : UInt<32>, inst_addr : UInt<32>}

    cmem registers : UInt<32> [32] @[Pc_reg.scala 10:22]
    reg pc_reg : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[Pc_reg.scala 11:23]
    node _pc_reg_T = add(pc_reg, UInt<32>("h4")) @[Pc_reg.scala 12:20]
    node _pc_reg_T_1 = tail(_pc_reg_T, 1) @[Pc_reg.scala 12:20]
    pc_reg <= _pc_reg_T_1 @[Pc_reg.scala 12:10]
    io.inst_addr <= pc_reg @[Pc_reg.scala 13:16]

