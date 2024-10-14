# ``Bitboard/~(_:)``

Performs a bitwise NOT operation on a bitboard.

## Summary

This operator creates a new bitboard that is the result of a bitwise NOT operation on the given bitboard.

```swift
static prefix func ~ (value: Bitboard) -> Bitboard
```

## Parameters

- `value`: The `Bitboard` operand to invert.

## Return Value

A new `Bitboard` instance representing the result of the NOT operation.

## Discussion

The `~` operator performs a bitwise NOT operation on a bitboard, effectively flipping all bits. This operation is useful for creating complement sets or for inverting masks.

In chess programming, this can be used to find unoccupied squares, to create "negative" masks, or to invert piece positions for the opposing side.

## Example

```swift
let board = Bitboard()
board.setBit(file: 0, rank: 0)  // Set bit at A1
board.setBit(file: 1, rank: 1)  // Set bit at B2

let invertedBoard = ~board
// invertedBoard now has all bits set except for A1 and B2
```

## See Also

- ``Bitboard/|(_:_:)``
- ``Bitboard/&(_:_:)``
- ``Bitboard/^(_:_:)``
