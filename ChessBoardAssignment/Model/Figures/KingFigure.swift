//
//  KingFigure.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

struct KingFigure: ChessFigure {
    func possibleMoves(from location: ChessPosition, within boardSize: Int) -> [ChessPosition] {
        var result = [ChessPosition]()
        
        for row in max(location.row - 1, 0)...min(location.row + 1, boardSize - 1) {
            for column in max(location.column - 1, 0)...min(location.column + 1, boardSize - 1) {
                if row != location.row || column != location.column {
                    result.append(.init(row: row, column: column))
                }
            }
        }
        return result
    }
}
