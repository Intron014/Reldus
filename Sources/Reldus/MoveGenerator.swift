import Foundation

class MoveGenerator {
    
    static func generateMoves(for board: ChessBoard, color: Color) -> [Move] {
        var moves: [Move] = []

        moves.append(contentsOf: generatePawnMoves(for: board, color: color))
        moves.append(contentsOf: generateKnightMoves(for: board, color: color))
        moves.append(contentsOf: generateSlidingPieceMoves(for: board, color: color, pieceTypes: slidingPieces(for: color)))
        moves.append(contentsOf: generateKingMoves(for: board, color: color))
        
        return moves
    }
    
    private static func generatePawnMoves(for board: ChessBoard, color: Color) -> [Move] {
        var moves: [Move] = []
        let pawnBitboard = board.getBitboard(for: color == .white ? .whitePawn : .blackPawn)!
        let direction = color == .white ? 1 : -1
        
        for square in 0..<64 {
            if pawnBitboard.isBitSet(at: square) {
                let file = square % 8
                let rank = square / 8
                let toSquare = (rank + direction) * 8 + file
                
                if !board.getOccupancy().isBitSet(at: toSquare) {
                    let mmove = Move(from: square, to: toSquare, piece: color == .white ? .whitePawn : .blackPawn)
                    // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                    //     moves.append(mmove)
                    // }
                    moves.append(mmove)
                    
                    if (color == .white && rank == 1) || (color == .black && rank == 6) {
                        let doubleSquare = (rank + 2 * direction) * 8 + file
                        if !board.getOccupancy().isBitSet(at: doubleSquare) {
                            let mmove = Move(from: square, to: doubleSquare, piece: color == .white ? .whitePawn : .blackPawn)
                            // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                            //     moves.append(mmove)
                            // }
                            moves.append(mmove)
                        }
                    }
                }
                
                
                if file > 0 {
                    let captureSquare = (rank + direction) * 8 + (file - 1)
                    if board.getOccupancy().isBitSet(at: captureSquare), let capturedPiece = board.pieceAt(square: captureSquare), capturedPiece.character.isUppercase != (color == .white) {
                        let mmove = Move(from: square, to: captureSquare, piece: color == .white ? .whitePawn : .blackPawn, capturedPiece: capturedPiece)
                        // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                        //     moves.append(mmove)
                        // }
                        moves.append(mmove)
                    }
                }
                
                if file < 7 { 
                    let captureSquare = (rank + direction) * 8 + (file + 1)
                    if board.getOccupancy().isBitSet(at: captureSquare), let capturedPiece = board.pieceAt(square: captureSquare), capturedPiece.character.isUppercase != (color == .white) {
                        let mmove = Move(from: square, to: captureSquare, piece: color == .white ? .whitePawn : .blackPawn, capturedPiece: capturedPiece)
                        // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                        //     moves.append(mmove)
                        // }
                        moves.append(mmove)
                    }
                }
            }
        }
        
        return moves
    }
    
    private static func generateKnightMoves(for board: ChessBoard, color: Color) -> [Move] {
        var moves: [Move] = []
        let knightBitboard = board.getBitboard(for: color == .white ? .whiteKnight : .blackKnight)!
        let knightMoves: [(Int, Int)] = [(-2, -1), (-1, -2), (1, -2), (2, -1), (2, 1), (1, 2), (-1, 2), (-2, 1)]
        
        for square in 0..<64 {
            if knightBitboard.isBitSet(at: square) {
                let file = square % 8
                let rank = square / 8
                
                for (df, dr) in knightMoves {
                    let newFile = file + df
                    let newRank = rank + dr
                    if newFile >= 0, newFile < 8, newRank >= 0, newRank < 8 {
                        let toSquare = newRank * 8 + newFile
                        if !board.getOccupancy().isBitSet(at: toSquare) {
                            let mmove = Move(from: square, to: toSquare, piece: color == .white ? .whiteKnight : .blackKnight)
                            // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                            //     moves.append(mmove)
                            // }
                            moves.append(mmove)
                        } else if let capturedPiece = board.pieceAt(square: toSquare), capturedPiece.character.isUppercase != (color == .white) {
                            let mmove = Move(from: square, to: toSquare, piece: color == .white ? .whiteKnight : .blackKnight, capturedPiece: capturedPiece)
                            // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                            //     moves.append(mmove)
                            // }
                            moves.append(mmove)
                        }
                    }
                }
            }
        }
        
        return moves
    }

