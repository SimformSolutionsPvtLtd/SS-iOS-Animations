//
//  ReactionAnimationViewStyle.swift
//  SSSwiftUIAnimations
//
//  Created by Faaiz Daglawala on 08/11/24.
//

import SwiftUI

/// A struct representing the style configuration for the reaction animation view.
/// This struct provides customization options for the colors of the outer circle,
/// inner circle, default heart icon, and selected heart icon, as well as the number
/// of animated bubbles (which is kept private).
public struct SSReactionAnimationViewStyle {
    
    /// The color of the outer circle in the animation, providing a subtle background effect
    /// around the heart icon to emphasize the animation. Defaults to `.gray`.
    var outerCircleColor: Color = .gray
    
    /// The color of the inner circle in the animation, which appears after the heart icon
    /// is tapped, indicating an active or selected state. Defaults to `.blue`.
    var innerCircleColor: Color = .blue
    
    /// The color of the heart icon in its default (unselected) state.
    /// Defaults to `.gray`.
    var defautHeartColor: Color = .gray
    
    /// The color of the heart icon in its selected state, shown after a user taps the heart.
    /// Defaults to `.red`.
    var selectedHeartColor: Color = .red
    
    /// Default initializer
    init () { }
    
    /// Initializes a new `SSReactionAnimationViewStyle` with custom colors for the outer circle,
    /// inner circle, default heart icon, and selected heart icon.
    ///
    /// - Parameters:
    ///   - outerCircleColor: The color to use for the outer circle in the animation.
    ///   - innerCircleColor: The color to use for the inner circle, typically displayed after tapping.
    ///   - defautHeartColor: The color of the heart icon in its default (unselected) state.
    ///   - selectedHeartColor: The color of the heart icon in its selected state.
    public init(outerCircleColor: Color, innerCircleColor: Color, defautHeartColor: Color, selectedHeartColor: Color) {
        self.outerCircleColor = outerCircleColor
        self.innerCircleColor = innerCircleColor
        self.defautHeartColor = defautHeartColor
        self.selectedHeartColor = selectedHeartColor
    }
}
