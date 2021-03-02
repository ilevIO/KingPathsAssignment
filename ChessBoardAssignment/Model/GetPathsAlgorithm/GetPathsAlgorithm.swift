//
//  GetPathsAlgorithm.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

class GetPathsAlgorithm {
    init(
        figure: ChessFigure,
        source: ChessPosition,
        destination: ChessPosition, stepsLimit: Int, boardSize: Int, maxPathsCount: Int, maxPathLength: Int, onPathFound: @escaping (([ChessPosition]) -> Void)) {
        self.figure = figure
        self.source = source
        self.destination = destination
        self.stepsLimit = stepsLimit
        self.boardSize = boardSize
        self.maxPathsCount = maxPathsCount
        self.maxPathLength = maxPathLength
        self.onPathFound = onPathFound
    }
    
    let figure: ChessFigure
    let source: ChessPosition
    let destination: ChessPosition
    let stepsLimit: Int
    let boardSize: Int
    ///Algorithm forcefully terminates when this value is reached
    let maxPathsCount: Int
    ///Defines max length of path to be checked
    let maxPathLength: Int
    let onPathFound: (([ChessPosition]) -> Void)
    
    private var cancelled: Bool = false
    
    func cancel() {
        cancelled = true
    }
    
    func findPaths(currPos: ChessPosition, currPath: [ChessPosition], traversed: Set<ChessPosition>, foundPaths: inout [[ChessPosition]]) {
        if cancelled || maxPathsCount == foundPaths.count || currPath.count > maxPathLength {
            return
        }
        if currPos == destination && currPath.count >= stepsLimit {
            let foundPath = currPath + [currPos]
            foundPaths += [foundPath]
            onPathFound(foundPath)
            return
        }
        
        let possibleMoves = figure.possibleMoves(from: currPos, within: boardSize)
        for possibleMove in possibleMoves where !traversed.contains(possibleMove) {
            findPaths(currPos: possibleMove, currPath: currPath + [currPos], traversed: traversed.union(Set<ChessPosition>([currPos])), foundPaths: &foundPaths)
        }
    }
    
    func getPaths() -> [[ChessPosition]] {
        var foundPaths: [[ChessPosition]] = .init()
        
        findPaths(currPos: source, currPath: [], traversed: .init(), foundPaths: &foundPaths)
        return foundPaths
    }
}
