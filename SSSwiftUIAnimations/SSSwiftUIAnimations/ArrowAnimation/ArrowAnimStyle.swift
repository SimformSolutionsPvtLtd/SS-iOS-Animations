//
//  ArrowAnimStyle.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 20/05/24.
//

import SwiftUI

struct ArrowAnimStyle {
    
    // Arrow size
    var arrowSize: CGFloat
    
    // Circle size
    var circleSize: CGFloat
    
    // Empty stroke color for circle
    var strokeEmptyColor: Color
    
    // Fill stroke color for circle
    var strokeFillColor: Color
    
    // Arrow color
    var arrowColor: Color

    init(
        arrowSize: CGFloat = ArrowAnimConstant.arrowDefaultSize,
        circleSize: CGFloat = ArrowAnimConstant.circleDefaultSize,
        strokeEmptyColor: Color = .brown,
        strokeFillColor: Color = .brown,
        arrowColor: Color = .brown
    ) {
        self.arrowSize = arrowSize
        self.circleSize = circleSize
        self.strokeEmptyColor = strokeEmptyColor
        self.strokeFillColor = strokeFillColor
        self.arrowColor = arrowColor
    }
}

