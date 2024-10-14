# ``Bitboard``

A struct that represents a bitboard, a 64-bit integer that represents a chess board.

## Overview

The `Bitboard` struct provides a compact and efficient way to represent a chess board using a 64-bit integer. Each bit in the integer corresponds to a square on the chess board, allowing for fast bitwise operations to manipulate and analyze the board state.

Bitboards offer several advantages in chess programming:

- Memory efficiency: A single 64-bit integer can represent the entire board state for a single piece type or color.
- Fast operations: Bitwise operations allow for quick move generation and board analysis.
- Simplified algorithms: Many chess algorithms can be expressed more concisely using bitboards.

Common operations on bitboards include:

- Setting a bit: Use the bitwise OR operation with a mask.
- Clearing a bit: Use the bitwise AND operation with an inverted mask.
- Checking if a bit is set: Use the bitwise AND operation with a mask.

## Topics

### Creating a Bitboard

- ``init(board:)``

### Manipulating Bits

- ``setBit(at:)``
- ``clearBit(at:)``
- ``isBitSet(at:)``
- ``setBit(file:rank:)``
- ``clearBit(file:rank:)``
- ``bitIndex(file:rank:)``

### Board Movements

- ``moveLeft()``
- ``moveRight()``
- ``moveUp()``
- ``moveDown()``

### Bitwise Operations

- ``and(with:)``
- ``or(with:)``

### Operators

- ``Bitboard/|(_:_:)``
- ``Bitboard/&(_:_:)``
- ``Bitboard/^(_:_:)``
- ``Bitboard/~(_:)``

### Board Analysis

- ``popCount()``
- ``getOccupiedSquares()``
