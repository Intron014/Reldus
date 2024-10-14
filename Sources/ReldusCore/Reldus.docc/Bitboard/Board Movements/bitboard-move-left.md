# ``Bitboard/moveLeft()``

Shifts the entire bitboard one square to the left.

## Summary

This method creates a new bitboard with all bits shifted one position to the left, wrapping around to the right edge of the board.

```swift
func moveLeft() -> Bitboard
```

## Return Value

A new `Bitboard` instance with all bits shifted one position to the left.

## Discussion

The `moveLeft()` method simulates moving all pieces on the board one square to the left. It uses a bitwise left shift operation (`<<`) and applies a mask to prevent bits from wrapping around to the next rank.

This operation is useful in move generation, particularly for sliding pieces like rooks and queens, or for analyzing pawn structures.

## Example

```swift
let originalBoard = Bitboard()
originalBoard.setBit(file: 1, rank: 0)  // Set bit at B1
let shiftedBoard = originalBoard.moveLeft()
// The bit is now set at A1 in shiftedBoard
```

## See Also

- ``moveRight()``
- ``moveUp()``
- ``moveDown()``
