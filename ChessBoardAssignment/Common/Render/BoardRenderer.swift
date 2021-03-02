//
//  BoardRenderer.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

class BoardRenderer {
    private let cellSize: CGFloat = 50
    private let maxDisplayNumber = 200
    
    weak var board: Board?
    var boardRendered: Bool = false
    
    func drawLabels(at offset: Int, boardSize: Int, to layer: CALayer) {
        let fontSize: CGFloat = 12
        let fontColor = UIColor.black.cgColor
        
        let verticalTextLayer = CATextLayer()
        verticalTextLayer.frame = CGRect(x: cellSize / 5, y: CGFloat(offset) * cellSize + cellSize / 2, width: cellSize / 2, height: cellSize / 2)
        verticalTextLayer.fontSize = fontSize
        verticalTextLayer.alignmentMode = .left
        verticalTextLayer.string = "\(boardSize - offset)"
        verticalTextLayer.foregroundColor = fontColor
        verticalTextLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(verticalTextLayer)
        
        let horizontalTextLayer = CATextLayer()
        horizontalTextLayer.contentsScale = UIScreen.main.scale
        horizontalTextLayer.frame = CGRect(x: CGFloat(offset) * cellSize + cellSize / 2, y: cellSize / 5, width: cellSize / 2, height: cellSize / 2)
        horizontalTextLayer.fontSize = fontSize
        horizontalTextLayer.alignmentMode = .center
        horizontalTextLayer.string = offset.boardLetter
        horizontalTextLayer.foregroundColor = fontColor
        layer.addSublayer(horizontalTextLayer)
    }
    
    func drawGrid(to layer: CALayer) {
        guard let board = board else { return }
        
        let boardSize = CGFloat(board.size)
        let cellColor = UIColor.systemGray.cgColor
        let backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        layer.frame.size = .init(width: cellSize * boardSize, height: cellSize * boardSize)
        layer.frame.origin = .zero
        
        layer.backgroundColor = backgroundColor
        
        let gridLayer = CAShapeLayer()
        layer.addSublayer(gridLayer)
        let path = CGMutablePath()
        
        for column in 0..<board.size {
            
            drawLabels(at: column, boardSize: board.size, to: layer)

            for row in 0..<board.size {
                if (row + column) % 2 == 0 {
                    path.addRect(.init(x: CGFloat(column) * cellSize, y: CGFloat(row) * cellSize, width: cellSize, height: cellSize))
                }
            }
        }
        gridLayer.fillColor = cellColor
        gridLayer.path = path
    }
    
    func drawPaths(_ paths: [[ChessPosition]], to layer: CALayer) {
        for (pathIndex, path) in paths.enumerated() {
            guard pathIndex < maxDisplayNumber else { return }
            let color = pathsColors[pathIndex % pathsColors.count].cgColor
            if let lineLayer = RoundedLineRenderer()
                .line(
                    sequnce: path.map( {
                        CGPoint(
                            x: CGFloat($0.column) * cellSize + cellSize / 2,
                            y: CGFloat($0.row) * cellSize + cellSize / 2
                        )
                    }),
                    color: color
                ) {
                layer.addSublayer(lineLayer)
            }
        }
        
    }
    
    func drawCurrent(to layer: CALayer) {
        guard let board = board else { return }
        
        let selectedCellsPath = CGMutablePath()
        for selectedCell in board.selectedCells {
            selectedCellsPath.addRect(.init(x: CGFloat(selectedCell.column) * cellSize, y: CGFloat(selectedCell.row) * cellSize, width: cellSize, height: cellSize))
        }
        
        let selectedCellsLayer = CAShapeLayer()
        selectedCellsLayer.path = selectedCellsPath
        selectedCellsLayer.fillColor = UIColor.white.cgColor
        selectedCellsLayer.backgroundColor = UIColor.clear.cgColor
        
        layer.addSublayer(selectedCellsLayer)
        
        drawPaths(to: layer)
    }
    
    func drawPaths(to layer: CALayer) {
        guard let board = board, let paths = board.foundPaths else { return }
        if let selectedResult = board.selectedPath {
            drawPaths([paths[selectedResult]], to: layer)
        } else {
            drawPaths(paths, to: layer)
        }
    }

    init(board: Board) {
        self.board = board
    }
}
