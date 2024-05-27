import Foundation

struct Bitboard {
  var board: UInt64 = 0

  mutating func setBit(at position: Int) {
    board |= (1 << position)
  }

  mutating func clearBit(at position: Int) {
    board &= ~(1 << position)
  }

  func isBitSet(at position: Int) -> Bool {
    return (board & (1 << position)) != 0
  }

  mutating func setBit(file: Int, rank: Int) {
    let position = rank * 8 + file
    setBit(at: position)
  }

  mutating func clearBit(file: Int, rank: Int) {
    let position = rank * 8 + file
    clearBit(at: position)
  }

  func bitIndex(file: Int, rank: Int) -> Int {
    return rank * 8 + file
  }

  func moveLeft() -> Bitboard {
    return Bitboard(board: (board << 1) & ~0x0101_0101_0101_0101)
  }

  func moveRight() -> Bitboard {
    return Bitboard(board: (board >> 1) & ~0x8080_8080_8080_8080)
  }

  func moveUp() -> Bitboard {
    return Bitboard(board: board << 8)
  }

  func moveDown() -> Bitboard {
    return Bitboard(board: board >> 8)
  }

  func and(with bitboard: Bitboard) -> Bitboard {
    return Bitboard(board: board & bitboard.board)
  }

  func or(with bitboard: Bitboard) -> Bitboard {
    return Bitboard(board: board | bitboard.board)
  }

  func popCount() -> Int {
    return board.nonzeroBitCount
  }

  func getOccupiedSquares() -> [Int] {
    var occupiedSquares = [Int]()
    for index in 0..<64 {
      if isBitSet(at: index) {
        occupiedSquares.append(index)
      }
    }
    return occupiedSquares
  }
}
