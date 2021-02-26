//
//  ChessBoardView.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/25/21.
//

import Foundation
import UIKit

protocol ChessGameView: class {
    func update()
    func updateBoard()
}

protocol ChessFigure {
    var location: ChessPosition { get set }
    func possibleMoves(within boardSize: Int) -> [ChessPosition]
}

struct KingFigure: ChessFigure {
    var location: ChessPosition
    
    func possibleMoves(within boardSize: Int) -> [ChessPosition] {
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

struct ChessPosition: Hashable {
    var row: Int
    var column: Int
}

enum BoardState {
    case setStartPosition
    case setEndPosition
    case none
}
