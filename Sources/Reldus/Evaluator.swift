import Foundation

class Evaluator {
  // Piece values for material evaluation
  private static let pieceValues: [ChessPiece: Int] = [
    .whitePawn: 100, .whiteKnight: 320, .whiteBishop: 330, .whiteRook: 500, .whiteQueen: 900,
    .whiteKing: 20000,
    .blackPawn: -100, .blackKnight: -320, .blackBishop: -330, .blackRook: -500, .blackQueen: -900,
    .blackKing: -20000,
  ]

  private static let pawnTable: [Int] = [
    0, 0, 0, 0, 0, 0, 0, 0,
    50, 50, 50, 50, 50, 50, 50, 50,
    10, 10, 20, 30, 30, 20, 10, 10,
    5, 5, 10, 25, 25, 10, 5, 5,
    0, 0, 0, 20, 20, 0, 0, 0,
    5, -5, -10, 0, 0, -10, -5, 5,
    5, 10, 10, -20, -20, 10, 10, 5,
    0, 0, 0, 0, 0, 0, 0, 0,
  ]

  private static let knightTable: [Int] = [
    -50, -40, -30, -30, -30, -30, -40, -50,
    -40, -20, 0, 0, 0, 0, -20, -40,
    -30, 0, 10, 15, 15, 10, 0, -30,
    -30, 5, 15, 20, 20, 15, 5, -30,
    -30, 0, 15, 20, 20, 15, 0, -30,
    -30, 5, 10, 15, 15, 10, 5, -30,
    -40, -20, 0, 5, 5, 0, -20, -40,
    -50, -40, -30, -30, -30, -30, -40, -50,
  ]

  private static let bishopTable: [Int] = [
    -20, -10, -10, -10, -10, -10, -10, -20,
    -10, 0, 0, 0, 0, 0, 0, -10,
    -10, 0, 5, 10, 10, 5, 0, -10,
    -10, 5, 5, 10, 10, 5, 5, -10,
    -10, 0, 10, 10, 10, 10, 0, -10,
    -10, 10, 10, 10, 10, 10, 10, -10,
    -10, 5, 0, 0, 0, 0, 5, -10,
    -20, -10, -10, -10, -10, -10, -10, -20,
  ]

  private static let rookTable: [Int] = [
    0, 0, 0, 0, 0, 0, 0, 0,
    5, 10, 10, 10, 10, 10, 10, 5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    0, 0, 0, 5, 5, 0, 0, 0,
  ]

  private static let queenTable: [Int] = [
    -20, -10, -10, -5, -5, -10, -10, -20,
    -10, 0, 0, 0, 0, 0, 0, -10,
    -10, 0, 5, 5, 5, 5, 0, -10,
    -5, 0, 5, 5, 5, 5, 0, -5,
    0, 0, 5, 5, 5, 5, 0, -5,
    -10, 5, 5, 5, 5, 5, 0, -10,
    -10, 0, 5, 0, 0, 0, 0, -10,
    -20, -10, -10, -5, -5, -10, -10, -20,
  ]

  private static let kingTable: [Int] = [
    20, 30, 10, 0, 0, 10, 30, 20,
    20, 20, 0, 0, 0, 0, 20, 20,
    -10, -20, -20, -20, -20, -20, -20, -10,
    -20, -30, -30, -40, -40, -30, -30, -20,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
  ]

  static func evaluate(board: ChessBoard, color: Color) -> Int {
    var score = 0

    score += evaluateMaterial(board: board, color: color)
    score += evaluatePosition(board: board, color: color)

    return score
  }

  private static func evaluateMaterial(board: ChessBoard, color: Color) -> Int {
    var materialScore = 0
    for piece in ChessPiece.allCases {
      let pieceValue = pieceValues[piece] ?? 0
      let bitboard = board.getBitboard(for: piece)
      materialScore += pieceValue * bitboard.popCount()
    }
    return materialScore
  }

  private static func evaluatePosition(board: ChessBoard, color: Color) -> Int {
    var positionalScore = 0
    for piece in ChessPiece.allCases {
      let table = getPieceTable(piece: piece)
      let bitboard = board.getBitboard(for: piece)
      for square in bitboard.getOccupiedSquares() {
        let positionValue = table[square]
        positionalScore += piece.color == color ? positionValue : -positionValue
      }
    }
    return positionalScore
  }

  private static func getPieceTable(piece: ChessPiece) -> [Int] {
    switch piece {
    case .whitePawn, .blackPawn: return pawnTable
    case .whiteKnight, .blackKnight: return knightTable
    case .whiteBishop, .blackBishop: return bishopTable
    case .whiteRook, .blackRook: return rookTable
    case .whiteQueen, .blackQueen: return queenTable
    case .whiteKing, .blackKing: return kingTable
    }
  }
}
