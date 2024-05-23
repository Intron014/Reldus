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

    init(from: Int, to: Int, piece: ChessPiece, capturedPiece: ChessPiece? = nil, promotion: ChessPiece? = nil, isEnPassant: Bool = false, isCastling: Bool = false, isCheck: Bool = false) {
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