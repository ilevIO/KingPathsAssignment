//
//  BoardView.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

class BoardView: UIView {
    var boardRenderer: BoardRenderer!
    
    private var boardLayer: CALayer = .init()
    private var resultLayer: CALayer = .init()
    
    func configure(with board: Board) {
        boardRenderer = board.renderer
    }
    
    func updateBoard() {
        setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        resultLayer.sublayers = nil
        boardRenderer.drawCurrent(to: resultLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.sublayers = [boardLayer]
        boardLayer.setAffineTransform(.identity)
        boardLayer.frame = .zero
        boardLayer.sublayers = nil
        resultLayer.sublayers = nil
        boardRenderer.drawGrid(to: boardLayer)
        boardRenderer.drawPaths(to: resultLayer)
        boardLayer.addSublayer(resultLayer)
        
        //Scaling to fill view
        boardLayer.transform = CATransform3DMakeScale(layer.bounds.width/boardLayer.bounds.width, layer.bounds.height/boardLayer.bounds.height, 1.0)
        boardLayer.frame = self.layer.bounds
    }
}
