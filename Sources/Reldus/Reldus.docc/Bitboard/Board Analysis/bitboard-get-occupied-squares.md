# ``Bitboard/getOccupiedSquares()``

Returns an array of indices corresponding to set bits in the bitboard.

## Summary

This method returns an array of integers representing the indices of all set bits in the bitboard.

```swift
func getOccupiedSquares() -> [Int]
```

## Return Value

An array of integers, each representing the index of a set bit in the bitboard.

## Discussion

The `getOccupiedSquares()` method is useful for converting the bitboard representation into a more traditional board representation. It returns the indices of all set bits, which can be interpreted as the positions of pieces or occupied squares on the chess board.

In chess programming, this method can be used to iterate over all pieces of a certain type, to convert bitboard positions to algebraic notation, or to interface with other parts of a chess engine that may not use bitboard representation.

## Example

```swift
var board = Bitboard()
board.setBit(file: 0, rank: 0)  // Set bit at A1
board.setBit(file: 1, rank: 1)  // Set bit at B2
board.setBit(file: 2, rank: 2)  // Set bit at C3

let occupiedSquares = board.getOccupiedSquares()
// Returns [0, 9, 18] (indices corresponding to A1, B2, C3)
```

## See Also

- ``popCount()``
- ``isBitSet(at:)``
