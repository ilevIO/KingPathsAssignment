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
        private let allowedSizeRange = 6...16
        
        weak var view: ChessGameView?
        var results: [String] = .init()
        var board: PathsLookupBoard
        
        //MARK: - Events
        func boardViewTapped(at point: CGPoint) {
            board.tapped(at: point)
            view?.update()
        }
        
        func resetTapped() {
            board.clear()
            results = .init()
            view?.update()
        }
        
        func selectedResult(at index: Int) {
            if index < (board.state.foundPaths?.count ?? 0) {
                board.state.selectedPath = index
                view?.update()
            }
        }
        
        func boardParameters() -> PathsLookupBoardCondition {
            board.condition
        }
        
        func setBoardParameters(size: String, movesLimit: String) {
            if
                let size = Int(size),
                let movesLimit = Int(movesLimit),
                allowedSizeRange.contains(size),
                movesLimit > 0 {
                board.clear()
                board.condition = .init(size: size, movesLimit: movesLimit)
                results = []
            } else {
                view?.alert(with: "Size should be within range \(allowedSizeRange.lowerBound)...\(allowedSizeRange.upperBound) and moves limit greater than zero")
            }
            
            view?.updateBoard()
        }
        
        //MARK: - Setup()
        func setup() {
            board.findFigurePathsCompletion = { [weak self] foundPaths in
                guard let self = self else { return }
                guard !foundPaths.isEmpty else {
                    self.board.clear()
                    self.view?.alert(with: "No paths found")
                    return
                }
                self.results = []
                for path in foundPaths {
                    var pathString = ""
                    for cell in path {
                        pathString += cell.column.boardLetter ?? "\(cell.column)"
                        pathString += "\(self.board.condition.size - cell.row)"
                        if cell != path.last {
                            pathString += " -> "
                        }
                    }
                    self.results.append(pathString)
                }
                DispatchQueue.main.async {
                    self.view?.update()
                }
            }
        }
        
        init() {
            board = .init()
            setup()
        }
    }
}
