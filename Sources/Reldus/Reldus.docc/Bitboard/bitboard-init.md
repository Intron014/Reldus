# ``Bitboard/init(board:)``

Creates a new bitboard with the specified 64-bit integer value.


## Parameters
- `board`: A 64-bit unsigned integer representing the initial state of the bitboard. Defaults to 0 (empty board).

## Discussion
Use this initializer to create a new ``Bitboard`` instance with a specific bit pattern. If no value is provided, an empty bitboard (all bits set to 0) is created.

## Example
```swift
let emptyBoard = Bitboard()
let customBoard = Bitboard(board: 0x00FF00FF00FF00FF)
```
