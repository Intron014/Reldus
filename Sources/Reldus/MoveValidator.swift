import Foundation

class MoveValidator {
    func isMoveLegal(move: Move, board: ChessBoard) -> Bool {
        guard let piece = board.pieceAt(square: move.from) else {
            return false
        }
        
        guard piece == move.piece else {
            return false
        }
        
        guard move.from >= 0 && move.from < 64 && move.to >= 0 && move.to < 64 else {
            return false
        }
        
        guard isValidPieceMove(move: move, board: board) else {
            return false
        }
        
        guard doesMoveLeaveKingSafe(move: move, board: board) else {
            return false
        }
        
        return true
    }

    private func isValidPieceMove(move: Move, board: ChessBoard) -> Bool {
        switch move.piece {
        case .whitePawn, .blackPawn:
            return isValidPawnMove(move: move, board: board)
        case .whiteKnight, .blackKnight:
            return isValidKnightMove(move: move)
        case .whiteBishop, .blackBishop:
            return isValidBishopMove(move: move, board: board)
        case .whiteRook, .blackRook:
            return isValidRookMove(move: move, board: board)
        case .whiteQueen, .blackQueen:
            return isValidQueenMove(move: move, board: board)
        case .whiteKing, .blackKing:
            return isValidKingMove(move: move, board: board)
        }
    }

    private func isValidPawnMove(move: Move, board: ChessBoard) -> Bool {
        let direction = (move.piece == .whitePawn) ? 8 : -8
        let startRank = (move.piece == .whitePawn) ? 1 : 6
        let targetRank = (move.piece == .whitePawn) ? 7 : 0
        
        if move.to == move.from + direction && !board.getOccupancy().isBitSet(at: move.to) {
            return true
        }
        
        if move.from / 8 == startRank && move.to == move.from + 2 * direction && !board.getOccupancy().isBitSet(at: move.to) && !board.getOccupancy().isBitSet(at: move.from + direction) {
            return true
        }
        
        if abs((move.to % 8) - (move.from % 8)) == 1 && move.to == move.from + direction && board.pieceAt(square: move.to) != nil {
            return true
        }
        
        if move.isEnPassant {
            let capturedPawnSquare = move.to + ((move.piece == .whitePawn) ? -8 : 8)
            if let capturedPawn = board.pieceAt(square: capturedPawnSquare), capturedPawn == (move.piece == .whitePawn ? .blackPawn : .whitePawn) {
                return true
            }
        }
        
        return false
    }

    private func isValidKnightMove(move: Move) -> Bool {
        let knightMoves = [15, 17, -15, -17, 10, -10, 6, -6]
        return knightMoves.contains(move.to - move.from)
    }

    private func isValidBishopMove(move: Move, board: ChessBoard) -> Bool {
        return isValidDiagonalMove(move: move, board: board)
    }

    private func isValidRookMove(move: Move, board: ChessBoard) -> Bool {
        return isValidStraightMove(move: move, board: board)
    }

    private func isValidQueenMove(move: Move, board: ChessBoard) -> Bool {
        return isValidStraightMove(move: move, board: board) || isValidDiagonalMove(move: move, board: board)
    }

    private func isValidKingMove(move: Move, board: ChessBoard) -> Bool {
        let kingMoves = [1, -1, 8, -8, 7, -7, 9, -9]
        if kingMoves.contains(move.to - move.from) {
            return true
        }
        
        if move.isCastling {
            if isCastlingLegal(move: move, board: board) {
                return true
            }
        }
        
        return false
    }

    private func isValidStraightMove(move: Move, board: ChessBoard) -> Bool {
        let direction = move.to > move.from ? 1 : -1
        let diff = abs(move.to - move.from)
        if diff % 8 == 0 {
            for i in stride(from: move.from + direction * 8, to: move.to, by: direction * 8) {
                if board.getOccupancy().isBitSet(at: i) {
                    return false
                }
            }
            return true
        } else if move.from / 8 == move.to / 8 {
            for i in stride(from: move.from + direction, to: move.to, by: direction) {
                if board.getOccupancy().isBitSet(at: i) {
                    return false
                }
            }
            return true
        }
        return false
    }

    private func isValidDiagonalMove(move: Move, board: ChessBoard) -> Bool {
        let diff = abs(move.to - move.from)
        let direction = (move.to > move.from) ? 1 : -1
        if diff % 7 == 0 {
            for i in stride(from: move.from + direction * 7, to: move.to, by: direction * 7) {
                if board.getOccupancy().isBitSet(at: i) {
                    return false
                }
            }
            return true
        } else if diff % 9 == 0 {
            for i in stride(from: move.from + direction * 9, to: move.to, by: direction * 9) {
                if board.getOccupancy().isBitSet(at: i) {
                    return false
                }
            }
            return true
        }
        return false
    }

    private func isCastlingLegal(move: Move, board: ChessBoard) -> Bool {
        let king = (move.piece == .whiteKing) ? ChessPiece.whiteKing : ChessPiece.blackKing
        let rook = (move.piece == .whiteKing) ? ChessPiece.whiteRook : ChessPiece.blackRook
        
        if move.to == move.from + 2 {
            let rookFrom = move.from + 3
            if board.pieceAt(square: move.from + 1) == nil && board.pieceAt(square: move.from + 2) == nil && board.pieceAt(square: rookFrom) == rook {
                if !board.isSquareUnderAttack(square: move.from, by: board.turn.opposite) &&
                   !board.isSquareUnderAttack(square: move.from + 1, by: board.turn.opposite) &&
                   !board.isSquareUnderAttack(square: move.from + 2, by: board.turn.opposite) {
                    return true
                }
            }
        }
        
        if move.to == move.from - 2 {
            let rookFrom = move.from - 4
            if board.pieceAt(square: move.from - 1) == nil && board.pieceAt(square: move.from - 2) == nil && board.pieceAt(square: move.from - 3) == nil && board.pieceAt(square: rookFrom) == rook {
                if !board.isSquareUnderAttack(square: move.from, by: board.turn.opposite) &&
                   !board.isSquareUnderAttack(square: move.from - 1, by: board.turn.opposite) &&
                   !board.isSquareUnderAttack(square: move.from - 2, by: board.turn.opposite) {
                    return true
                }
            }
        }
        
        return false
    }

    private func doesMoveLeaveKingSafe(move: Move, board: ChessBoard) -> Bool {
        let updatedBoard = board.copy() 
        updatedBoard.makeMove(move) 
        let kingSquare = updatedBoard.getKingSquare(for: board.turn) 

        return !updatedBoard.isSquareUnderAttack(square: kingSquare, by: board.turn.opposite)
    }
}