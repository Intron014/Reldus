import Foundation

class ChessBoard {
  private var bitboards: [ChessPiece: Bitboard] = [:]
  private var occupancy: Bitboard = Bitboard()
  var turn: Color = .white
  var enPassantSquare: Int? = nil
  var castlingRights: [Color: [CastlingSide: Bool]] = [
    .white: [.kingSide: false, .queenSide: false],
    .black: [.kingSide: false, .queenSide: false],
  ]

  init() {
    for piece in ChessPiece.allCases {
      bitboards[piece] = Bitboard()
    }
  }

  convenience init(fen: String) {
    self.init()
    loadFEN(fen)
  }

  private func squareIndex(file: Int, rank: Int) -> Int {
    return rank * 8 + file
  }

  func loadFEN(_ fen: String) {
    let parts = fen.split(separator: " ")
    guard parts.count > 4 else { return }

    let boardFEN = parts[0]
    let turnFEN = parts[1]
    let castlingFEN = parts[2]
    let enPassantFEN = parts[3]
    let rows = boardFEN.split(separator: "/")

    turn = (turnFEN == "w") ? .white : .black
    enPassantSquare =
      enPassantFEN == "-"
      ? nil
      : squareIndex(
        file: Int(enPassantFEN.prefix(1).unicodeScalars.first!.value - 97),
        rank: Int(enPassantFEN.suffix(1))! - 1)

    castlingRights[.white] = [
      .kingSide: castlingFEN.contains("K"), .queenSide: castlingFEN.contains("Q"),
    ]
    castlingRights[.black] = [
      .kingSide: castlingFEN.contains("k"), .queenSide: castlingFEN.contains("q"),
    ]

    for (rankIndex, row) in rows.reversed().enumerated() {
      var fileIndex = 0
      for char in row {
        if let piece = ChessPiece(character: char) {
          let square = squareIndex(file: fileIndex, rank: rankIndex)
          bitboards[piece]?.setBit(at: square)
          occupancy.setBit(at: square)
          fileIndex += 1
        } else if let emptySpaces = char.wholeNumberValue {
          fileIndex += emptySpaces
        }
      }
    }
  }

  func printCastlingRights() -> String {
    var castlingFEN = ""
    if castlingRights[.white]![.kingSide]! { castlingFEN += "K" }
    if castlingRights[.white]![.queenSide]! { castlingFEN += "Q" }
    if castlingRights[.black]![.kingSide]! { castlingFEN += "k" }
    if castlingRights[.black]![.queenSide]! { castlingFEN += "q" }
    return castlingFEN.isEmpty ? "-" : castlingFEN
  }

  func getFEN() -> String {
    var fen = ""
    for rank in (0..<8).reversed() {
      var emptySpaces = 0
      for file in 0..<8 {
        let square = squareIndex(file: file, rank: rank)
        var foundPiece: Character? = nil
        for (piece, bitboard) in bitboards {
          if bitboard.isBitSet(at: square) {
            foundPiece = piece.character
            break
          }
        }
        if foundPiece != nil {
          if emptySpaces > 0 {
            fen += String(emptySpaces)
            emptySpaces = 0
          }
          fen += String(foundPiece!)
        } else {
          emptySpaces += 1
        }
      }
      if emptySpaces > 0 {
        fen += String(emptySpaces)
      }
      if rank > 0 {
        fen += "/"
      }
    }
    fen += " "
    fen += (turn == .white) ? "w" : "b"
    fen += " "
    var castlingFEN = ""
    if castlingRights[.white]![.kingSide]! { castlingFEN += "K" }
    if castlingRights[.white]![.queenSide]! { castlingFEN += "Q" }
    if castlingRights[.black]![.kingSide]! { castlingFEN += "k" }
    if castlingRights[.black]![.queenSide]! { castlingFEN += "q" }
    fen += castlingFEN.isEmpty ? "-" : castlingFEN
    fen += " "
    fen +=
      enPassantSquare != nil
      ? "\(String(UnicodeScalar(97 + enPassantSquare! % 8)!))\(1 + enPassantSquare! / 8)" : "-"
    return fen
  }

