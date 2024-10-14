# ``Bitboard/|(_:_:)``

Performs a bitwise OR operation between two bitboards.

## Summary

This operator creates a new bitboard that is the result of a bitwise OR operation between two bitboards.

```swift
static func | (lhs: Bitboard, rhs: Bitboard) -> Bitboard
```

## Parameters

- `lhs`: The left-hand side `Bitboard` operand.
- `rhs`: The right-hand side `Bitboard` operand.

## Return Value

A new `Bitboard` instance representing the result of the OR operation.

## Discussion

The `|` operator performs a bitwise OR operation between two bitboards. This operation is useful for combining different piece positions or for adding masks to a bitboard.

In chess programming, this can be used to create a combined set of squares occupied by different piece types or to add attack patterns together.

## Example

```swift
let board1 = Bitboard()
board1.setBit(file: 0, rank: 0)  // Set bit at A1

let board2 = Bitboard()
board2.setBit(file: 1, rank: 1)  // Set bit at B2

let result = board1 | board2
// result now has bits set at A1 and B2
```

## See Also

- ``or(with:)``
- ``Bitboard/&(_:_:)``
