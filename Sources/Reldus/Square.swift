func squareToString(square: Int) -> String {
    let file = square % 8
    let rank = square / 8 + 1
    let fromSquare = "\(Character(UnicodeScalar(97 + file)!))\(rank)"
    return fromSquare
}