    private static func generateSlidingPieceMoves(for board: ChessBoard, color: Color, pieceTypes: [ChessPiece]) -> [Move] {
        var moves: [Move] = []
        let directions: [ChessPiece: [(Int, Int)]] = [
            .whiteBishop: [(-1, -1), (1, -1), (1, 1), (-1, 1)],
            .blackBishop: [(-1, -1), (1, -1), (1, 1), (-1, 1)],
            .whiteRook: [(-1, 0), (1, 0), (0, -1), (0, 1)],
            .blackRook: [(-1, 0), (1, 0), (0, -1), (0, 1)],
            .whiteQueen: [(-1, -1), (1, -1), (1, 1), (-1, 1), (-1, 0), (1, 0), (0, -1), (0, 1)],
            .blackQueen: [(-1, -1), (1, -1), (1, 1), (-1, 1), (-1, 0), (1, 0), (0, -1), (0, 1)]]
        for pieceType in pieceTypes {
            let pieceBitboard = board.getBitboard(for: pieceType)!
            for square in 0..<64 {
                if pieceBitboard.isBitSet(at: square) {
                    let file = square % 8
                    let rank = square / 8

                    if let pieceDirections = directions[pieceType] {
                        for (df, dr) in pieceDirections {
                            var newFile = file + df
                            var newRank = rank + dr
                            while newFile >= 0, newFile < 8, newRank >= 0, newRank < 8 {
                                let toSquare = newRank * 8 + newFile
                                if !board.getOccupancy().isBitSet(at: toSquare) {
                                    let mmove = Move(from: square, to: toSquare, piece: pieceType)
                                    // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                                    //     moves.append(mmove)
                                    // }
                                    moves.append(mmove)
                                } else if let capturedPiece = board.pieceAt(square: toSquare), capturedPiece.character.isUppercase != (color == .white) {
                                    let mmove = Move(from: square, to: toSquare, piece: pieceType, capturedPiece: capturedPiece)
                                    // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                                    //     moves.append(mmove)
                                    // }
                                    moves.append(mmove)
                                    break
                                } else {
                                    break
                                }
                                newFile += df
                                newRank += dr
                            }
                        }
                    }
                }
            }
        }
        return moves
    }

    private static func generateKingMoves(for board: ChessBoard, color: Color) -> [Move] {
        var moves: [Move] = []
        let kingBitboard = board.getBitboard(for: color == .white ? .whiteKing : .blackKing)!
        let kingMoves: [(Int, Int)] = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
        for square in 0..<64 {
            if kingBitboard.isBitSet(at: square) {
                let file = square % 8
                let rank = square / 8
                
                for (df, dr) in kingMoves {
                    let newFile = file + df
                    let newRank = rank + dr
                    if newFile >= 0, newFile < 8, newRank >= 0, newRank < 8 {
                        let toSquare = newRank * 8 + newFile
                        if !board.getOccupancy().isBitSet(at: toSquare) {
                            let mmove: Move = Move(from: square, to: toSquare, piece: color == .white ? .whiteKing : .blackKing)
                            // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                            //     moves.append(mmove)
                            // }
                            moves.append(mmove)
                        } else if let capturedPiece = board.pieceAt(square: toSquare), capturedPiece.character.isUppercase != (color == .white) {
                            let mmove: Move = Move(from: square, to: toSquare, piece: color == .white ? .whiteKing : .blackKing, capturedPiece: capturedPiece)
                            // if MoveValidator().isMoveLegal(move: mmove, board: board) {
                            //     moves.append(mmove)
                            // }
                            moves.append(mmove)
                        }
                    }
                }
            }
        }
        
        return moves
    }
    
    private static func slidingPieces(for color: Color) -> [ChessPiece] {
        return color == .white ? [.whiteBishop, .whiteRook, .whiteQueen] : [.blackBishop, .blackRook, .blackQueen]
    }
}