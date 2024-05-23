import Foundation

class UCI {
    private var board: ChessBoard
    private var searchDepth: Int
    
    init() {
        self.board = ChessBoard()
        self.searchDepth = 3
    }

    func start() {
        while let line = readLine() {
            let command = line.split(separator: " ")
            handleCommand(command: Array(command))
        }
    }

    private func handleCommand(command: [Substring]) {
        guard let commandName = command.first else { return }

        switch commandName {
        case "uci":
            handleUCI()
        case "isready":
            handleIsReady()
        case "ucinewgame":
            handleUCINewGame()
        case "position":
            handlePosition(command: command)
        case "go":
            handleGo(command: command)
        case "quit":
            handleQuit()
        case "print":
            board.printBoard()
        default:
            print("Unknown command: \(commandName)")
        }
    }

    private func handleUCI() {
        print("id name Reldus")
        print("id author Intron014")
        print("uciok")
    }

    private func handleIsReady() {
        print("readyok")
    }

    private func handleUCINewGame() {
        board = ChessBoard(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    }

    private func handlePosition(command: [Substring]) {
        guard command.count > 1 else { return }
        
        if command[1] == "startpos" {
            board = ChessBoard()
            if command.count > 2 {
                applyMoves(moves: Array(command[3...]))
            }
        } else if command[1] == "fen" {
            let fenString = command[2...].prefix(6).joined(separator: " ")
            board = ChessBoard(fen: fenString)
            if command.count > 8 {
                applyMoves(moves: Array(command[9...]))
            }
        }
    }

    private func applyMoves(moves: [Substring]) {
        for moveString in moves {
            if let move = parseMove(moveString: String(moveString)) {
                board.makeMove(move)
            }
        }
    }

    private func parseMove(moveString: String) -> Move? {
        guard moveString.count >= 4 else { return nil }

        let fromFile = Int(moveString[moveString.startIndex].asciiValue! - Character("a").asciiValue!)
        let fromRank = Int(moveString[moveString.index(moveString.startIndex, offsetBy: 1)].asciiValue! - Character("1").asciiValue!)
        let toFile = Int(moveString[moveString.index(moveString.startIndex, offsetBy: 2)].asciiValue! - Character("a").asciiValue!)
        let toRank = Int(moveString[moveString.index(moveString.startIndex, offsetBy: 3)].asciiValue! - Character("1").asciiValue!)

        let from = fromRank * 8 + fromFile
        let to = toRank * 8 + toFile

        guard let piece = board.pieceAt(square: from) else { return nil }

        var capturedPiece: ChessPiece? = nil
        var promotion: ChessPiece? = nil
        var isEnPassant = false
        var isCastling = false
        var isCheck = false // TODO: Determine if the move results in check

        if let targetPiece = board.pieceAt(square: to) {
            capturedPiece = targetPiece
        } else if piece == .whitePawn || piece == .blackPawn, fromFile != toFile {
            // En passant capture
            let enPassantSquare = to + (piece.color == .white ? -8 : 8)
            if let captured = board.pieceAt(square: enPassantSquare), captured == piece.oppositePawn {
                capturedPiece = captured
                isEnPassant = true
            }
        }

        if moveString.count == 5 {
            switch moveString[moveString.index(moveString.startIndex, offsetBy: 4)] {
            case "q":
                promotion = (piece.color == .white) ? .whiteQueen : .blackQueen
            case "r":
                promotion = (piece.color == .white) ? .whiteRook : .blackRook
            case "b":
                promotion = (piece.color == .white) ? .whiteBishop : .blackBishop
            case "n":
                promotion = (piece.color == .white) ? .whiteKnight : .blackKnight
            default:
                break
            }
        }

        if piece == .whiteKing || piece == .blackKing {
            if abs(fromFile - toFile) == 2 {
                isCastling = true
            }
        }

        return Move(from: from, to: to, piece: piece, capturedPiece: capturedPiece, promotion: promotion, isEnPassant: isEnPassant, isCastling: isCastling, isCheck: isCheck)
    }

    private func handleGo(command: [Substring]) {
        let bestMove = searchBestMove()
        print("bestmove \(formatMove(move: bestMove))")
    }

    private func searchBestMove() -> Move {
        let moves = MoveGenerator.generateMoves(for: board, color: board.turn)
        for move in moves {
            print(move.description)
        }
        return moves.randomElement()! // Placeholder (Hopefully)
    }

    private func formatMove(move: Move) -> String {
        let fromFile = Character(UnicodeScalar(move.from % 8 + Int(Character("a").asciiValue!))!)
        let fromRank = Character(UnicodeScalar(move.from / 8 + Int(Character("1").asciiValue!))!)
        let toFile = Character(UnicodeScalar(move.to % 8 + Int(Character("a").asciiValue!))!)
        let toRank = Character(UnicodeScalar(move.to / 8 + Int(Character("1").asciiValue!))!)

        var moveString = "\(fromFile)\(fromRank)\(toFile)\(toRank)"

        if let promotion = move.promotion {
            switch promotion {
            case .whiteQueen, .blackQueen:
                moveString += "q"
            case .whiteRook, .blackRook:
                moveString += "r"
            case .whiteBishop, .blackBishop:
                moveString += "b"
            case .whiteKnight, .blackKnight:
                moveString += "n"
            default:
                break
            }
        }

        return moveString
    }

    private func handleQuit() {
        exit(0)
    }
}