  func printBoard() {
    for rank in (0..<8).reversed() {
      for file in 0..<8 {
        let square = squareIndex(file: file, rank: rank)
        var foundPiece: Character? = nil
        for (piece, bitboard) in bitboards {
          if bitboard.isBitSet(at: square) {
            foundPiece = piece.character
            break
          }
        }
        print(foundPiece ?? ".", terminator: " ")
      }
      print()
    }
  }

  func makeMove(_ move: Move) {
    bitboards[move.piece]?.clearBit(at: move.from)
    bitboards[move.piece]?.setBit(at: move.to)
    occupancy.clearBit(at: move.from)
    occupancy.setBit(at: move.to)

    if let capturedPiece = move.capturedPiece {
      bitboards[capturedPiece]?.clearBit(at: move.to)
    }

    if let promotionPiece = move.promotion {
      bitboards[move.piece]?.clearBit(at: move.to)
      bitboards[promotionPiece]?.setBit(at: move.to)
    }

    if move.isEnPassant {
      let capturedPawnSquare = move.to + (turn == .white ? -8 : 8)
      let capturedPawn = (turn == .white) ? ChessPiece.blackPawn : ChessPiece.whitePawn
      bitboards[capturedPawn]?.clearBit(at: capturedPawnSquare)
      occupancy.clearBit(at: capturedPawnSquare)
    }

    if move.isCastling {
      let rookFrom: Int
      let rookTo: Int
      if move.to == squareIndex(file: 6, rank: turn == .white ? 0 : 7) {
        rookFrom = squareIndex(file: 7, rank: turn == .white ? 0 : 7)
        rookTo = squareIndex(file: 5, rank: turn == .white ? 0 : 7)
      } else {
        rookFrom = squareIndex(file: 0, rank: turn == .white ? 0 : 7)
        rookTo = squareIndex(file: 3, rank: turn == .white ? 0 : 7)
      }
      bitboards[turn == .white ? .whiteRook : .blackRook]?.clearBit(at: rookFrom)
      bitboards[turn == .white ? .whiteRook : .blackRook]?.setBit(at: rookTo)
      occupancy.clearBit(at: rookFrom)
      occupancy.setBit(at: rookTo)
    }

    if move.piece == .whitePawn || move.piece == .blackPawn {
      if abs(move.from - move.to) == 16 {
        enPassantSquare = move.to + (turn == .white ? -8 : 8)
      } else {
        enPassantSquare = nil
      }
    } else {
      enPassantSquare = nil
    }

    if move.piece == .whiteKing {
      castlingRights[.white] = [.kingSide: false, .queenSide: false]
    }
    if move.piece == .blackKing {
      castlingRights[.black] = [.kingSide: false, .queenSide: false]
    }
    if move.from == squareIndex(file: 0, rank: 0) || move.to == squareIndex(file: 0, rank: 0) {
      castlingRights[.white]?[.queenSide] = false
    }
    if move.from == squareIndex(file: 7, rank: 0) || move.to == squareIndex(file: 7, rank: 0) {
      castlingRights[.white]?[.kingSide] = false
    }
    if move.from == squareIndex(file: 0, rank: 7) || move.to == squareIndex(file: 0, rank: 7) {
      castlingRights[.black]?[.queenSide] = false
    }
    if move.from == squareIndex(file: 7, rank: 7) || move.to == squareIndex(file: 7, rank: 7) {
      castlingRights[.black]?[.kingSide] = false
    }

    turn = turn.opposite

    let opponentColor = turn.opposite
    let opponentKingSquare = getKingSquare(for: opponentColor)
    move.isCheck = isSquareUnderAttack(square: opponentKingSquare, by: turn)
  }

