import Foundation

struct Move {
    let piece: ChessPiece
    let from: Int
    let to: Int
    let capturedPiece: ChessPiece?
    let promotion: ChessPiece?
    let isEnPassant: Bool
    let isCastling: Bool
    let isCheck: Bool

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