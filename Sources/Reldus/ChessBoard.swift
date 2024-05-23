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

    func getFEN() -> String {
        var fen = ""
        for rank in (0..<8).reversed() {
            var emptySpaces = 0
            for file in 0..<8 {
                let square = squareIndex(file: file, rank: rank)
                var foundPiece: Character? = nil
                for (piece, bitboard) in bitboards {
                    if bitboard.isBitSet(at: square) {
                        foundPiece = piece.character
                        break
                    }
                }
                if foundPiece != nil {
                    if emptySpaces > 0 {
                        fen += String(emptySpaces)
                        emptySpaces = 0
                    }
                    fen += String(foundPiece!)
                } else {
                    emptySpaces += 1
                }
            }
            if emptySpaces > 0 {
                fen += String(emptySpaces)
            }
            if rank > 0 {
                fen += "/"
            }
        }
        fen += " "
        fen += (turn == .white) ? "w" : "b"
        return fen
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

        // Determine if the move results in a check
        let opponentColor = turn.opposite
        let opponentKingSquare = getKingSquare(for: opponentColor)
        move.isCheck = isSquareUnderAttack(square: opponentKingSquare, by: turn)
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
                rookFrom = squareIndex(file: 5, rank: turn == .white ? 0 : 7)
                rookTo = squareIndex(file: 7, rank: turn == .white ? 0 : 7)
            } else { // Queenside
                rookFrom = squareIndex(file: 3, rank: turn == .white ? 0 : 7)
                rookTo = squareIndex(file: 0, rank: turn == .white ? 0 : 7)
            }
            bitboards[turn == .white ? .whiteRook : .blackRook]?.clearBit(at: rookFrom)
            bitboards[turn == .white ? .whiteRook : .blackRook]?.setBit(at: rookTo)
        }

        turn = turn.opposite
    }

    func copy() -> ChessBoard {
        let board = ChessBoard()
        board.bitboards = bitboards
        board.occupancy = occupancy
        board.turn = turn
        return board
    }
    func getKingSquare(for color: Color) -> Int {
        let king = (color == .white) ? ChessPiece.whiteKing : ChessPiece.blackKing
        return bitboards[king]?.board.trailingZeroBitCount ?? -1
    }

    func isSquareUnderAttack(square: Int, by color: Color) -> Bool {
        let attackBitboard = generateAttackBitboard(color: color)
        return attackBitboard.isBitSet(at: square)
    }

    func generateAttackBitboard(color: Color) -> Bitboard {
        var attackBitboard = Bitboard()
        let moves = MoveGenerator.generateMoves(for: self, color: color)

        for move in moves {
            attackBitboard.setBit(at: move.to)
        }

        return attackBitboard
    }

    func getBitboard(for piece: ChessPiece) -> Bitboard {
        return bitboards[piece] ?? Bitboard()
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
}