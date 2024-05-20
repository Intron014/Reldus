import Foundation

class ChessBoard {
    private var bitboards: [ChessPiece: Bitboard] = [:]
    private var occupancy: Bitboard = Bitboard()
    var turn: Color = .white

    init() {
        for piece in ChessPiece.allCases {
            bitboards[piece] = Bitboard()
        }
    }

    convenience init(fen: String) {
        self.init()
        loadFEN(fen)
    }

    private func squareIndex(file: Int, rank: Int) -> Int {
        return rank * 8 + file
    }

    func loadFEN(_ fen: String) {
        let parts = fen.split(separator: " ")
        guard parts.count > 0 else { return }
        
        let boardFEN = parts[0]
        let turnFEN = parts[1]
        let rows = boardFEN.split(separator: "/")
        
        turn = (turnFEN == "w") ? .white : .black
        
        for (rankIndex, row) in rows.reversed().enumerated() {
            var fileIndex = 0
            for char in row {
                if let piece = ChessPiece(character: char) {
                    let square = squareIndex(file: fileIndex, rank: rankIndex)
                    bitboards[piece]?.setBit(at: square)
                    occupancy.setBit(at: square)
                    fileIndex += 1
                } else if let emptySpaces = char.wholeNumberValue {
                    fileIndex += emptySpaces
                }
            }
        }
    }

    func printBoard() {
        for rank in (0..<8).reversed() {
            for file in 0..<8 {
                let square = squareIndex(file: file, rank: rank)
                var foundPiece: Character? = nil
                for (piece, bitboard) in bitboards {
                    if bitboard.isBitSet(at: square) {
                        foundPiece = piece.character
                        break
                    }
                }
                print(foundPiece ?? ".", terminator: " ")
            }
            print()
        }
    }

    func makeMove(_ move: Move) {
        bitboards[move.piece]?.clearBit(at: move.from)
        bitboards[move.piece]?.setBit(at: move.to)
        occupancy.clearBit(at: move.from)
        occupancy.setBit(at: move.to)
        
        if let capturedPiece = move.capturedPiece {
            bitboards[capturedPiece]?.clearBit(at: move.to)
        }

        if let promotionPiece = move.promotion {
            bitboards[move.piece]?.clearBit(at: move.to)
            bitboards[promotionPiece]?.setBit(at: move.to)
        }
        
        if move.isEnPassant {
            let capturedPawnSquare = move.to + (turn == .white ? -8 : 8)
            let capturedPawn = (turn == .white) ? ChessPiece.blackPawn : ChessPiece.whitePawn
            bitboards[capturedPawn]?.clearBit(at: capturedPawnSquare)
        }   
        
        if move.isCastling {
            let rookFrom, rookTo: Int
            if move.to == squareIndex(file: 6, rank: turn == .white ? 0 : 7) { // Kingside
                rookFrom = squareIndex(file: 7, rank: turn == .white ? 0 : 7)
                rookTo = squareIndex(file: 5, rank: turn == .white ? 0 : 7)
            } else { // Queenside
                rookFrom = squareIndex(file: 0, rank: turn == .white ? 0 : 7)
                rookTo = squareIndex(file: 3, rank: turn == .white ? 0 : 7)
            }
            bitboards[turn == .white ? .whiteRook : .blackRook]?.clearBit(at: rookFrom)
            bitboards[turn == .white ? .whiteRook : .blackRook]?.setBit(at: rookTo)
        }

        turn = turn.opposite
    }

    func undoMove(_ move: Move) {
        bitboards[move.piece]?.clearBit(at: move.to)
        bitboards[move.piece]?.setBit(at: move.from)
        occupancy.clearBit(at: move.to)
        occupancy.setBit(at: move.from)
        
        if let capturedPiece = move.capturedPiece {
            bitboards[capturedPiece]?.setBit(at: move.to)
        }

        if let promotionPiece = move.promotion {
            bitboards[promotionPiece]?.clearBit(at: move.to)
            bitboards[move.piece]?.setBit(at: move.from)
        }
        
        if move.isEnPassant {
            let capturedPawnSquare = move.to + (turn == .white ? -8 : 8)
            let capturedPawn = (turn == .white) ? ChessPiece.blackPawn : ChessPiece.whitePawn
            bitboards[capturedPawn]?.setBit(at: capturedPawnSquare)
        }
        
        if move.isCastling {
            let rookFrom, rookTo: Int
            if move.to == squareIndex(file: 6, rank: turn == .white ? 0 : 7) { // Kingside
                rookFrom = squareIndex(file: 7, rank: turn == .white ? 0 : 7)
                rookTo = squareIndex(file: 5, rank: turn == .white ? 0 : 7)
            } else { // Queenside
                rookFrom = squareIndex(file: 0, rank: turn == .white ? 0 : 7)
                rookTo = squareIndex(file: 3, rank: turn == .white ? 0 : 7)
            }
            bitboards[turn == .white ? .whiteRook : .blackRook]?.clearBit(at: rookTo)
            bitboards[turn == .white ? .whiteRook : .blackRook]?.setBit(at: rookFrom)
        }

        turn = turn.opposite
    }

    func isCheckmate() -> Bool {
        // TODO: Implement checkmate logic
        return false
    }

    func isStalemate() -> Bool {
        // TODO: Implement stalemate logic
        return false
    }

    func getBitboard(for piece: ChessPiece) -> Bitboard? {
        return bitboards[piece]
    }

    func getOccupancy() -> Bitboard {
        return occupancy
    }

    func pieceAt(square: Int) -> ChessPiece? {
        for (piece, bitboard) in bitboards {
            if bitboard.isBitSet(at: square) {
                return piece
            }
        }
        return nil
    }

    func copy() -> ChessBoard {
        let newBoard = ChessBoard()
        newBoard.bitboards = self.bitboards
        newBoard.occupancy = self.occupancy
        newBoard.turn = self.turn
        return newBoard
    }
}