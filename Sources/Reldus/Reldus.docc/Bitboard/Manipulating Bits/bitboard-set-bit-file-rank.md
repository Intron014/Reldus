# ``Bitboard/setBit(file:rank:)``

Sets the bit at a specified file and rank in the bitboard.

## Summary

This method sets the bit at the given file and rank to 1, regardless of its previous value.

```swift
mutating func setBit(file: Int, rank: Int)
```

## Parameters

- `file`: An integer representing the file (column) of the chess board. Valid values are 0 to 7, where 0 represents the A-file and 7 represents the H-file.
- `rank`: An integer representing the rank (row) of the chess board. Valid values are 0 to 7, where 0 represents the first rank and 7 represents the eighth rank.

## Discussion

The `setBit(file:rank:)` method converts the given file and rank to a bit position and then sets that bit. It uses the formula `position = rank * 8 + file` to calculate the bit position.

This operation is useful when you want to add a piece to a specific square on the board using chess notation (file and rank) instead of a bit position.

## Example

```swift
var bitboard = Bitboard()
bitboard.setBit(file: 0, rank: 1)  // Sets the bit at A2 (file 0, rank 1)
```

## See Also

- ``Bitboard``
