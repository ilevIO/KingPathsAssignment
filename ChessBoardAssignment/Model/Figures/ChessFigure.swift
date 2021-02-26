//
//  ChessFigure.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

protocol ChessFigure {
    func possibleMoves(from location: ChessPosition, within boardSize: Int) -> [ChessPosition]
}
