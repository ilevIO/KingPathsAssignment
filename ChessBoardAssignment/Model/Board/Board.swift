//
//  Board.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import CoreGraphics

class Board {
    var size: Int = 6
    var movesLimit: Int = 3
    
    private(set) var state: BoardState = .setStartPosition
    
    var selectedCells: [ChessPosition] = .init()
    var startPosition: ChessPosition?
    var endPosition: ChessPosition?
    
    var foundRoutes: [[ChessPosition]]?
    var selectedRoute: Int?
    
    var findKingRoutesCompletion: (([[ChessPosition]]) -> Void)? = nil
    
    lazy var renderer = BoardRenderer(board: self)
    
    func findKingRoutes(from source: ChessPosition, to destination: ChessPosition) {
        let paths = GetPathsAlgorithm(source: source, destination: destination, stepsLimit: movesLimit, boardSize: size).getPaths(for: KnightFigure())
        foundRoutes = paths
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
        selectedRoute = nil
        foundRoutes = nil
    }
    
    func tapped(at point: CGPoint) {
        let row = Int(ceil(point.y * CGFloat(size))) - 1
        let column = Int(ceil(point.x * CGFloat(size))) - 1
        
        switch state {
        case .setStartPosition:
            startPosition = .init(row: row, column: column)
            selectedCells.append(.init(row: row, column: column))
            state = .setEndPosition
        case .setEndPosition:
            let _endPosition = ChessPosition(row: row, column: column)
            endPosition = _endPosition
            selectedCells.append(.init(row: row, column: column))
            guard let startPosition = startPosition else { return }
            state = .none
            findKingRoutes(from: startPosition, to: _endPosition)
        case .none:
            break
        }
    }
}
