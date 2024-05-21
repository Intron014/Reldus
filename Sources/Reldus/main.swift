import Foundation

// Make a board

let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
let chessBoard = ChessBoard(fen: fen)
chessBoard.printBoard()
print(chessBoard.getFEN())

func testPerft() {
    let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    let board = ChessBoard(fen: fen)
    
    let depth = 3
    let nodes = MoveGenerator.perft(board: board, depth: depth)
    
    print("Perft \(depth) nodes: \(nodes.nodes)")
    print("Captures: \(nodes.captures)")
    print("En passants: \(nodes.enPassants)")
    print("Castles: \(nodes.castles)")
    print("Promotions: \(nodes.promotions)")
    print("Checks: \(nodes.checks)")

    
}

testPerft()
