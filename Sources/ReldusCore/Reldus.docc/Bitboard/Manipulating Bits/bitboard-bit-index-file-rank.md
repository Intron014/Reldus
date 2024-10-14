# ``Bitboard/bitIndex(file:rank:)``

Calculates the bit index for a given file and rank on the chess board.

## Summary

This method returns the bit index corresponding to the specified file and rank.

```swift
func bitIndex(file: Int, rank: Int) -> Int
```

## Parameters

- `file`: An integer representing the file (column) of the chess board. Valid values are 0 to 7, where 0 represents the A-file and 7 represents the H-file.
- `rank`: An integer representing the rank (row) of the chess board. Valid values are 0 to 7, where 0 represents the first rank and 7 represents the eighth rank.

## Return Value

An integer representing the bit index in the range 0 to 63.

## Discussion

The `bitIndex(file:rank:)` method converts chess board coordinates (file and rank) to a bit index used in the bitboard. It uses the formula `index = rank * 8 + file` to calculate the bit index.

This method is useful when you need to convert between chess notation and bitboard indices, particularly when implementing move generation or board evaluation functions.

## Example

```swift
let bitboard = Bitboard()
let index = bitboard.bitIndex(file: 0, rank: 1)  // Returns 8 (A2 square)
```

## See Also

- ``Bitboard``