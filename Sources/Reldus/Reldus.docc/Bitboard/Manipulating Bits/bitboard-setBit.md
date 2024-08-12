# ``Bitboard/setBit(at:)``

Sets the bit at the specified position to 1.

## Parameters
- `position`: The index of the bit to set (0-63).

## Discussion
This method modifies the bitboard by setting the bit at the given position to 1. The position is zero-indexed, with 0 representing the least significant bit (A1 square) and 63 representing the most significant bit (H8 square).

## Example
```swift
var board = Bitboard()
board.setBit(at: 8) // Sets the bit at position 8 (A2 square)
```

## See Also

- ``Bitboard``