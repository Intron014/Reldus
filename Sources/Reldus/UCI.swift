import Foundation

class UCI {
    private var board: ChessBoard
    private var searchDepth: Int
    
    init() {
        self.board = ChessBoard()
        self.searchDepth = 3
    }
}
