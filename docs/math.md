# Math

## Scalar

`luapp.math.scalar` contains scalar operations:

- `Abs`, `Min`, `Max`, `Clamp`, `Sign`
- `Lerp`, `InverseLerp`, `Remap`, `Wrap`, `Round`
- `IsFinite`, `Factorial`
- `Sum`, `Mean`, `Median`

## Random

`luapp.math.random.new(seed)` creates a deterministic xorshift32 generator.

- `:NextNumber(minimum?, maximum?)`
- `:NextInteger(minimum, maximum)`
- `:Choice(values)`
- `:Shuffle(values)` returns a shuffled copy.

A generator with the same seed produces the same sequence. Do not use this generator for security-sensitive randomness.

## Bit

`luapp.math.bit` wraps Luau's unsigned 32-bit bit operations: `And`, `Or`, `Xor`, `Not`, shifts, rotations, `Extract`, and `Replace`.

## Complex

`Complex.new(real, imaginary?)` represents a complex number.

- `:Add(other)`, `:Sub(other)`, `:Mul(other)`, `:Div(other)`
- `:Conjugate()`, `:Magnitude()`, `:Argument()`, `:ToString()`
- `Complex.FromPolar(magnitude, angle)`

## Numeric

See [Algorithms](Algorithms.md#mathnumeric) for accumulation, integer sequences, GCD, LCM, and inner product.
