//
//  LRArrowAnimStyle.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 20/05/24.
//

import SwiftUI

public struct LRArrowAnimStyle {
    
    // MARK: - Variables
    
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
    
    // Circle stroke size
    var circleStrokeSize: CGFloat
    
    // Arrow stroke size
    var arrowStrokeSize: CGFloat

    init(
        arrowSize: CGFloat = 20,
        circleSize: CGFloat = 80,
        strokeEmptyColor: Color = .brown,
        strokeFillColor: Color = .brown,
        arrowColor: Color = .brown,
        circleStrokeSize: CGFloat = 1,
        arrowStrokeSize: CGFloat = 1
    ) {
        self.arrowSize = max(arrowSize, 10)
        self.circleSize = max(circleSize, 50)
        self.strokeEmptyColor = strokeEmptyColor
        self.strokeFillColor = strokeFillColor
        self.arrowColor = arrowColor
        self.circleStrokeSize = max(min(circleStrokeSize, circleSize/1.2), 1)
        self.arrowStrokeSize = max(min(arrowStrokeSize, circleSize/5), 1)
    }
}

