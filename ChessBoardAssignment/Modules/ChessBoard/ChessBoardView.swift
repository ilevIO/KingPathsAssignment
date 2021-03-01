//
//  ChessBoardView.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/25/21.
//

protocol ChessGameView: class {
    func update()
    func updateBoard()
    func alert(with message: String)
    
    func showDynamicOutput()
    func hideDynamicOutput()
    func updateDynamicOutput(with values: [String])
}

