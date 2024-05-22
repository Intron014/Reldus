import Foundation

func uciLoop() {
    let chessBoard = ChessBoard(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    chessBoard.printBoard()
}