//
//  Board.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import Foundation
import CoreGraphics

class Board {
    var size: Int = 6
    
    private(set) var state: BoardState = .setStartPosition
    
    var selectedCells: [ChessPosition] = .init()
    var startPosition: ChessPosition?
    var endPosition: ChessPosition?
    
    var findKingRoutesCompletion: (([[ChessPosition]]) -> Void)? = nil
    
    lazy var renderer = BoardRenderer(board: self)
    
    func findKingRoutes(from: ChessPosition, to: ChessPosition) {
        let paths = traverse(from: from, to: to, stepsLimit: 3, board: self)
        findKingRoutesCompletion?(paths)
    }
    
    func setState(_ newState: BoardState) {
        state = newState
    }
    
    func clear() {
        state = .setStartPosition
        startPosition = nil
        endPosition = nil
        selectedCells = .init()
    }
    
    func tapped(at point: CGPoint) {
        let row = Int(ceil(point.y * CGFloat(size))) - 1
        let column = Int(ceil(point.x * CGFloat(size))) - 1
        self.selectedCells.append(.init(row: row, column: column))
        //findKingRoutesCompletion?([])
        switch state {
        case .setStartPosition:
            startPosition = .init(row: row, column: column)
            state = .setEndPosition
        case .setEndPosition:
            let _endPosition = ChessPosition(row: row, column: column)
            endPosition = _endPosition
            guard let startPosition = startPosition else { return }
            state = .none
            findKingRoutes(from: startPosition, to: _endPosition)
        case .none:
            break
        }
    }
}
