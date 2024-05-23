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
    }
    private func handleUCINewGame() {
    }
    private func handlePosition(command: [Substring]) {
    }
    private func applyMoves(moves: [Substring]) {
    }
    private func parseMove(moveString: String) -> Move? {
    }
    private func handleGo(command: [Substring]) {
    }
    private func searchBestMove() -> Move {
        let moves = MoveGenerator.generateMoves(for: board, color: board.turn)
        return moves.randomElement()! // Placeholder (Hopefully)
    }
    private func handleQuit() {
        exit(0)
    }
}
