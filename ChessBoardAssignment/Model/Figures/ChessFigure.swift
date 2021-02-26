//
//  ChessFigure.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

protocol ChessFigure {
    var location: ChessPosition { get set }
    func possibleMoves(within boardSize: Int) -> [ChessPosition]
}
