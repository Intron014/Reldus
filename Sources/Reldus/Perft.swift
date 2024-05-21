import Foundation

struct PerftResult {
    var nodes: Int = 0
    var captures: Int = 0
    var enPassants: Int = 0
    var castles: Int = 0
    var promotions: Int = 0
    var checks: Int = 0
}


func perft(board: ChessBoard, depth: Int) -> PerftResult {

    if depth == 0 {
        return PerftResult(nodes: 1)
    }
    var result = PerftResult()
    let moves = MoveGenerator.generateMoves(for: board, color: .white)
    
    for move in moves {
        board.makeMove(move)
        let perftResult = perft(board: board, depth: depth - 1)
        print(move.description)
        result.nodes += perftResult.nodes
        result.captures += perftResult.captures
        result.enPassants += perftResult.enPassants
        result.castles += perftResult.castles
        result.promotions += perftResult.promotions
        result.checks += perftResult.checks
        if move.capturedPiece != nil {
            result.captures += 1
        }
        if move.isEnPassant {
            result.enPassants += 1
        }
        if move.isCastling {
            result.castles += 1
        }
        if move.promotion != nil {
            result.promotions += 1
        }
        if move.isCheck {
            result.checks += 1
        }
        board.undoMove(move)
    }
    return result
}