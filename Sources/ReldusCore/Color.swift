import Foundation

enum Color {
  case white
  case black
}

extension Color {
  var opposite: Color {
    switch self {
    case .white:
      return .black
    case .black:
      return .white
    }
  }
}
