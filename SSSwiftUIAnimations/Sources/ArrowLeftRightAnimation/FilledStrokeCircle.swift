//
//  FilledStrokeCircle.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 20/05/24.
//

import SwiftUI

struct FilledStrokeCircle: View {
    
    // MARK: - Variables
    @Binding var isAnimationCompleted: Bool
    @Binding var startProgress: CGFloat
    @Binding var endProgress: CGFloat
    let arrowStyle: LRArrowAnimStyle
    
    // MARK: - Body view
    var body: some View {
        Circle()
            .trim(
                from: isAnimationCompleted ? startProgress : 0.5,
                to: isAnimationCompleted ? endProgress : 0.5
            )
            .stroke(
                arrowStyle.strokeFillColor,
                style: StrokeStyle(
                    lineWidth: arrowStyle.circleStrokeSize,
                    lineCap: .butt,
                    lineJoin: .round
                )
            )
            .frame(width: arrowStyle.circleSize, height: arrowStyle.circleSize)
            .animation(.linear(duration: 1.6)
                .speed(0.08), value: endProgress)
    }
}

