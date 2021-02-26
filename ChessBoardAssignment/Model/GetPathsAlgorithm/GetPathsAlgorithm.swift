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
    
    func createNodes(currPos: ChessPosition, parent: PathNode, currStep: Int, pathsPossibilities: [[[Int]]]) {
        //Avoiding cases when destination reached in less steps
        if currPos == destination && currStep > 1 {
            return
        }
        let node = PathNode.init(pos: currPos)
        parent.children.append(node)
        if currStep == 0 {
            return
        }
        
        let possibleMoves = KingFigure(location: currPos).possibleMoves(within: boardSize)
        for possible in possibleMoves
        where pathsPossibilities[possible.column][possible.row][currStep - 1] > 0 {
            createNodes(currPos: possible, parent: node, currStep: currStep - 1, pathsPossibilities: pathsPossibilities)
        }
    }
    
    func mapToPaths(node: PathNode, path: [ChessPosition], paths: inout [[ChessPosition]]) {
        let path = path + [node.position]
        if !node.children.isEmpty {
            for child in node.children {
                mapToPaths(node: child, path: path, paths: &paths)
            }
        } else {
            paths.append(path)
        }
    }
    
    func getPaths() -> [[ChessPosition]] {
        var pathsPossibilities = [[[Int]]]
            .init(
                repeating: [[Int]]
                    .init(
                        repeating:
                            .init(
                                repeating: 0,
                                count: stepsLimit + 1
                            ),
                        count: boardSize
                    ),
                count: boardSize
            )
        
        pathsPossibilities[destination.column][destination.row][0] = 1

        //Counting steps to reach destination from each cell
        for k in 1...stepsLimit {
            for column in max(0, source.column - stepsLimit)..<min(boardSize, source.column + stepsLimit) {
                for row in max(0, source.row - stepsLimit)..<min(boardSize, source.row + stepsLimit) {
                    let possibleMoves = KingFigure(location: .init(row: row, column: column)).possibleMoves(within: boardSize)
                    
                    pathsPossibilities[column][row][k] = possibleMoves.reduce(0) {
                        $0 + pathsPossibilities[$1.column][$1.row][k-1]
                    }
                }
            }
        }
        
        //Creating tree of paths
        let treeRoot = PathNode(pos: source)
        
        var paths: [[ChessPosition]] = .init()
        let possibleMoves = KingFigure(location: source)
            .possibleMoves(within: boardSize)
            .filter({
                pathsPossibilities[$0.column][$0.row][stepsLimit - 1] > 0
            })
        if !possibleMoves.isEmpty {
            //For each move where it is possible to reach destination in stepsLimit
            for possible in possibleMoves {
                createNodes(currPos: possible, parent: treeRoot, currStep: stepsLimit - 1, pathsPossibilities: pathsPossibilities)
            }
            //Mapping tree into array of paths
            mapToPaths(node: treeRoot, path: [], paths: &paths)
        }
        
        return paths
    }
}
