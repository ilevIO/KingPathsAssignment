//
//  RoundedLineRenderer.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

struct RoundedLineRenderer {
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
        let minlen = min(distPrev, distNext)
        if segment > minlen {
            segment = minlen
            radius = segment * abs(tan(angle / 2))
        }
        
        radius = min(radius, distPrev/2, distNext/2)
        
        let p0 = sqrt(pow(radius, 2) + pow(segment, 2))
        let c1 = CGPoint(x: currPoint.x - (currPoint.x - prevPoint.x) * pc1 / distPrev, y: currPoint.y - (currPoint.y - prevPoint.y) * pc1 / distPrev)
        let c2 = CGPoint(x: currPoint.x - (currPoint.x - nextPoint.x) * pc2 / distNext, y: currPoint.y - (currPoint.y - nextPoint.y) * pc2 / distNext)
        
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
    
    func line(sequnce: [CGPoint], color: CGColor) -> CAShapeLayer? {
        guard let sequenceEnd = sequnce.last, sequnce.count > 1 else { return nil }
        let linePath = CGMutablePath()
        
        var prevPoint = sequnce[0]
        linePath.move(to: prevPoint)
        for i in 1..<sequnce.count - 1 {
            let currPoint = sequnce[i]
            let nextPoint = sequnce[i + 1]
            let params = getArcParams(prevPoint: prevPoint, currPoint: currPoint, nextPoint: nextPoint, radius: 10)
            if !(params.center.x.isNaN || params.center.y.isNaN || params.startAngle.isNaN || params.endAngle.isNaN) {
                linePath.addArc(center: params.center, radius: params.radius, startAngle: params.startAngle, endAngle: params.endAngle, clockwise: params.clockwise)
            } else {
                linePath.addLine(to: currPoint)
            }
            prevPoint = sequnce[i]
        }
        
        linePath.addLine(to: sequenceEnd)
        let pathLayer = CAShapeLayer()
        pathLayer.path = linePath
        pathLayer.strokeColor = color
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 2
        pathLayer.addSublayer(
            ArrowRenderer(source: prevPoint, destination: sequenceEnd, size: 5, color: color)
                .arrow()
        )
        return pathLayer
    }
}
