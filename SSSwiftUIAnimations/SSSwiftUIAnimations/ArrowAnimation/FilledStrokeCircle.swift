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
    let arrowStyle: ArrowAnimStyle
    
    // MARK: - Body view
    var body: some View {
        Circle()
            .trim(
                from: isAnimationCompleted ? startProgress : ArrowAnimConstant.halfProgress,
                  to: isAnimationCompleted ? endProgress : ArrowAnimConstant.halfProgress
            )
            .stroke(
                arrowStyle.strokeFillColor,
                style: StrokeStyle(
                    lineWidth: ArrowAnimConstant.lineWidth,
                    lineCap: .butt,
                    lineJoin: .round
                )
            )
            .frame(width: arrowStyle.circleSize, height: arrowStyle.circleSize)
            .animation(.linear(duration: 1.6)
                .speed(0.08), value: endProgress)
    }
}

