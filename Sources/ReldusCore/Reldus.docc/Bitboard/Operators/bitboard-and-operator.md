# ``Bitboard/&(_:_:)``

Performs a bitwise AND operation between two bitboards.

## Summary

This operator creates a new bitboard that is the result of a bitwise AND operation between two bitboards.

```swift
static func & (lhs: Bitboard, rhs: Bitboard) -> Bitboard
```

## Parameters

- `lhs`: The left-hand side `Bitboard` operand.
- `rhs`: The right-hand side `Bitboard` operand.

## Return Value

A new `Bitboard` instance representing the result of the AND operation.

## Discussion

The `&` operator performs a bitwise AND operation between two bitboards. This operation is useful for finding intersections between different piece positions or for applying masks to a bitboard.

In chess programming, this can be used to find shared squares between two piece sets, or to isolate pieces in a certain area of the board.

## Example

```swift
let board1 = Bitboard()
board1.setBit(file: 0, rank: 0)  // Set bit at A1
board1.setBit(file: 1, rank: 1)  // Set bit at B2

let board2 = Bitboard()
board2.setBit(file: 1, rank: 1)  // Set bit at B2
board2.setBit(file: 2, rank: 2)  // Set bit at C3

let result = board1 & board2
// result now has only the bit at B2 set
```

## See Also

- ``and(with:)``
- ``Bitboard/|(_:_:)``
