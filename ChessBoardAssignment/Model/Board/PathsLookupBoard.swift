//
//  Board.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import CoreGraphics

class PathsLookupBoard {
    var condition: PathsLookupBoardCondition = .init()
    
    private(set) var status: BoardStatus = .setStartPosition
    
    var state: PathsLookupBoardState = .init()
    
    var findFigurePathsCompletion: (([[ChessPosition]]) -> Void)? = nil
    
    lazy var renderer = BoardRenderer(board: self)
    
    func findFigurePaths(from source: ChessPosition, to destination: ChessPosition) {
        let paths = GetPathsAlgorithm(
            figure: state.currentFigure,
            source: source,
            destination: destination,
            stepsLimit: condition.movesLimit,
            boardSize: condition.size
        ).getPaths()
        state.foundPaths = paths
        findFigurePathsCompletion?(paths)
    }
    
    func clear() {
        status = .setStartPosition
        state = .init()
        /*startPosition = nil
        endPosition = nil
        selectedCells = .init()
        selectedPath = nil
        foundPaths = nil*/
    }
    
    func tapped(at point: CGPoint) {
        let row = max(Int(ceil(point.y * CGFloat(condition.size))) - 1, 0)
        let column = max(Int(ceil(point.x * CGFloat(condition.size))) - 1, 0)
        
        switch status {
        case .setStartPosition:
            state.setStartPosition(.init(row: row, column: column))
            /*startPosition = .init(row: row, column: column)
            selectedCells.append(.init(row: row, column: column))*/
            status = .setEndPosition
        case .setEndPosition:
            let _endPosition = ChessPosition(row: row, column: column)
            guard let startPosition = state.startPosition, _endPosition != startPosition else { return }
            state.setEndPosition(_endPosition)
            /*endPosition = _endPosition
            selectedCells.append(.init(row: row, column: column))*/
            status = .none
            findFigurePaths(from: startPosition, to: _endPosition)
        case .none:
            break
        }
    }
}
