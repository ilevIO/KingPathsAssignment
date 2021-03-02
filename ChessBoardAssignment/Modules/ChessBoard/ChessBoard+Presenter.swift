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
        var board: Board
        
        var pathsAccumulator: [[ChessPosition]] = .init()
        let pathsAccumulatorCapacity = 10
        ///Number of tacts per results update
        let updateRate = 2000
        var currentTact = 0
        //MARK: - Events
        func boardViewTapped(at point: CGPoint) {
            board.tapped(at: point)
            if board.state == .performSearch {
                view?.showDynamicOutput()
            }
            view?.update()
        }
        
        func resetTapped() {
            board.clear()
            results = .init()
            currentTact = 0
            pathsAccumulator = []
            view?.update()
        }
        
        func cancelResultsTapped() {
            board.cancelCalculation()
        }
        
        func selectedResult(at index: Int) {
            if index < (board.foundPaths?.count ?? 0) {
                board.selectedPath = index
                view?.update()
            }
        }
        
        func setBoardParameters(size: String, movesLimit: String) {
            if
                let size = Int(size),
                let movesLimit = Int(movesLimit),
                allowedSizeRange.contains(size),
                movesLimit > 0 {
                board.clear()
                board.size = size
                board.movesLimit = movesLimit
                results = []
            } else {
                view?.alert(with: "Size should be within range \(allowedSizeRange.lowerBound)...\(allowedSizeRange.upperBound) and moves limit greater than zero")
            }
            
            view?.updateBoard()
        }
        
        func encodePath(_ path: [ChessPosition]) -> String {
            var pathString = ""
            for cell in path {
                pathString += cell.column.boardLetter ?? "\(cell.column)"
                pathString += "\(self.board.size - cell.row)"
                if cell != path.last {
                    pathString += " -> "
                }
            }
            return pathString
        }
 
        //MARK: - Setup()
        func setup() {
            board.findFigurePathsCompletion = { [weak self] foundPaths in
                guard let self = self else { return }
                guard !foundPaths.isEmpty else {
                    self.board.clear()
                    DispatchQueue.main.async {
                        self.view?.alert(with: "No paths found")
                    }
                    return
                }
                self.results = []
                for path in foundPaths {
                    self.results.append(self.encodePath(path))
                }
                DispatchQueue.main.async {
                    self.view?.hideDynamicOutput()
                    self.view?.update()
                }
            }
            
            board.onPathFound = { [unowned self] route in
                currentTact += 1
                if pathsAccumulator.count < pathsAccumulatorCapacity {
                    self.pathsAccumulator.append(route)
                }
                if currentTact == updateRate {
                    currentTact = 0
                    let presentingPaths = self.pathsAccumulator
                    self.pathsAccumulator = .init()
                    
                    DispatchQueue.main.async {
                        self.view?.updateDynamicOutput(
                            with: presentingPaths
                                .map({ self.encodePath($0) })
                        )
                    }
                }
                
            }
        }
        
        init() {
            board = .init()
            setup()
        }
    }
}
