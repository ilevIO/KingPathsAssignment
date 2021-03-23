//
//  PathNode.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

class PathNode {
    var position: ChessPosition
    var children: [PathNode] = .init()
    
    init(pos: ChessPosition) {
        self.position = pos
    }
}
