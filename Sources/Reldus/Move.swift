import Foundation

class Move {
  let piece: ChessPiece
  let from: Int
  let to: Int
  let capturedPiece: ChessPiece?
  let promotion: ChessPiece?
  let isEnPassant: Bool
  let isCastling: Bool
  var isCheck: Bool

  init(
    from: Int, to: Int, piece: ChessPiece, capturedPiece: ChessPiece? = nil,
    promotion: ChessPiece? = nil, isEnPassant: Bool = false, isCastling: Bool = false,
    isCheck: Bool = false
  ) {
    self.piece = piece
    self.from = from
    self.to = to
    self.capturedPiece = capturedPiece
    self.promotion = promotion
    self.isEnPassant = isEnPassant
    self.isCastling = isCastling
    self.isCheck = isCheck
  }
}

extension Move: CustomStringConvertible {
  var description: String {
    let fromSquare = squareToString(square: from)
    let toSquare = squareToString(square: to)
    return "\(piece.character): \(fromSquare)\(toSquare)"
  }
}

extension Move {
  func toUCI() -> String {
    let fromFile = Character(UnicodeScalar((from % 8) + 97)!)  // 'a' -> 97
    let fromRank = Character(UnicodeScalar((from / 8) + 49)!)  // '1' -> 49
    let toFile = Character(UnicodeScalar((to % 8) + 97)!)
    let toRank = Character(UnicodeScalar((to / 8) + 49)!)
    return "\(fromFile)\(fromRank)\(toFile)\(toRank)"
  }
}
