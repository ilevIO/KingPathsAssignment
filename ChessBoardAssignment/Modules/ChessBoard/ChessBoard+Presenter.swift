//
//  ChessBoard+Presenter.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/25/21.
//

import UIKit

extension ChessBoard {
    class Presenter {
        weak var view: ChessGameView?
        var results: [String] = .init()
        var board: Board
        
        func boardViewTapped(at point: CGPoint) {
            board.tapped(at: point)
        }
        
        func resetTapped() {
            board.clear()
            view?.update()
        }
        
        init() {
            board = .init()
            board.findKingRoutesCompletion = { [weak self] foundRoutes in
                for route in foundRoutes {
                    for cell in route {
                        self?.board.selectedCells.append(cell)
                    }
                }
                DispatchQueue.main.async {
                    self?.view?.update()
                }
            }
        }
    }
}
