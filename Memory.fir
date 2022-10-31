circuit Memory :
  module Memory :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip ce : UInt<1>, flip inst_addr : UInt<32>, inst_o : UInt<32>}

    cmem mem : UInt<8> [16384] @[Memory.scala 13:16]
    node _T = bits(reset, 0, 0) @[Memory.scala 15:25]
    node _T_1 = eq(_T, UInt<1>("h0")) @[Memory.scala 15:18]
    node _T_2 = or(io.ce, _T_1) @[Memory.scala 15:14]
    when _T_2 : @[Memory.scala 15:33]
      node _io_inst_o_T = add(io.inst_addr, UInt<32>("h3")) @[Memory.scala 16:39]
      node _io_inst_o_T_1 = tail(_io_inst_o_T, 1) @[Memory.scala 16:39]
      node _io_inst_o_T_2 = bits(_io_inst_o_T_1, 13, 0) @[Memory.scala 16:25]
      infer mport io_inst_o_MPORT = mem[_io_inst_o_T_2], clock @[Memory.scala 16:25]
      node _io_inst_o_T_3 = add(io.inst_addr, UInt<32>("h2")) @[Memory.scala 17:24]
      node _io_inst_o_T_4 = tail(_io_inst_o_T_3, 1) @[Memory.scala 17:24]
      node _io_inst_o_T_5 = bits(_io_inst_o_T_4, 13, 0) @[Memory.scala 17:10]
      infer mport io_inst_o_MPORT_1 = mem[_io_inst_o_T_5], clock @[Memory.scala 17:10]
      node _io_inst_o_T_6 = add(io.inst_addr, UInt<32>("h1")) @[Memory.scala 18:24]
      node _io_inst_o_T_7 = tail(_io_inst_o_T_6, 1) @[Memory.scala 18:24]
      node _io_inst_o_T_8 = bits(_io_inst_o_T_7, 13, 0) @[Memory.scala 18:10]
      infer mport io_inst_o_MPORT_2 = mem[_io_inst_o_T_8], clock @[Memory.scala 18:10]
      node _io_inst_o_T_9 = bits(io.inst_addr, 13, 0) @[Memory.scala 19:10]
      infer mport io_inst_o_MPORT_3 = mem[_io_inst_o_T_9], clock @[Memory.scala 19:10]
      node io_inst_o_lo = cat(io_inst_o_MPORT_2, io_inst_o_MPORT_3) @[Cat.scala 31:58]
      node io_inst_o_hi = cat(io_inst_o_MPORT, io_inst_o_MPORT_1) @[Cat.scala 31:58]
      node _io_inst_o_T_10 = cat(io_inst_o_hi, io_inst_o_lo) @[Cat.scala 31:58]
      io.inst_o <= _io_inst_o_T_10 @[Memory.scala 16:15]
    else :
      io.inst_o <= UInt<32>("h0") @[Memory.scala 21:15]

