//
//  WaterProgressViewStyle.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 09/07/24.
//

import SwiftUI

// MARK: - SSWaterProgressViewStyle Configuration
/// A style configuration for the SSWaterProgress Animation
/// Use it to set the colour, size, stroke width, and visibility parameters of animation
public struct SSWaterProgressViewStyle {
    
    // MARK: - Variables
    /// Size of the animation circle
    var circleSize: CGFloat
    
    /// Stroke Width of the progress circle
    var circleStrokeWidth: CGFloat
    
    /// Font of the progress percent text
    var progressFont: Font
    
    /// Color of the progress text
    var progressTextColor: Color
    
    /// Color of the empty part of the progress circle
    var emptyStrokeColor: Color
    
    /// Color of the filled part of progress circle
    var fillStrokeColor: Color
    
    /// Color of the water filled in animation
    var waterColor: Color
    
    /// Decide weather to show or hide bubbles
    var showBubbles: Bool
    
    /// Color of the bubble
    var bubbleColor: Color
    
    /// System Image Name to show when progress is completed
    var checkMarkImg: String
    
    /// Tint Color of checkmark image
    var checkMarkImgColor: Color
    
    /// WaterProgressView Styles and attributes
    /// - Parameters:
    ///   - circleSize: Size of the animation circle
    ///   - circleStrokeWidth: Stroke Width of the progress circle
    ///   - progressFont: Font of the progress percent text
    ///   - progressTextColor: Color of the progress text
    ///   - emptyStrokeColor: Color of the empty part of the progress circle
    ///   - fillStrokeColor: Color of the filled part of progress circle
    ///   - waterColor: Color of the water filled in animation
    ///   - showBubbles: Decide weather to show or hide bubbles
    ///   - bubbleColor: Color of the bubble
    ///   - checkMarkImg: System Image Name to show when progress is completed
    ///   - checkMarkImgColor: Tint Color of checkmark image
    public init(
        circleSize: CGFloat = 200.0,
        circleStrokeWidth: CGFloat = 5.0,
        progressFont: Font = .system(size: 16, weight: .semibold),
        progressTextColor: Color = Color.white,
        emptyStrokeColor: Color = Color.gray.opacity(0.3),
        fillStrokeColor: Color = Color.orange,
        waterColor: Color = Color.yellow,
        showBubbles: Bool = true,
        bubbleColor: Color = Color.white,
        checkMarkImg: String = "checkmark",
        checkMarkImgColor: Color = .white
    ) {
        self.circleSize = max(circleSize, 100)
        self.circleStrokeWidth = max(circleStrokeWidth, 1)
        self.progressFont = progressFont
        self.progressTextColor = progressTextColor
        self.emptyStrokeColor = emptyStrokeColor
        self.fillStrokeColor = fillStrokeColor
        self.waterColor = waterColor
        self.showBubbles = showBubbles
        self.bubbleColor = bubbleColor
        self.checkMarkImg = checkMarkImg
        self.checkMarkImgColor = checkMarkImgColor
    }
}
