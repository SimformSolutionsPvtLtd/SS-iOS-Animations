//
//  StickAnimations.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 28/06/24.
//

import SwiftUI

struct StickAnimations: View {
    
    let type: StickAnimationType
    let filledColor: Color = .black
    let unFilledColor: Color = .gray
    var duration: Double = 1
    
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
                    allowHeightAnimation: allowHeightAnimation)
                
            case .circularLoading:
                CircularLoading(
                    size: geometry.size,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration
                )
                
            case .circularProgressBar(percentage: let percentage):
                CircularProgress(
                    percentage: percentage,
                    size: geometry.size,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration
                )
                
            case .circularReversableProgressBar(
                percentage: let percentage,
                progressColor: let progressColor
            ):
                CircularReverseProgreessBar(
                    percentage: percentage,
                    size: geometry.size,
                    progressColor: progressColor,
                    filledColor: filledColor,
                    unFilledColor: unFilledColor,
                    duration: duration)
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
