//
//  Board.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import CoreGraphics

class PathsLookupBoard {
    var condition: BoardCondition = .init()
    
    private(set) var state: BoardState = .setStartPosition
    
    var selectedCells: [ChessPosition] = .init()
    var startPosition: ChessPosition?
    var endPosition: ChessPosition?
    
    var currentFigure: ChessFigure = KnightFigure()
    
    var foundPaths: [[ChessPosition]]?
    var selectedPath: Int?
    
    var findFigurePathsCompletion: (([[ChessPosition]]) -> Void)? = nil
    
    lazy var renderer = BoardRenderer(board: self)
    
    func findFigurePaths(from source: ChessPosition, to destination: ChessPosition) {
        let paths = GetPathsAlgorithm(
            figure: currentFigure,
            source: source,
            destination: destination,
            stepsLimit: condition.movesLimit,
            boardSize: condition.size
        ).getPaths()
        foundPaths = paths
        findFigurePathsCompletion?(paths)
    }
    
    func clear() {
        state = .setStartPosition
        startPosition = nil
        endPosition = nil
        selectedCells = .init()
        selectedPath = nil
        foundPaths = nil
    }
    
    func tapped(at point: CGPoint) {
        let row = max(Int(ceil(point.y * CGFloat(condition.size))) - 1, 0)
        let column = max(Int(ceil(point.x * CGFloat(condition.size))) - 1, 0)
        
        switch state {
        case .setStartPosition:
            startPosition = .init(row: row, column: column)
            selectedCells.append(.init(row: row, column: column))
            state = .setEndPosition
        case .setEndPosition:
            let _endPosition = ChessPosition(row: row, column: column)
            guard let startPosition = startPosition, _endPosition != startPosition else { return }
            endPosition = _endPosition
            selectedCells.append(.init(row: row, column: column))
            state = .none
            findFigurePaths(from: startPosition, to: _endPosition)
        case .none:
            break
        }
    }
}
