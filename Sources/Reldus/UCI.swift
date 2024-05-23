import Foundation

class UCI {
    private var board: ChessBoard
    private var searchDepth: Int
    private let startPosFen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
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
            handleGo(command: command.joined(separator: " "), board: board)
        case "quit":
            handleQuit()
        case "board":
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
        board = ChessBoard(fen: startPosFen)
    }

    private func handlePosition(command: [Substring]) {
        guard command.count > 1 else { return }
        
        if command[1] == "startpos" {
            board = ChessBoard(fen: startPosFen)
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

    let move = Move(from: from, to: to, piece: piece, capturedPiece: capturedPiece, promotion: promotion, isEnPassant: isEnPassant, isCastling: isCastling, isCheck: false)

    let boardCopy = board.copy()
    boardCopy.makeMove(move)

    let opponentKingSquare = boardCopy.getKingSquare(for: piece.color.opposite)
    let isCheck = boardCopy.isSquareUnderAttack(square: opponentKingSquare, by: piece.color)
    move.isCheck = isCheck

    return move
}

    func handleGo(command: String, board: ChessBoard) {
        let parts = command.split(separator: " ")
        var depth = 3 // Default search depth
        
        if let depthIndex = parts.firstIndex(of: "depth"), depthIndex + 1 < parts.count {
            depth = Int(parts[depthIndex + 1]) ?? 3
        }
        
        var bestMove: Move?
        var bestValue = Int.min
        
        let moves = MoveGenerator.generateMoves(for: board, color: board.turn)
        
        for move in moves {
            board.makeMove(move)
            let boardCopy = board.copy()
            let moveValue = Search.minimax(board: boardCopy, depth: depth - 1, maximizingPlayer: false)
            board.undoMove(move)
            
            if moveValue > bestValue {
                bestValue = moveValue
                bestMove = move
            }
        }
        
        if let bestMove = bestMove {
            print("bestmove \(bestMove.toUCI())")
        } else {
            print("bestmove (none)")
        }
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
