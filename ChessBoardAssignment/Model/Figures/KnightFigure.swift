//
//  KnightFigure.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

struct KnightFigure: ChessFigure {
    func possibleMoves(from location: ChessPosition, within boardSize: Int) -> [ChessPosition] {
        return [
            .init(row: location.row - 2, column: location.column - 1),
            .init(row: location.row - 2, column: location.column + 1),
            .init(row: location.row - 1, column: location.column - 2),
            .init(row: location.row - 1, column: location.column + 2),
            .init(row: location.row + 1, column: location.column - 2),
            .init(row: location.row + 1, column: location.column + 2),
            .init(row: location.row + 2, column: location.column - 1),
            .init(row: location.row + 2, column: location.column + 1),
        ].filter {
            (0..<boardSize).contains($0.row) && (0..<boardSize).contains($0.column)
        }
    }
}
