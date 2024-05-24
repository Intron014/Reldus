import Foundation

// Make a board

// let fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
// let chessBoard = ChessBoard(fen: fen)
// chessBoard.printBoard()
// var mmove = Move(from: 8, to: 16, piece: .whitePawn)
// chessBoard.makeMove(mmove)
// chessBoard.printBoard()
// print(mmove.description)
// print(chessBoard.getFEN())


let uci = UCI()
uci.start()
