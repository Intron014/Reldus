# ``Bitboard/popCount()``

Counts the number of set bits in the bitboard.

## Summary

This method returns the number of bits that are set to 1 in the bitboard.

```swift
func popCount() -> Int
```

## Return Value

An integer representing the number of set bits in the bitboard.

## Discussion

The `popCount()` method, also known as population count or Hamming weight, counts the number of set bits in the bitboard. This operation is useful for quickly determining the number of pieces on the board or the number of squares in a particular state.

In chess programming, this can be used to count the number of pieces of a certain type, the number of attacked squares, or the number of legal moves in a position.

## Example

```swift
var board = Bitboard()
board.setBit(file: 0, rank: 0)  // Set bit at A1
board.setBit(file: 