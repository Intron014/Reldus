import Foundation

// Make a board

let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
let chessBoard = ChessBoard(fen: fen)
chessBoard.printBoard()
var mmove = Move(from: 8, to: 16, piece: .whitePawn)
chessBoard.makeMove(mmove)
chessBoard.printBoard()
print(mmove.description)
print(chessBoard.getFEN())



func testPerft() {
    let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    let board = ChessBoard(fen: fen)
    let depth = 1
    let nodes = perft(board: board, depth: depth)
    
    print("Perft \(depth) nodes: \(nodes.nodes)")
    print("Captures: \(nodes.captures)")
    print("En passants: \(nodes.enPassants)")
    print("Castles: \(nodes.castles)")
    print("Promotions: \(nodes.promotions)")
    print("Checks: \(nodes.checks)")

    
}

testPerft()
