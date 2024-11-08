//
//  StickAnimations.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 28/06/24.
//

import SwiftUI

/// A view that displays various types of stick animations based on the provided `StickAnimationType`.
struct StickAnimations: View {
    
    /// The type of stick animation to display.
    let type: StickAnimationType
    /// The color for filled sticks.
    var filledColor: Color = .black
    /// The color for unfilled sticks.
    var unFilledColor: Color = .gray
    /// The duration of the animation.
    var duration: Double = 1
    
    /// A view builder that returns the appropriate animation view based on the `type`.
    @ViewBuilder
    var contentView: some View {
        GeometryReader { geometry in
            switch type {
            case .linearLoading(
                stickWidth: let stickWidth,
                spacing: let spacing,
                allowHeightAnimation: let allowHeightAnimation):
                LinearLoading(
                    size: geometry.size,
                    stickWidth: stickWidth,
                    spacing: spacing,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration,
                    allowHeightAnimation: allowHeightAnimation
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                
            case .linearProgressBar(
                percentage: let percentage,
                stickWidth: let stickWidth,
                spacing: let spacing,
                progressColor: let progressColor,
                allowHeightAnimation: let allowHeightAnimation
            ):
                LinearProgress(
                    percentage: percentage,
                    size: geometry.size,
                    stickWidth: stickWidth,
                    spacing: spacing,
                    progressColor: progressColor,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration,
                    allowHeightAnimation: allowHeightAnimation
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                
            case .circularLoading:
                CircularLoading(
                    size: geometry.size,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                
            case .circularProgressBar(percentage: let percentage):
                CircularProgress(
                    percentage: percentage,
                    size: geometry.size,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                
            case .circularReversableProgressBar(
                percentage: let percentage,
                progressColor: let progressColor
            ):
                CircularReverseProgressBar(
                    percentage: percentage,
                    size: geometry.size,
                    progressColor: progressColor,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
    
    var body: some View {
        contentView
    }
}

#Preview {
    StickAnimations(type: .circularLoading)
}
