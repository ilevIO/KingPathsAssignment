//
//  Algorithm.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import Foundation

func traverse(from source: ChessPosition, to target: ChessPosition, stepsLimit: Int, board: Board) -> [[ChessPosition]] {
    let boardSize = board.size
    var z = [[[Int]]]
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
    
    z[target.row][target.column][0] = 1

    for k in 1...stepsLimit {
        for x in 0..<boardSize {
            for y in 0..<boardSize {
                let possibles = KingFigure(location: .init(row: x, column: y)).possibleMoves(in: .init())
                
                for possible in possibles {
                    z[x][y][k] += z[possible.row][possible.column][k-1]
                }
                /*z[x][y][k+1] = possibles.reduce(0) {
                    $0 + z[$1.row][$1.column][k]
                }*/
            }
        }
    }
    
    //var paths = [[ChessPosition]].init(repeating: [source], count: z[source.row][source.column].first(where: { $0 > 0 })!)
    
    class Node {
        var pos: ChessPosition
        var children: [Node] = .init()
        init(pos: ChessPosition) {
            self.pos = pos
        }
    }
    
    let treeRoot = Node(pos: source)
    
    func trans(currPos: ChessPosition, parent: Node, currStep: Int) {
        let node = Node.init(pos: currPos)
        parent.children.append(node)
        if currPos == target {
            return
        }
        let possibles = KingFigure(location: currPos).possibleMoves(in: .init())
        for possible in possibles where z[possible.row][possible.column][currStep - 1] > 0 {
            trans(currPos: possible, parent: node, currStep: currStep - 1)
        }
    }
    let possibles = KingFigure(location: source).possibleMoves(in: .init())
    for possible in possibles where z[possible.row][possible.column][stepsLimit - 1] > 0 {
        trans(currPos: possible, parent: treeRoot, currStep: stepsLimit - 1)
    }
    
    func printTree(node: Node, string: String) {
        /*var string = string + "(\(node.pos.row), \(node.pos.column))"
        if !node.children.isEmpty {
            string += " -> "
        } else {
            print(string)
        }
        for child in node.children {
            printTree(node: child, string: string)
        }*/
        var string = string + "(\(node.pos.row), \(node.pos.column))"
        if !node.children.isEmpty {
            string += " -> "
            for child in node.children {
                printTree(node: child, string: string)
            }
        } else {
            print(string)
            //paths.append(path)
        }
    }
    
    func mapTree(node: Node, path: [ChessPosition], paths: inout [[ChessPosition]]) {
        let path = path + [node.pos]
        if !node.children.isEmpty {
            for child in node.children {
                mapTree(node: child, path: path, paths: &paths)
            }
        } else {
            paths.append(path)
        }
        
    }
    
    printTree(node: treeRoot, string: "")
    var paths: [[ChessPosition]] = .init()
    mapTree(node: treeRoot, path: [], paths: &paths)
    return paths
}



