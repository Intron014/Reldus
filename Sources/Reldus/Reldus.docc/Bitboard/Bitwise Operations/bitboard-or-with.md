# ``Bitboard/or(with:)``

Performs a bitwise OR operation with another bitboard.

## Summary

This method creates a new bitboard that is the result of a bitwise OR operation between the current bitboard and the provided bitboard.

```swift
func or(with bitboard: Bitboard) -> Bitboard
```

## Parameters

- `bitboard`: Another `Bitboard` instance to perform the OR operation with.

## Return Value

A new `Bitboard` instance representing the result of the OR operation.

## Discussion

The `or(with:)` method performs a bitwise OR operation between two bitboards. This operation is useful for combining different piece positions or for adding masks to a bitboard.

In chess programming, this can be used to create a combined set of squares occupied by different piece types or to add attack patterns together.

## Example

```swift
let board1 = Bitboard()
board1.setBit(file: 0, rank: 0)  // Set bit at A1
board1.setBit(file: 1, rank: 1)  // Set bit at B2

let board2 = Bitboard()
board2.setBit(file: 1, rank: 1)  // Set bit at B2
board2.setBit(file: 2, rank: 2)  // Set bit at C3

let result = board1.or(with: board2)
// result now has bits set at A1, B2, and C3
```

## See Also

- ``and(with:)``
- ``Bitboard/|(_:_:)``