  func undoMove(_ move: Move) {
    bitboards[move.piece]?.clearBit(at: move.to)
    bitboards[move.piece]?.setBit(at: move.from)
    occupancy.clearBit(at: move.to)
    occupancy.setBit(at: move.from)

    if let capturedPiece = move.capturedPiece {
      bitboards[capturedPiece]?.setBit(at: move.to)
      occupancy.setBit(at: move.to)
    }

    if let promotionPiece = move.promotion {
      bitboards[promotionPiece]?.clearBit(at: move.to)
      bitboards[move.piece]?.setBit(at: move.from)
    }

    if move.isEnPassant {
      let capturedPawnSquare = move.to + (turn == .white ? -8 : 8)
      let capturedPawn = (turn == .white) ? ChessPiece.blackPawn : ChessPiece.whitePawn
      bitboards[capturedPawn]?.setBit(at: capturedPawnSquare)
      occupancy.setBit(at: capturedPawnSquare)
    }

    if move.isCastling {
      let rookFrom: Int
      let rookTo: Int
      if move.to == squareIndex(file: 6, rank: turn == .white ? 0 : 7) {
        rookFrom = squareIndex(file: 5, rank: turn == .white ? 0 : 7)
        rookTo = squareIndex(file: 7, rank: turn == .white ? 0 : 7)
      } else {
        rookFrom = squareIndex(file: 3, rank: turn == .white ? 0 : 7)
        rookTo = squareIndex(file: 0, rank: turn == .white ? 0 : 7)
      }
      bitboards[turn == .white ? .whiteRook : .blackRook]?.clearBit(at: rookFrom)
      bitboards[turn == .white ? .whiteRook : .blackRook]?.setBit(at: rookTo)
      occupancy.clearBit(at: rookFrom)
      occupancy.setBit(at: rookTo)
    }

    turn = turn.opposite

    if move.piece == .whiteKing || move.from == squareIndex(file: 0, rank: 0)
      || move.to == squareIndex(file: 0, rank: 0) || move.from == squareIndex(file: 7, rank: 0)
      || move.to == squareIndex(file: 7, rank: 0)
    {
      castlingRights[.white] = [.kingSide: true, .queenSide: true]
    }
    if move.piece == .blackKing || move.from == squareIndex(file: 0, rank: 7)
      || move.to == squareIndex(file: 0, rank: 7) || move.from == squareIndex(file: 7, rank: 7)
      || move.to == squareIndex(file: 7, rank: 7)
    {
      castlingRights[.black] = [.kingSide: true, .queenSide: true]
    }

    enPassantSquare = nil
  }

  func copy() -> ChessBoard {
    let board = ChessBoard()
    board.bitboards = bitboards
    board.occupancy = occupancy
    board.turn = turn
    board.enPassantSquare = enPassantSquare
    return board
  }

  func getKingSquare(for color: Color) -> Int {
    let king = (color == .white) ? ChessPiece.whiteKing : ChessPiece.blackKing
    return bitboards[king]?.board.trailingZeroBitCount ?? -1
  }

  func isSquareUnderAttack(square: Int, by color: Color) -> Bool {
    let attackBitboard = generateAttackBitboard(color: color)
    return attackBitboard.isBitSet(at: square)
  }

  func generateAttackBitboard(color: Color) -> Bitboard {
    var attackBitboard = Bitboard()
    let moves = MoveGenerator.generateMoves(for: self, color: color)

    for move in moves {
      attackBitboard.setBit(at: move.to)
    }

    return attackBitboard
  }

  func getBitboard(for piece: ChessPiece) -> Bitboard {
    return bitboards[piece] ?? Bitboard()
  }

  func getOccupancy() -> Bitboard {
    return occupancy
  }

  func pieceAt(square: Int) -> ChessPiece? {
    for (piece, bitboard) in bitboards {
      if bitboard.isBitSet(at: square) {
        return piece
      }
    }
    return nil
  }
}
