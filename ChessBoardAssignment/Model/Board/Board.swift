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
    var maxFindPathsCount: Int = Int.max
    var maxFindPathLength: Int = Int.max
    
    private(set) var state: BoardState = .setStartPosition
    
    var selectedCells: [ChessPosition] = .init()
    var startPosition: ChessPosition?
    var endPosition: ChessPosition?
    
    var foundPaths: [[ChessPosition]]?
    var selectedPath: Int?
    
    var findFigurePathsCompletion: (([[ChessPosition]]) -> Void)? = nil
    var onPathFound: (([ChessPosition]) -> Void)? = nil
    
    lazy var renderer = BoardRenderer(board: self)
    
    func findFigurePaths(from source: ChessPosition, to destination: ChessPosition) {
        let paths = GetPathsAlgorithm(
            figure: KnightFigure(),
            source: source,
            destination: destination,
            stepsLimit: movesLimit,
            boardSize: size,
            maxPathsCount: maxFindPathsCount,
            maxPathLength: maxFindPathLength,
            onPathFound: { [weak self] foundPaths in
                self?.onPathFound?(foundPaths)
            }
        )
        .getPaths()
        state = .none
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
        let row = Int(ceil(point.y * CGFloat(size))) - 1
        let column = Int(ceil(point.x * CGFloat(size))) - 1
        
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
            state = .performSearch
            DispatchQueue(label: "findPaths", qos: .userInteractive).async {
                self.findFigurePaths(from: startPosition, to: _endPosition)
            }
        default:
            break
        }
    }
}
