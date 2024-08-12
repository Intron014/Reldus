# ``Bitboard/^(_:_:)``

Performs a bitwise XOR operation between two bitboards.

## Summary

This operator creates a new bitboard that is the result of a bitwise XOR (exclusive OR) operation between two bitboards.

```swift
static func ^ (lhs: Bitboard, rhs: Bitboard) -> Bitboard
```

## Parameters

- `lhs`: The left-hand side `Bitboard` operand.
- `rhs`: The right-hand side `Bitboard` operand.

## Return Value

A new `Bitboard` instance representing the result of the XOR operation.

## Discussion

The `^` operator performs a bitwise XOR operation between two bitboards. This operation is useful for finding differences between bitboards or for toggling specific bits.

In chess programming, this can be used to find squares that are occupied in one position but not in another, or to efficiently update a bitboard when a piece moves.

## Example

```swift
let board1 = Bitboard()
board1.setBit(file: 0, rank: 0)  // Set bit at A1
board1.setBit(file: 1, rank: 1)  // Set bit at B2

let board2 = Bitboard()
board2.setBit(file: 1, rank: 1)  // Set bit at B2
board2.setBit(file: 2, rank: 2)  // Set bit at C3

let result = board1 ^ board2
// result now has bits set at A1 and C3, but not at B2
```

## See Also

- ``Bitboard/|(_:_:)``
- ``Bitboard/&(_:_:)``
