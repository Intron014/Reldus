import Foundation

class MoveValidator {
	
	func isMoveLegal(move: Move, board: ChessBoard) -> Bool {
		guard let piece = board.pieceAt(square: move.from), piece.color == board.turn else {
			return false
		}
		
		let boardCopy = board.copy()
		boardCopy.makeMove(move)
		
		let kingSquare = boardCopy.getKingSquare(for: piece.color)
		if boardCopy.isSquareUnderAttack(square: kingSquare, by: piece.color.opposite) {
			return false
		}
		
		if move.isCastling {
			return isCastlingLegal(board: board, move: move)
		}
		
		if move.isEnPassant {
			return isEnPassantLegal(board: board, move: move)
		}
		
		return true
	}
	
	private func isCastlingLegal(board: ChessBoard, move: Move) -> Bool {
		let kingSideCastleSquares = [6, 62]
		let queenSideCastleSquares = [2, 58]
		
		if kingSideCastleSquares.contains(move.to) {
			let emptySquares = [5, 6]
			for square in emptySquares {
				if board.getOccupancy().isBitSet(at: square) || board.isSquareUnderAttack(square: square, by: board.turn.opposite) {
					return false
				}
			}
		} else if queenSideCastleSquares.contains(move.to) {
			let emptySquares = [1, 2, 3]
			for square in emptySquares {
				if board.getOccupancy().isBitSet(at: square) || board.isSquareUnderAttack(square: square, by: board.turn.opposite) {
					return false
				}
			}
		}
		
		return true
	}
	
	private func isEnPassantLegal(board: ChessBoard, move: Move) -> Bool {
		guard let enPassantSquare = board.enPassantSquare else {
			return false
		}
		
		if move.to == enPassantSquare {
			let capturedPawnSquare = enPassantSquare + (board.turn == .white ? -8 : 8)
			if board.turn == .white {
				if let capturedPawn = board.pieceAt(square: capturedPawnSquare), capturedPawn.character == "p" {
					return true
				}
			} else {
				if let capturedPawn = board.pieceAt(square: capturedPawnSquare), capturedPawn.character == "P" {
					return true
				}
			}
		}
		return false
	}
}

extension MoveValidator {
	
	func isSquareUnderAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
		if isSquareUnderPawnAttack(board: board, square: square, by: color) {
			return true
		}
		
		if isSquareUnderKnightAttack(board: board, square: square, by: color) {
			return true
		}
		
		if isSquareUnderSlidingPieceAttack(board: board, square: square, by: color) {
			return true
		}
		
		if isSquareUnderKingAttack(board: board, square: square, by: color) {
			return true
		}
		
		return false
	}
	
	private func isSquareUnderPawnAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
		let pawnAttacks = color == .white ? board.getBitboard(for: .blackPawn) : board.getBitboard(for: .whitePawn)
		let attackOffsets = color == .white ? [-9, -7] : [7, 9]
		for offset in attackOffsets {
			let targetSquare = square + offset
			if targetSquare >= 0 && targetSquare < 64 && pawnAttacks.isBitSet(at: targetSquare) {
				return true
			}
		}
		return false
	}
	
	private func isSquareUnderKnightAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
		let knightAttacks = color == .white ? board.getBitboard(for: .blackKnight) : board.getBitboard(for: .whiteKnight)
		let knightMoves = [-17, -15, -10, -6, 6, 10, 15, 17]
		for move in knightMoves {
			let targetSquare = square + move
			if targetSquare >= 0 && targetSquare < 64 && knightAttacks.isBitSet(at: targetSquare) {
				return true
			}
		}
		return false
	}
	
	private func isSquareUnderSlidingPieceAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
		let rooksAndQueens = color == .white ? board.getBitboard(for: .blackRook).or(with: board.getBitboard(for: .blackQueen)) : board.getBitboard(for: .whiteRook).or(with: board.getBitboard(for: .whiteQueen))
		let bishopsAndQueens = color == .white ? board.getBitboard(for: .blackBishop).or(with: board.getBitboard(for: .blackQueen)) : board.getBitboard(for: .whiteBishop).or(with: board.getBitboard(for: .whiteQueen))
		
		if isSquareUnderRookLikeAttack(board: board, square: square, by: rooksAndQueens) {
			return true
		}
		
		if isSquareUnderBishopLikeAttack(board: board, square: square, by: bishopsAndQueens) {
			return true
		}
		
		return false
	}
	
	private func isSquareUnderRookLikeAttack(board: ChessBoard, square: Int, by bitboard: Bitboard) -> Bool {
		let directions = [-8, 8, -1, 1]
		return isSquareUnderSlidingAttack(board: board, square: square, by: bitboard, directions: directions)
	}
	
	private func isSquareUnderBishopLikeAttack(board: ChessBoard, square: Int, by bitboard: Bitboard) -> Bool {
		let directions = [-9, -7, 7, 9]
		return isSquareUnderSlidingAttack(board: board, square: square, by: bitboard, directions: directions)
	}
	
	private func isSquareUnderSlidingAttack(board: ChessBoard, square: Int, by bitboard: Bitboard, directions: [Int]) -> Bool {
		for direction in directions {
			var targetSquare = square + direction
			while targetSquare >= 0 && targetSquare < 64 {
				if bitboard.isBitSet(at: targetSquare) {
					return true
				}
				
				if board.getOccupancy().isBitSet(at: targetSquare) {
					break
				}
				targetSquare += direction
			}
		}
		return false
	}
	
	private func isSquareUnderKingAttack(board: ChessBoard, square: Int, by color: Color) -> Bool {
		let kingAttacks = color == .white ? board.getBitboard(for: .blackKing) : board.getBitboard(for: .whiteKing)
		let kingMoves = [-9, -8, -7, -1, 1, 7, 8, 9]
		for move in kingMoves {
			let targetSquare = square + move
			if targetSquare >= 0 && targetSquare < 64 && kingAttacks.isBitSet(at: targetSquare) {
				return true
			}
		}
		return false
	}
}
