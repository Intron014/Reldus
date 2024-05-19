import Foundation

enum ChessPiece: Int, CaseIterable {
    case whiteKing = 0
    case whiteQueen
    case whiteRook
    case whiteBishop
    case whiteKnight
    case whitePawn
    case blackKing
    case blackQueen
    case blackRook
    case blackBishop
    case blackKnight
    case blackPawn
    
    var character: Character {
        switch self {
        case .whiteKing: return "K"
        case .whiteQueen: return "Q"
        case .whiteRook: return "R"
        case .whiteBishop: return "B"
        case .whiteKnight: return "N"
        case .whitePawn: return "P"
        case .blackKing: return "k"
        case .blackQueen: return "q"
        case .blackRook: return "r"
        case .blackBishop: return "b"
        case .blackKnight: return "n"
        case .blackPawn: return "p"
        }
    }

    init?(character: Character) {
        switch character {
        case "K": self = .whiteKing
        case "Q": self = .whiteQueen
        case "R": self = .whiteRook
        case "B": self = .whiteBishop
        case "N": self = .whiteKnight
        case "P": self = .whitePawn
        case "k": self = .blackKing
        case "q": self = .blackQueen
        case "r": self = .blackRook
        case "b": self = .blackBishop
        case "n": self = .blackKnight
        case "p": self = .blackPawn
        default: return nil
        }
    }
}