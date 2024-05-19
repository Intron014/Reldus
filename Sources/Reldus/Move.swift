import Foundation

struct Move {
    let from: Int
    let to: Int
    let piece: ChessPiece
    let capturedPiece: ChessPiece?
    let promotion: ChessPiece?
    
    init(from: Int, to: Int, piece: ChessPiece, capturedPiece: ChessPiece? = nil, promotion: ChessPiece? = nil) {
        self.from = from
        self.to = to
        self.piece = piece
        self.capturedPiece = capturedPiece
        self.promotion = promotion
    }
}