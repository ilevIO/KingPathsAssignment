//
//  UIView+Constraints.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

enum Side {
    case left
    case right
    case top
    case bottom
}

protocol Anchored {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension UIView: Anchored { }
extension UILayoutGuide: Anchored { }

extension Anchored {
    @discardableResult
    func attach(to anchored: Anchored, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, activated: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let leftInset = left {
            constraints.append(self.leftAnchor.constraint(equalTo: anchored.leftAnchor, constant: leftInset))
        }
        if let rightInset = right {
            constraints.append(self.rightAnchor.constraint(equalTo: anchored.rightAnchor, constant: -rightInset))
        }
        if let topInset = top {
            constraints.append(self.topAnchor.constraint(equalTo: anchored.topAnchor, constant: topInset))
        }
        if let bottomInset = bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: anchored.bottomAnchor, constant: -bottomInset))
        }
        if let centerInset = centerX {
            constraints.append(self.centerXAnchor.constraint(equalTo: anchored.centerXAnchor, constant: centerInset))
        }
        constraints.forEach({ $0.isActive = activated })
        return constraints
    }
}
