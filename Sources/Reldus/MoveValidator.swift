class MoveValidator {
    func isMoveLegal(move: Move, board: ChessBoard) -> Bool {
        guard move.from >= 0 && move.from < 64 && move.to >= 0 && move.to < 64 else {
            return false
        }

        let piece = board.pieceAt(square: move.from)
        guard piece != nil && piece!.color == board.turn else {
            return false
        }

        if let destinationPiece = board.pieceAt(square: move.to), destinationPiece.color == piece!.color {
            return false
        }

        switch piece {
            case .whitePawn, .blackPawn:
                return validatePawnMove(move: move, board: board, piece: piece!)
            case .whiteKnight, .blackKnight:
                return validateKnightMove(move: move)
            case .whiteBishop, .blackBishop:
                return validateBishopMove(move: move, board: board)
            case .whiteRook, .blackRook:
                return validateRookMove(move: move, board: board)
            case .whiteQueen, .blackQueen:
                return validateQueenMove(move: move, board: board)
            case .whiteKing, .blackKing:
                return validateKingMove(move: move, board: board)
            default:
                return false
        }
    }

    static func isMoveValid(board: ChessBoard, move: Move) -> Bool {
        let simulatedBoard = board.copy()
        simulatedBoard.makeMove(move)
        return !isKingInCheck(board: simulatedBoard, color: simulatedBoard.turn)
    }

    static func isKingInCheck(board: ChessBoard, color: Color) -> Bool {
        let kingSquare = board.getKingSquare(for: color)
        return board.isSquareUnderAttack(square: kingSquare, by: color.opposite)
    }

    static func willMoveExposeKing(board: ChessBoard, move: Move) -> Bool {
        let simulatedBoard = board.copy()
        simulatedBoard.makeMove(move)
        return isKingInCheck(board: simulatedBoard, color: simulatedBoard.turn)
    }

    private func validatePawnMove(move: Move, board: ChessBoard, piece: ChessPiece) -> Bool {
        let direction = (piece == .whitePawn) ? 1 : -1
        let startRank = (piece == .whitePawn) ? 1 : 6
        let toFile = move.to % 8
        let fromFile = move.from % 8

        if move.to == move.from + direction * 8 && board.pieceAt(square: move.to) == nil {
            return true
        }

        if move.to == move.from + direction * 16 && board.pieceAt(square: move.to) == nil && board.pieceAt(square: move.from + direction * 8) == nil && move.from / 8 == startRank {
            return true
        }
        if abs(toFile - fromFile) == 1 && move.to == move.from + direction * 8 + direction && board.pieceAt(square: move.to) != nil {
            return true
        }

        if abs(toFile - fromFile) == 1 && move.to == move.from + direction * 8 + direction && board.enPassantSquare == move.to {
            return true
        }

        return false
    }

    private func validateKnightMove(move: Move) -> Bool {
        let fromFile = move.from % 8
        let fromRank = move.from / 8
        let toFile = move.to % 8
        let toRank = move.to / 8
        let fileDiff = abs(fromFile - toFile)
        let rankDiff = abs(fromRank - toRank)

        return (fileDiff == 1 && rankDiff == 2) || (fileDiff == 2 && rankDiff == 1)
    }

    private func validateBishopMove(move: Move, board: ChessBoard) -> Bool {
        let fromFile = move.from % 8
        let fromRank = move.from / 8
        let toFile = move.to % 8
        let toRank = move.to / 8
        let fileDiff = abs(fromFile - toFile)
        let rankDiff = abs(fromRank - toRank)

        if fileDiff != rankDiff {
            return false
        }

        let fileStep = (toFile - fromFile) / fileDiff
        let rankStep = (toRank - fromRank) / rankDiff

        for step in 1..<fileDiff {
            let intermediateFile = fromFile + step * fileStep
            let intermediateRank = fromRank + step * rankStep
            if board.pieceAt(square: intermediateRank * 8 + intermediateFile) != nil {
                return false
            }
        }

        return true
    }

    private func validateRookMove(move: Move, board: ChessBoard) -> Bool {
        let fromFile = move.from % 8
        let fromRank = move.from / 8
        let toFile = move.to % 8
        let toRank = move.to / 8

        if fromFile != toFile && fromRank != toRank {
            return false
        }

        let fileStep = fromFile == toFile ? 0 : (toFile > fromFile ? 1 : -1)
        let rankStep = fromRank == toRank ? 0 : (toRank > fromRank ? 1 : -1)
        let steps = max(abs(fromFile - toFile), abs(fromRank - toRank))

        for step in 1..<steps {
            let intermediateFile = fromFile + step * fileStep
            let intermediateRank = fromRank + step * rankStep
            if board.pieceAt(square: intermediateRank * 8 + intermediateFile) != nil {
                return false
            }
        }

        return true
    }

    private func validateQueenMove(move: Move, board: ChessBoard) -> Bool {
        return validateBishopMove(move: move, board: board) || validateRookMove(move: move, board: board)
    }

    private func validateKingMove(move: Move, board: ChessBoard) -> Bool {
        let fromFile = move.from % 8
        let fromRank = move.from / 8
        let toFile = move.to % 8
        let toRank = move.to / 8
        let fileDiff = abs(fromFile - toFile)
        let rankDiff = abs(fromRank - toRank)

        if fileDiff <= 1 && rankDiff <= 1 {
            return true
        }

        if fileDiff == 2 && rankDiff == 0 {
            let rank = move.from / 8
            let rookFile = toFile == 2 ? 0 : 7
            let rookSquare = rank * 8 + rookFile
            if let rook = board.pieceAt(square: rookSquare), rook == (board.turn == .white ? .whiteRook : .blackRook) {
                let kingSide = toFile == 6
                let pathSquares = kingSide ? [5, 6] : [1, 2, 3]
                for offset in pathSquares {
                    if board.pieceAt(square: rank * 8 + offset) != nil {
                        return false
                    }
                }
                return true
            }
        }

        return false
    }
}