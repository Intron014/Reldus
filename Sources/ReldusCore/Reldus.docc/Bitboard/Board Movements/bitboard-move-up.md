# ``Bitboard/moveUp()``

Shifts the entire bitboard one square up.

## Summary

This method creates a new bitboard with all bits shifted up by one rank.

```swift
func moveUp() -> Bitboard
```

## Return Value

A new `Bitboard` instance with all bits shifted up by one rank.

## Discussion

The `moveUp()` method simulates moving all pieces on the board one square up. It uses a bitwise left shift operation (`<<`) by 8 positions, which is equivalent to moving up one rank on the chess board.

This operation is useful in move generation, particularly for analyzing vertical movements of pieces like rooks, queens, and pawns.

## Example

```swift
let originalBoard = Bitboard()
originalBoard.setBit(file: 0, rank: 1)  // Set bit at A2
let shiftedBoard = originalBoard.moveUp()
// The bit is now set at A3 in shiftedBoard
```

## See Also

- ``moveDown()``
- ``moveLeft()``
- ``moveRight()``
