# ``Bitboard/moveDown()``

Shifts the entire bitboard one square down.

## Summary

This method creates a new bitboard with all bits shifted down by one rank.

```swift
func moveDown() -> Bitboard
```

## Return Value

A new `Bitboard` instance with all bits shifted down by one rank.

## Discussion

The `moveDown()` method simulates moving all pieces on the board one square down. It uses a bitwise right shift operation (`>>`) by 8 positions, which is equivalent to moving down one rank on the chess board.

This operation is useful in move generation, particularly for analyzing vertical movements of pieces like rooks, queens, and pawns.

## Example

```swift
let originalBoard = Bitboard()
originalBoard.setBit(file: 0, rank: 6)  // Set bit at A7
let shiftedBoard = originalBoard.moveDown()
// The bit is now set at A6 in shiftedBoard
```

## See Also

- ``moveUp()``
- ``moveLeft()``
- ``moveRight()``
