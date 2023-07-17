import chisel3._
import chisel3.util._

class FPMultiplier extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val result = Output(UInt(64.W))
  })

  // Extract sign, exponent, and fraction bits from inputs
  val signA = io.a(63)
  val exponentA = io.a(62, 52)
  val fractionA = io.a(51, 0)

  val signB = io.b(63)
  val exponentB = io.b(62, 52)
  val fractionB = io.b(51, 0)

  // Determine the sign of the result
  val signResult = signA ^ signB

  // Add implicit leading one to fractions
  val extendedFractionA = Cat(1.U(1.W), fractionA)
  val extendedFractionB = Cat(1.U(1.W), fractionB)

  // Multiply fractions
  val productFraction = extendedFractionA * extendedFractionB

  // Normalize the product fraction
  val normalizedFraction = productFraction >> PopCount(productFraction(63, 1))

  // Calculate the exponent
  val exponentResult = exponentA + exponentB - 1023.U

  // Combine the sign, exponent, and fraction to get the result
  val result = Cat(signResult, exponentResult, normalizedFraction(50, 0))

  io.result := result
}

object FPMultiplierMain extends App {
  chisel3.Driver.execute(args, () => new FPMultiplier)
}
