//
//  GetPathsAlgorithm.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

struct GetPathsAlgorithm {
    let source: ChessPosition
    let destination: ChessPosition
    let stepsLimit: Int
    let boardSize: Int
    let figure: ChessFigure
    
    func findPaths(currPos: ChessPosition, currPath: [ChessPosition], traversed: Set<ChessPosition>, foundPaths: inout [[ChessPosition]]) {
        if currPath.count > stepsLimit {
            return
        }
        if currPos == destination && currPath.count == stepsLimit {
            let foundPath = currPath + [currPos]
            foundPaths += [foundPath]
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
