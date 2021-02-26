//
//  BoardRenderer.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

class BoardRenderer {
    private let cellSize: CGFloat = 50
    
    weak var board: Board?
    var boardRendered: Bool = false
    
    func drawGrid(to layer: CALayer) {
        guard let board = board else { return }
        
        let boardSize = CGFloat(board.size)
        
        layer.frame.size = .init(width: cellSize * boardSize, height: cellSize * boardSize)
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.frame.origin = .zero
        let actualCellSize: CGFloat = cellSize
        
        let gridLayer = CAShapeLayer()
        layer.addSublayer(gridLayer)
        let path = CGMutablePath()
        
        let cellColor = UIColor.darkGray.cgColor
        let fontSize: CGFloat = 12
        let fontColor = UIColor.black.cgColor
        
        for column in 0..<board.size {
            let verticalTextLayer = CATextLayer()
            
            verticalTextLayer.frame = CGRect(x: cellSize / 5, y: CGFloat(column) * cellSize + cellSize / 2, width: cellSize / 2, height: cellSize / 2)
            verticalTextLayer.fontSize = fontSize
            verticalTextLayer.alignmentMode = .left
            verticalTextLayer.string = "\(board.size - column)"
            verticalTextLayer.foregroundColor = fontColor
            verticalTextLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(verticalTextLayer)
            verticalTextLayer.zPosition = 1000
            
            let horizontalTextLayer = CATextLayer()
            horizontalTextLayer.contentsScale = UIScreen.main.scale
            horizontalTextLayer.frame = CGRect(x: CGFloat(column) * cellSize + cellSize / 2, y: 10, width: 30, height: 18)
            horizontalTextLayer.fontSize = 12
            horizontalTextLayer.alignmentMode = .center
            horizontalTextLayer.string = column.boardLetter
            horizontalTextLayer.foregroundColor = fontColor
            layer.addSublayer(horizontalTextLayer)
            horizontalTextLayer.zPosition = 1000

            layer.addSublayer(verticalTextLayer)
            for j in 0..<board.size {
                if (j + column) % 2 == 0{
                    path.addRect(.init(x: CGFloat(column) * actualCellSize, y: CGFloat(j) * actualCellSize, width: actualCellSize, height: actualCellSize))
                }
            }
        }
        gridLayer.fillColor = cellColor
        gridLayer.path = path
    }
    
