//
//  PathsLookupBoardState.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 3/1/21.
//

struct PathsLookupBoardState {
    var currentFigure: ChessFigure = KnightFigure()
    
    var selectedCells: [ChessPosition] = .init()
    var startPosition: ChessPosition?
    var endPosition: ChessPosition?
    
    var foundPaths: [[ChessPosition]]?
    var selectedPath: Int?
    
    mutating func setStartPosition(_ newStartPosition: ChessPosition?) {
        startPosition = newStartPosition
        startPosition.flatMap { selectedCells.append($0) }
    }
    
    mutating func setEndPosition(_ newEndPosition: ChessPosition?) {
        endPosition = newEndPosition
        endPosition.flatMap { selectedCells.append($0) }
    }
}
