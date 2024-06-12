import Foundation

class MoveValidator {
    
    func isMoveLegal(move: Move, board: ChessBoard) -> Bool {
        guard let piece = board.pieceAt(square: move.from), piece.color == board.turn else {
            return false
        }

        let boardCopy = board.copy()
        boardCopy.makeMove(move)

        let kingSquare = boardCopy.getKingSquare(for: piece.color)
        if boardCopy.isSquareUnderAttack(square: kingSquare, by: piece.color.opposite) {
            return false
        }

        return true
    }

	func isSquareUnderAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
        if isSquareUnderPawnAttack(board: board, square: square, by: color) {
            return true
        }

        if isSquareUnderKnightAttack(board: board, square: square, by: color) {
            return true
        }

        if isSquareUnderSlidingPieceAttack(board: board, square: square, by: color) {
            return true
        }

        if isSquareUnderKingAttack(board: board, square: square, by: color) {
            return true
        }

        return false
    }

    private func isSquareUnderPawnAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
        let pawnAttacks = color == .white ? board.getBitboard(for: .blackPawn) : board.getBitboard(for: .whitePawn)
        let attackOffsets = color == .white ? [-9, -7] : [7, 9]
        for offset in attackOffsets {
            let targetSquare = square + offset
            if targetSquare >= 0 && targetSquare < 64 && pawnAttacks.isBitSet(at: targetSquare) {
                return true
            }
        }
        return false
    }

    private func isSquareUnderKnightAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
        let knightAttacks = color == .white ? board.getBitboard(for: .blackKnight) : board.getBitboard(for: .whiteKnight)
        let knightMoves = [-17, -15, -10, -6, 6, 10, 15, 17]
        for move in knightMoves {
            let targetSquare = square + move
            if targetSquare >= 0 && targetSquare < 64 && knightAttacks.isBitSet(at: targetSquare) {
                return true
            }
        }
        return false
    }

    private func isSquareUnderSlidingPieceAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
        let rooksAndQueens = color == .white ? board.getBitboard(for: .blackRook) | board.getBitboard(for: .blackQueen) : board.getBitboard(for: .whiteRook) | board.getBitboard(for: .whiteQueen)
        let bishopsAndQueens = color == .white ? board.getBitboard(for: .blackBishop) | board.getBitboard(for: .blackQueen) : board.getBitboard(for: .whiteBishop) | board.getBitboard(for: .whiteQueen)

        if isSquareUnderRookLikeAttack(board: board, square: square, by: rooksAndQueens) {
            return true
        }

        if isSquareUnderBishopLikeAttack(board: board, square: square, by: bishopsAndQueens) {
            return true
        }

        return false
    }

    private func isSquareUnderRookLikeAttack(board: ChessBoard, square: Int, by bitboard: Bitboard) -> Bool {
        let directions = [-8, 8, -1, 1]
        return isSquareUnderSlidingAttack(board: board, square: square, by: bitboard, directions: directions)
    }

    private func isSquareUnderBishopLikeAttack(board: ChessBoard, square: Int, by bitboard: Bitboard) -> Bool {
        let directions = [-9, -7, 7, 9]
        return isSquareUnderSlidingAttack(board: board, square: square, by: bitboard, directions: directions)
    }

    private func isSquareUnderSlidingAttack(board: ChessBoard, square: Int, by bitboard: Bitboard, directions: [Int]) -> Bool {
        for direction in directions {
            var targetSquare = square + direction
            while targetSquare >= 0 && targetSquare < 64 {
                if bitboard.isBitSet(at: targetSquare) {
                    return true
                }
                targetSquare += direction
            }
        }
        return false
    }

    private func isSquareUnderKingAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
        let kingAttacks = color == .white ? board.getBitboard(for: .blackKing) : board.getBitboard(for: .whiteKing)
        let kingMoves = [-9, -8, -7, -1, 1, 7, 8, 9]
        for move in kingMoves {
            let targetSquare = square + move
            if targetSquare >= 0 && targetSquare < 64 && kingAttacks.isBitSet(at: targetSquare) {
                return true
            }
        }
        return false
    }
}