    func arrow(from source: CGPoint, to destination: CGPoint, size: CGFloat, color: CGColor) -> CAShapeLayer {
        let toX = destination.x
        let toY = destination.y
        var fromX = source.x
        var fromY = source.y
        let tmp = toX == fromX && toY == fromY ? 1 : 0
        let pifagor = sqrt((pow(toX - fromX, 2)+pow(toY-fromY, 2))) + CGFloat(tmp)
        let dY = size*(toX-fromX)/pifagor
        let dX = size*(toY-fromY)/pifagor
        
        fromY = toY-dX*2
        fromX = toX-dY*2
        let pX = toX-fromX
        let pY = toY-fromY
        
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
    
    func drawResults(_ results: [[ChessPosition]], to layer: CALayer) {
        for (resultIndex, result) in results.enumerated() {
            guard let resultEnd = result.last, result.count > 1 else { return }
            let linePath = CGMutablePath()
            
            var prevPoint = CGPoint(x: CGFloat(result[0].column) * cellSize + cellSize / 2, y: CGFloat(result[0].row) * cellSize + cellSize / 2)
            linePath.move(to: prevPoint)
            for i in 0..<result.count - 1 {
                let currPoint = CGPoint(x: CGFloat(result[i].column) * cellSize + cellSize / 2, y: CGFloat(result[i].row) * cellSize + cellSize / 2)
                let nextPoint = CGPoint(x: CGFloat(result[i + 1].column) * cellSize + cellSize / 2, y: CGFloat(result[i + 1].row) * cellSize + cellSize / 2)
                let params = getArcParams(prevPoint: prevPoint, currPoint: currPoint, nextPoint: nextPoint, radius: 10)
                if !(params.center.x.isNaN || params.center.y.isNaN || params.startAngle.isNaN || params.endAngle.isNaN) {
                    linePath.addArc(center: params.center, radius: params.radius, startAngle: params.startAngle, endAngle: params.endAngle, clockwise: params.clockwise)
                }
                prevPoint = CGPoint(x: CGFloat(result[i].column) * cellSize + cellSize / 2, y: CGFloat(result[i].row) * cellSize + cellSize / 2)
            }
            
            let pathEndPoint = CGPoint(x: CGFloat(resultEnd.column) * cellSize + cellSize / 2, y: CGFloat(resultEnd.row) * cellSize + cellSize / 2)
            linePath.addLine(to: pathEndPoint)
            let pathLayer = CAShapeLayer()
            pathLayer.path = linePath
            let color = pathsColors[resultIndex % pathsColors.count].cgColor
            pathLayer.strokeColor = color
            pathLayer.fillColor = UIColor.clear.cgColor
            
            layer.addSublayer(pathLayer)
            layer.addSublayer(arrow(from: prevPoint, to: pathEndPoint, size: 5, color: color))
        }
        
    }
    
    public struct ArcParams {
        var startAngle: CGFloat
        var endAngle: CGFloat
        var center: CGPoint
        var radius: CGFloat
        var clockwise: Bool
    }
    
    func getArcParams(prevPoint: CGPoint, currPoint: CGPoint, nextPoint: CGPoint, radius: CGFloat) -> ArcParams {
        var radius = radius
        let distPrev = sqrt(pow(prevPoint.x - currPoint.x, 2) + pow(prevPoint.y - currPoint.y, 2))
        let distNext = sqrt(pow(nextPoint.x - currPoint.x, 2) + pow(nextPoint.y - currPoint.y, 2))
        radius = min(radius, distPrev/2, distNext/2)
        var angle = atan2(currPoint.y - prevPoint.y, currPoint.x-prevPoint.x) - atan2(currPoint.y - nextPoint.y, currPoint.x - nextPoint.x)
        angle = angle < 0 ? angle + 2 * .pi : angle
        var segment = radius / abs(tan(angle/2))
        let pc1 = segment
        let pc2 = segment
        let pp1 = sqrt(pow(currPoint.x - prevPoint.x, 2) + pow(currPoint.y - prevPoint.y, 2))
        let pp2 = sqrt(pow(currPoint.x - nextPoint.x, 2) + pow(currPoint.y - nextPoint.y, 2))
        let minlen = min(pp1, pp2)
        if segment > minlen {
            segment = minlen
            radius = segment * abs(tan(angle / 2))
        }
        
        radius = min(radius, distPrev/2, distNext/2)
        
        let p0 = sqrt(pow(radius, 2) + pow(segment, 2))
        let c1 = CGPoint(x: currPoint.x - (currPoint.x - prevPoint.x) * pc1 / pp1, y: currPoint.y - (currPoint.y - prevPoint.y) * pc1 / pp1)
        let c2 = CGPoint(x: currPoint.x - (currPoint.x - nextPoint.x) * pc2 / pp2, y: currPoint.y - (currPoint.y - nextPoint.y) * pc2 / pp2)
        
        let dx = currPoint.x * 2 - c1.x - c2.x
        let dy = currPoint.y * 2 - c1.y - c2.y
        
        let pc = sqrt(pow(dx, 2) + pow(dy, 2))
        
        let o = CGPoint(x: currPoint.x - dx * p0 / pc, y: currPoint.y - dy * p0 / pc)
        var startAngle = atan2(c1.y - o.y, c1.x - o.x)
        var endAngle = atan2(c2.y - o.y, c2.x - o.x)
        startAngle = startAngle < 0 ? startAngle + 2 * CGFloat.pi : startAngle
        endAngle = endAngle < 0 ? endAngle + 2 * CGFloat.pi : endAngle
        return ArcParams(startAngle: startAngle, endAngle: endAngle, center: o, radius: radius, clockwise: angle > CGFloat.pi)
    }
    
    func drawResults(to layer: CALayer) {
        if let result = board?.selectedRoute {
            drawResults([result], to: layer)
        } else if let results = board?.foundRoutes {
            drawResults(results, to: layer)
        }
    }

    func render(to layer: CALayer) {
        //drawGrid(to: layer)
        if let result = board?.selectedRoute {
            drawResults([result], to: layer)
        } else if let results = board?.foundRoutes {
            drawResults(results, to: layer)
        }
    }
    
    init(board: Board) {
        self.board = board
    }
}
