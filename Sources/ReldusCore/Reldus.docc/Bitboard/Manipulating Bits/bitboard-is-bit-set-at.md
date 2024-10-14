# ``Bitboard/isBitSet(at:)``

Checks if the bit at a specified position in the bitboard is set.

## Summary

This method returns a boolean value indicating whether the bit at the given position is set (1) or not (0).

```swift
func isBitSet(at position: Int) -> Bool
```

## Parameters

- `position`: An integer representing the position of the bit to check. Valid values are 0 to 63, where 0 represents the least significant bit (bottom-right square of the chess board) and 63 represents the most significant bit (top-left square).

## Return Value

A boolean value: `true` if the bit is set (1), `false` if the bit is not set (0).

## Discussion

The `isBitSet(at:)` method uses the bitwise AND operation to check if the specified bit is set. It creates a mask with only the bit at the given position set to 1, then ANDs this mask with the current board state. If the result is non-zero, the bit is set.

This operation is useful when you want to check if a piece is present on a specific square or if a square is occupied.

## Example

```swift
var bitboard = Bitboard()
bitboard.setBit(at: 8)  // Sets the bit at position 8
let isSet = bitboard.isBitSet(at: 8)  // Returns true
let isNotSet = bitboard.isBitSet(at: 9)  // Returns false
```

## See Also

- ``Bitboard``
