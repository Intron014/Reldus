# ``Bitboard/moveRight()``

Shifts the entire bitboard one square to the right.

## Summary

This method creates a new bitboard with all bits shifted one position to the right, wrapping around to the left edge of the board.

```swift
func moveRight() -> Bitboard
```

## Return Value

A new `Bitboard` instance with all bits shifted one position to the right.

## Discussion

The `moveRight()` method simulates moving all pieces on the board one square to the right. It uses a bitwise right shift operation (`>>`) and applies a mask to prevent bits from wrapping around to the previous rank.

This operation is useful in move generation, particularly for sliding pieces like rooks and queens, or for analyzing pawn structures.

## Example

```swift
let originalBoard = Bitboard()
originalBoard.setBit(file: 6, rank: 0)  // Set bit at G1
let shiftedBoard = originalBoard.moveRight()
// The bit is now set at H1 in shiftedBoard
```

## See Also

- ``moveLeft()``
- ``moveUp()``
- ``moveDown()``
