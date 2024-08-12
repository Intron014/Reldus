# ``Bitboard/clearBit(at:)``

Clears the bit at a specified position in the bitboard.

## Summary

This method sets the bit at the given position to 0, regardless of its previous value.

```swift
mutating func clearBit(at position: Int)
```

## Parameters

- `position`: An integer representing the position of the bit to clear. Valid values are 0 to 63, where 0 represents the least significant bit (bottom-right square of the chess board) and 63 represents the most significant bit (top-left square).

## Discussion

The `clearBit(at:)` method uses the bitwise AND operation with an inverted mask to clear the specified bit. It creates a mask with all bits set to 1 except for the bit at the given position, then ANDs this mask with the current board state.

This operation is useful when you want to remove a piece from a specific square on the board or mark a square as unoccupied.

## Example

```swift
var bitboard = Bitboard()
bitboard.setBit(at: 8)  // Sets the bit at position 8
bitboard.clearBit(at: 8)  // Clears the bit at position 8
```

## See Also

- ``Bitboard``
