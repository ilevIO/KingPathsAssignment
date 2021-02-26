//
//  PathNode.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

class Node {
    var pos: ChessPosition
    var children: [Node] = .init()
    init(pos: ChessPosition) {
        self.pos = pos
    }
}
