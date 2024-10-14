# Getting Started with Reldus
Understanding and using bitboards in chess programming.
## Introduction

Bitboards are a powerful tool in chess programming, offering a compact and efficient way to represent a chess board. This article explains the basics of bitboards and how to use them effectively.
## What is a Bitboard?

A bitboard is a 64-bit integer where each bit represents a square on the chess board. The least significant bit represents the A1 square, and the most significant bit represents the H8 square.
## Advantages of Bitboards

- Memory efficiency: A single 64-bit integer can represent the entire board state for a single piece type or color.
- Fast operations: Bitwise operations allow for quick move generation and board analysis.
- Simplified algorithms: Many chess algorithms can be expressed more concisely using bitboards.
## Common Operations

- Setting a bit: Use the bitwise OR operation with a mask.
- Clearing a bit: Use the bitwise AND operation with an inverted mask.
- Checking if a bit is set: Use the bitwise AND operation with a mask.
## Conclusion

Mastering bitboards is crucial for developing efficient chess engines. The `Bitboard` struct in this module provides a solid foundation for working with bitboards in Swift.

## See Also

- ``Bitboard``