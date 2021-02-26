//
//  ArrowRenderer.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

struct ArrowRenderer {
    var source: CGPoint
    var destination: CGPoint
    var size: CGFloat
    var color: CGColor
    
    func arrow() -> CAShapeLayer {
        let toX = destination.x
        let toY = destination.y
        var fromX = source.x
        var fromY = source.y
        let tmp = toX == fromX && toY == fromY ? 1 : 0
        let diagonal = sqrt((pow(toX - fromX, 2) + pow(toY - fromY, 2))) + CGFloat(tmp)
        let dY = size * (toX - fromX) / diagonal
        let dX = size * (toY - fromY) / diagonal
        
        fromY = toY - dX * 2
        fromX = toX - dY * 2
        let pX = toX - fromX
        let pY = toY - fromY
        
        let layer = CAShapeLayer()
        layer.fillColor = color
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: toX - pX - dX, y: toY - pY + dY))
        path.addLine(to: CGPoint(x: toX, y: toY))
        path.addLine(to: CGPoint(x: toX - pX + dX, y: toY - pY - dY))
        path.closeSubpath()
        layer.path = path
        return layer
    }
}
