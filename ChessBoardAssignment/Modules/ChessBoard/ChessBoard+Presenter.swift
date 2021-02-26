//
//  ChessBoard+Presenter.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/25/21.
//
import Foundation
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
                guard let self = self else { return }
                self.results = []
                for route in foundRoutes {
                    var routeString = ""
                    for (index, cell) in route.enumerated() {
                        self.board.selectedCells.append(cell)
                        let startingValue = Int(("A" as UnicodeScalar).value)
                        if let char = UnicodeScalar(startingValue + cell.column) {
                            routeString += String(Character(char))
                        }
                        routeString += "\(self.board.size - cell.row)"
                        if index < route.count - 1 {
                            routeString += " -> "
                        }
                    }
                    self.results.append(routeString)
                }
                DispatchQueue.main.async {
                    self.view?.update()
                }
            }
        }
    }
}
