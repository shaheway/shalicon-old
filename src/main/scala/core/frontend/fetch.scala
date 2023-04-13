package core.frontend
import chisel3._
import chisel3.util._
import common.CoreConfig

class FetchBundle extends Bundle with CoreConfig {
  val pc = UInt(addrWidth)
  val instVec = Vec(fetchCount, UInt(instWidth))
  val mask = Bits(fetchCount.W) // 用于指示Vec中哪一个是有效的指令
  val predResp = new BranchPredictionResp
  val predResult = Vec(fetchCount, new BranchPredictionResult)
  val exceptFetch = Bool()
  val reFetch = Bool()
}

class FrontendIO extends Bundle with CoreConfig {
  val req = Decoupled(new Bundle() {
    val pc = Output(UInt(addrWidth))
    val speculative = Output(Bool())
  })
  val resp = Decoupled(Flipped(new Bundle() {
    val pc = Input(UInt(addrWidth))
    val exceptFetch = Input(Bool())
    val reFetch = Input(Bool())
    val data = Input(UInt(instWidth)) // todo: size of data
    val mask = Input(UInt(fetchCount.W))
  }))
  /* todo: btb
  val btb = Decoupled(new Bundle() {
    val pc = Output(UInt(addrWidth))
    val branchPC = Output(UInt(addrWidth))
    val target = Output(UInt(addrWidth))
    val 
  })
   */
  val bhtUpdate = Output(UInt(6.W))
}

class BHTUpdate extends Bundle {

}

class BP2Pred extends Bundle with CoreConfig {
  val mask = Output(UInt(fetchCount.W))
}

class FetchUnit(fetchCount: Int, fetchBufferSize: Int = 4) extends Module with CoreConfig {
  val io = IO(new Bundle() {
    val imem = new FrontendIO // todo: FrontendIO
    val branchU = new BranchPredictionResp().asInput // todo: wtf?
    val flush = Input(Bool())
    val renewPC = Input(UInt(addrWidth))
    val stalled = Output(Bool())
    val fetchOut = DecoupledIO(new FetchBundle)
    val clearFetchBuffer = Input(Bool())
    val bp2Take = Input(Bool())
    val bp2Target = Input(UInt(addrWidth))
    val bp2Pred = Input(new BP2Pred)
    val fetchOut = new DecoupledIO(new FetchBundle)
  })

  val fesqReg = RegInit(0.U(dataWidth)) // todo: wtf?
  val fetchpcNext = Wire(UInt(addrWidth)) // 下一个取指
  val branchUnit = io.branchU // 分支跳转输入
  val fetchBundle = Wire(new FetchBundle)
  val fetchBuffer = Module(new Queue(gen = new FetchBundle, entries = fetchBufferSize, pipe = false, flow = true))
  val fetchStalled = !(fetchBuffer.io.enq.ready) // 如果队列没有准备好，那么就把前端stall

  val takePC = branchUnit.take || io.flush || (io.bp2Take && !fetchStalled)
  io.imem.req.valid := takePC
  io.imem.req.bits.pc := fetchpcNext
  io.imem.req.bits.speculative := !(io.flush)
  io.imem.resp.ready := !(fetchStalled)

  fetchpcNext := Mux(io.flush, io.renewPC, Mux(branchUnit.take, branchUnit.target, io.bp2Target))

  // FetchBuffer
  fetchBuffer.io.enq.valid := io.imem.resp.valid && !io.clearFetchBuffer
  fetchBuffer.io.enq.bits := fetchBundle
  fetchBundle.pc := io.imem.resp.bits.pc
  fetchBundle.exceptFetch := io.imem.resp.bits.exceptFetch
  fetchBundle.reFetch := io.imem.resp.bits.reFetch

  for (i <- 0 until fetchCount){
    fetchBundle.instVec(i) := io.imem.resp.bits.data((i+1)*instLength - 1, i*instLength)
    // todo: debug info
  }

  // BTB
  // todo: BTB
  val bp2BHTupdate = Wire(Valid(new BHTUpdate))
  bp2BHTupdate.valid := io.imem.resp.valid && branchUnit.take && !fetchStalled // todo
  bp2BHTupdate.bits.prediction := io.imem.resp.bits.btb
  bp2BHTupdate.bits.pc := io.imem.resp.bits.pc
  bp2BHTupdate.bits.taken // todo

  // bp2 stage
  fetchBundle.mask := io.imem.resp.bits.mask & io.bp2Pred.mask
  fetchBundle.predResp := io.bp2Pred
  fetchBundle.predResult = io.bp2PresdResult

  // Output
  io.stalled := fetchStalled
  io.fetchOut <> fetchBuffer.io.deq
}