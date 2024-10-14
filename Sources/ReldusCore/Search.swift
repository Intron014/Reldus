import Foundation

class Search {
  static func alphabeta(
    board: ChessBoard, depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool
  ) -> Int {
    if depth == 0 {
      return Evaluator.evaluate(board: board)
    }

    var alphaVar = alpha
    var betaVar = beta

    let moves = MoveGenerator.generateMoves(for: board, color: board.turn)
    
    if maximizingPlayer {
      var maxEval = Int.min
      for move in moves {
        board.makeMove(move)
        let eval = alphabeta(board: board, depth: depth - 1, alpha: alphaVar, beta: betaVar, maximizingPlayer: false)
        board.undoMove(move)
        maxEval = max(maxEval, eval)
        alphaVar = max(alphaVar, eval)
        if betaVar <= alphaVar {
          break
        }
      }
      return maxEval
    } else {
      var minEval = Int.max
      for move in moves {
        board.makeMove(move)
        let eval = alphabeta(board: board, depth: depth - 1, alpha: alphaVar, beta: betaVar, maximizingPlayer: true)
        board.undoMove(move)
        minEval = min(minEval, eval)
        betaVar = min(betaVar, eval)
        if betaVar <= alphaVar {
          break
        }
      }
      return minEval
    }
  }
}
