import Foundation


func testPerft() {
    let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    let board = ChessBoard(fen: fen)
    
    let depth = 4
    let nodes = MoveGenerator.perft(board: board, depth: depth)
    
    print("Perft test for depth \(depth): \(nodes) nodes")
}

testPerft()