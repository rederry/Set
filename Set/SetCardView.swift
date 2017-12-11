//
//  SetCardView.swift
//  Set
//
//  Created by KangKang on 2017/12/10.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

//@IBDesignable
class SetCardView: UIView {
    
    let count: Int = 0
    let color: UIColor = #colorLiteral(red: 0.07843137255, green: 0.6078431373, blue: 0.2666666667, alpha: 1)
    let shape: Shape = Shape.diamond
    let grain: Grain = Grain.solid
    
    enum Shape {
        case diamond, oval, squiggle
        static let allValues = [diamond, oval, squiggle]
    }
    
    enum Grain {
        case solid, striped, outlined
        static let allValues = [solid, striped, outlined]
    }
    
    private func drawRoundConer(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        roundedRect.addClip()
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        roundedRect.fill()
    }
    
    private func drawDimond() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.midY - patternHeight/2))
        path.addLine(to: CGPoint(x: bounds.midX + patternWidth/2, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + patternHeight/2))
        path.addLine(to: CGPoint(x: bounds.midX - patternWidth/2, y: bounds.midY))
        path.close()
        
        drawPattern(with: path)
    }
    
    
    private func drawOval() {
        let path = UIBezierPath(ovalIn: CGRect(origin: patternOrgin, size: CGSize(width: patternWidth, height: patternHeight)))
        
        drawPattern(with: path)
    }
    
    private func drawSquiggle() {
        let path = UIBezierPath()
        path.move(to: patternOrgin.offsetBy(dx: 0, dy: patternHeight))
        let c1_1 = CGPoint(x: bounds.width*0.29, y: bounds.height*0.21)
        let c1_2 = CGPoint(x: bounds.width*0.47, y: bounds.height*0.57)
        let c2_1 = c1_1.offsetBy(dx: 2*(bounds.midX - c1_1.x), dy: 2*(bounds.midY - c1_1.y))
        let c2_2 = c1_2.offsetBy(dx: 2*(bounds.midX - c1_2.x), dy: 2*(bounds.midY - c1_2.y))
        path.addCurve(to: patternOrgin.offsetBy(dx: patternWidth, dy: 0), controlPoint1: c1_1, controlPoint2: c1_2)
        path.addCurve(to: patternOrgin.offsetBy(dx: 0, dy: patternHeight), controlPoint1: c2_1, controlPoint2: c2_2)
        
        drawPattern(with: path)
    }
    
    fileprivate func drawPattern(with path: UIBezierPath) {
        
        path.lineWidth = patternLineWidth
        color.setStroke()
        color.setFill()
        
        // set if striped
        if grain == .striped {
            UIGraphicsGetCurrentContext()?.saveGState()
            path.addClip()
            
            // Draw stripe
            for offset in stride(from: CGFloat(0), to: patternWidth, by: SizeRatio.stripInterval) {
                path.move(to: patternOrgin.offsetBy(dx: CGFloat(offset), dy: 0))
                path.addLine(to: patternOrgin.offsetBy(dx: CGFloat(offset), dy: patternHeight))
            }
        }
        
        if count == 1 || count == 3 {
            // Draw 1 pattern at center
            grain == .solid ? path.fill() : path.stroke()
        }
        
        if count == 2 {
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
                UIGraphicsGetCurrentContext()?.saveGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: patternHeight*0.5 + patternMargin))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
            
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: -2 * (patternHeight*0.5 + patternMargin)))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
        }

        if count == 3 {
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
                UIGraphicsGetCurrentContext()?.saveGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: patternHeight + patternMargin))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
            
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: -2 * (patternHeight + patternMargin)))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawRoundConer(rect)
        switch shape {
        case .diamond:
            drawDimond()
        case .oval:
            drawOval()
        case .squiggle:
            drawSquiggle()
        }
    }

}

extension SetCardView {
    private struct SizeRatio {
        static let patternMarginToBoundsHeight: CGFloat = 0.07
        static let patternHeightToBoundsHeight: CGFloat = 0.22
        static let patternWidthToBoundsWidth: CGFloat = 0.8
        static let patternLineWidthToBoundsWidth: CGFloat = 0.01
        static let stripInterval: CGFloat = 5
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    
    private var patternHeight: CGFloat {
        return bounds.height * SizeRatio.patternHeightToBoundsHeight
    }
    
    private var patternWidth: CGFloat {
        return bounds.width * SizeRatio.patternWidthToBoundsWidth
    }
    
    private var patternMargin: CGFloat {
        return bounds.size.height * SizeRatio.patternMarginToBoundsHeight
    }
    
    private var patternOrgin: CGPoint {
        return CGPoint(x: bounds.midX - patternWidth/2, y: bounds.midY - patternHeight/2)
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var patternLineWidth: CGFloat {
        return bounds.width * SizeRatio.patternLineWidthToBoundsWidth
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
