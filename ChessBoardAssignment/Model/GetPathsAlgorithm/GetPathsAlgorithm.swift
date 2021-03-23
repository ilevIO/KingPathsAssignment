//
//  GetPathsAlgorithm.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

struct GetPathsAlgorithm {
    let figure: ChessFigure
    let source: ChessPosition
    let destination: ChessPosition
    let stepsLimit: Int
    let boardSize: Int
    
    ///Sets path parameter to array of paths based on paths tree structure
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
    
    ///Creates paths tree structure
    func createNodes(currPos: ChessPosition, parent: PathNode, currStep: Int, pathsPossibilities: [[[Int]]]) {
        let node = PathNode(pos: currPos)
        if currPos == destination {
            parent.children.append(node)
            return
        } else if currStep == 0 {
            return
        } else {
            parent.children.append(node)
        }
        
        let possibleMoves = figure.possibleMoves(from: currPos, within: boardSize)
        for possible in possibleMoves {
            if let index = pathsPossibilities[possible.column][possible.row].firstIndex(where: { $0 > 0 }), index < currStep {
                createNodes(currPos: possible, parent: node, currStep: index, pathsPossibilities: pathsPossibilities)
            }
        }
    }
    
    func getPaths() -> [[ChessPosition]] {
        var pathsPossibilities = [[[Int]]](
            repeating: .init(
                repeating: .init(
                    repeating: 0,
                    count: stepsLimit + 1
                ),
                count: boardSize
            ),
            count: boardSize
        )
           /*.init(
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
            )*/
        
        pathsPossibilities[destination.column][destination.row][0] = 1

        //Counting steps to reach destination from each cell
        for pathsCount in 1...stepsLimit {
            for column in 0..<boardSize {
                for row in 0..<boardSize {
                    let possibleMoves = figure.possibleMoves(from: .init(row: row, column: column), within: boardSize)
                    
                    pathsPossibilities[column][row][pathsCount] = possibleMoves.reduce(0) {
                        $0 + pathsPossibilities[$1.column][$1.row][pathsCount - 1]
                    }
                }
            }
        }
        
        //Creating tree of paths
        let treeRoot = PathNode(pos: source)
        
        var paths: [[ChessPosition]] = .init()
        let possibleMoves = figure
            .possibleMoves(from: source, within: boardSize)
            .filter({
                (pathsPossibilities[$0.column][$0.row].firstIndex(where: { $0 > 0 }) ?? .max) < stepsLimit
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
