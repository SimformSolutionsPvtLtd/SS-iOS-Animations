//
//  ModelClass.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 14/05/24.
//

import SwiftUI

public struct SSProgressViewStyle {
    var circleSize: CGFloat
    var circleStrokeWidth: CGFloat
    var arrowStrokeWidth: CGFloat
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var progressTextColor: Color
    var emptyStrokeColor: Color
    var fillStrokeColor: Color
    var arrowColor: Color
    var allowCancelProgress: Bool
    
    init(
         circleSize: CGFloat = 200.0,
         circleStrokeWidth: CGFloat = 5.0,
         arrowStrokeWidth: CGFloat = 5.0,
         fontSize: CGFloat = 15.0,
         fontWeight: Font.Weight = .regular,
         progressTextColor: Color = Color.blue,
         emptyStrokeColor: Color = Color.blue.opacity(0.2),
         fillStrokeColor: Color = Color.blue,
         arrowColor: Color = Color.blue,
         allowCancelProgress: Bool = false
    ) {
        
        // Circle size
        self.circleSize =  max(circleSize, 100)
        
        // Circle stroke width
        self.circleStrokeWidth = max(circleStrokeWidth, 1)
        
        // Arrow stroke width
        self.arrowStrokeWidth = max(arrowStrokeWidth, 1)
        
        // Progress text font size
        self.fontSize = fontSize
        
        // Progress text fontWeight
        self.fontWeight = fontWeight
        
        // Color of progress text percentage
        self.progressTextColor = progressTextColor
        
        // Circle's empty stroke's color
        self.emptyStrokeColor = emptyStrokeColor
        
        // Circle's fill stroke's color
        self.fillStrokeColor = fillStrokeColor
        
        // Arrow color
        self.arrowColor = arrowColor
        
        // want to allow cancellation of progress or not
        self.allowCancelProgress = allowCancelProgress
    }
}

struct ArrowViewParams {
    var isAnimating: Bool
    var initialAnim: CGFloat
    var isDownward: Bool
    var animationStarted: Bool
    var showVerticalLine: Bool
    var showPercent: Bool
    
    init(
         isAnimating: Bool = false,
         progress: Double = 0.0,
         doneAnimating: Bool = false,
         initialAnim: CGFloat = 1.0,
         isDownward: Bool = true,
         animationStarted: Bool = true,
         showVerticalLine: Bool = true,
         showPercent: Bool = false
    ) {
        self.isAnimating = isAnimating
        self.initialAnim = initialAnim
        self.isDownward = isDownward
        self.animationStarted = animationStarted
        self.showVerticalLine = showVerticalLine
        self.showPercent = showPercent
    }
}

