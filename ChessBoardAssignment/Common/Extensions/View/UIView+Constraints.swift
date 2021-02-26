//
//  UIView+Constraints.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

extension UIView {
    func integrateSubviewWithSafeArea(_ subview: UIView, inset: CGFloat = 0) {
        let guide = self.safeAreaLayoutGuide
        addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: guide.topAnchor, constant: inset).isActive = true
        subview.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: inset).isActive = true
        subview.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -inset).isActive = true
    }
    
    @discardableResult
    func fill(with subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        addSubview(subview)
        
        return fillLayout(with: subview, insets: insets)
    }
    
    @discardableResult
    func fillSafe(with subview: UIView, inset: CGFloat = 0, activated: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        let guide = self.safeAreaLayoutGuide
        
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(subview.topAnchor.constraint(equalTo: guide.topAnchor, constant: inset))
        constraints.append(subview.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -inset))
        constraints.append(subview.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: inset))
        constraints.append(subview.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -inset))
        
        constraints.forEach({ $0.isActive = activated })
        return constraints
    }
    
    @discardableResult
    func fillWithBlur(style: UIBlurEffect.Style = .regular) -> [NSLayoutConstraint] {
        let blurView = UIVisualEffectView(effect: UIBlurEffect.init(style: style))
        return self.fill(with: blurView)
    }
}

extension Anchored {
    ///Fills view with selected subview without adding to hiearchy
    @discardableResult
    func fillLayout(with subview: UIView, insets: UIEdgeInsets = .zero, activated: Bool = true) -> [NSLayoutConstraint] {
        subview.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top))
        constraints.append(subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom))
        constraints.append(subview.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left))
        constraints.append(subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right))
            
        constraints.forEach({ $0.isActive = activated })
        return constraints
    }
    
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
    
    @discardableResult
    func constrainWidth(to anchored: Anchored, multiplier: CGFloat, activated: Bool = true) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalTo: anchored.widthAnchor, multiplier: multiplier)
        constraint.isActive = activated
        return constraint
    }
    
    @discardableResult
    func constrainHeight(to anchored: Anchored, multiplier: CGFloat, activated: Bool = true) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalTo: anchored.heightAnchor, multiplier: multiplier)
        constraint.isActive = activated
        return constraint
    }
}

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
