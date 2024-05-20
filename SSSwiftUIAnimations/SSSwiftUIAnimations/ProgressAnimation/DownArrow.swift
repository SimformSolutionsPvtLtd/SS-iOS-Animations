//
//  DownArrow.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 06/05/24.
//

import SwiftUI

struct DownArrow: Shape {
    
    // MARK: - Variables
    var initialAnim: CGFloat
    var isDownward: Bool
    var progress: Float
    var circleSize: CGFloat
    var isAnimating: Bool
    
    // MARK: - Animatable Data
    var animatableData: CGFloat {
        get { initialAnim }
        set { initialAnim = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startX = rect.midX - circleSize * (isAnimating ? 0.12 : 0.13)
        let endX = rect.midX + circleSize *  (isAnimating ? 0.12 : 0.12)
        let centerY = rect.midY
        var controlY: CGFloat
        
        if isDownward {
            controlY = centerY + (initialAnim * (rect.height / 2))
        } else {
            let bounceProgress = bounce(initialAnim)
            controlY = centerY - (bounceProgress * (rect.height / 4))
        }
        
        let controlX = rect.midX
        path.move(to: CGPoint(x: startX, y: centerY))
        
        if !isDownward {
            // Curve for bounce effect
            path.move(to: CGPoint(x: startX - circleSize * 0.1, y: centerY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX + circleSize * 0.21, y: centerY),
                control: CGPoint(x: controlX, y: controlY)
            )
        } else if initialAnim <= 1.0 {
            // Down arrow
            path.addLine(to: CGPoint(x: rect.midX, y: controlY))
            path.addLine(to: CGPoint(x: endX, y: centerY))
        } else if progress < 0.1 {
            // Straight line
            path.move(to: CGPoint(x: startX - circleSize * 0.1, y: centerY))
            path.addLine(to: CGPoint(x: rect.maxX + circleSize * 0.21, y: centerY))
        }
        return path
    }
    
    // MARK: - Private functions
    
    // Function to apply bounce effect
    private func bounce(_ progress: CGFloat) -> CGFloat {
        let numberOfBounces = 2
        let bounces = CGFloat(numberOfBounces)
        return abs((circleSize * 0.01 - progress) * sin(progress * .pi * bounces))
    }
}
