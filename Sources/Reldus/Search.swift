import Foundation

class Search {
    static func minimax(board: ChessBoard, depth: Int, maximizingPlayer: Bool) -> Int {
        if depth == 0 {
            return Evaluator.evaluate(board: board, color: maximizingPlayer ? .white : .black)
        }
        
        var value: Int
        if maximizingPlayer {
            value = Int.min
            let moves = MoveGenerator.generateMoves(for: board, color: .white)
            for move in moves {
                board.makeMove(move)
                value = max(value, minimax(board: board, depth: depth - 1, maximizingPlayer: false))
                board.undoMove(move)
            }
        } else {
            value = Int.max
            let moves = MoveGenerator.generateMoves(for: board, color: .black)
            for move in moves {
                board.makeMove(move)
                value = min(value, minimax(board: board, depth: depth - 1, maximizingPlayer: true))
                board.undoMove(move)
            }
        }
        return value
    }
}