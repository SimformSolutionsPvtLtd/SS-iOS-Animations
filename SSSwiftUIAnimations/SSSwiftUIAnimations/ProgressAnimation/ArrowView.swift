//
//  ArrowView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 15/05/24.
//

import SwiftUI

struct Arrow: View {
    
    // MARK: - Variables
    var arrowStyle: ArrowViewParams
    var style: SSProgressViewStyle
    @Binding var progress: Float
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Vertical line of arrow
            RoundedRectangle(cornerRadius: style.circleStrokeWidth/2)
                .frame(
                    width: arrowStyle.isAnimating ? style.circleStrokeWidth : style.arrowStrokeWidth + 1,
                    height: arrowStyle.isAnimating ? (!arrowStyle.animationStarted ? style.circleStrokeWidth : style.circleStrokeWidth ) : style.circleSize * 0.40
                )
                .opacity(arrowStyle.showVerticalLine ? 1 : 0)
                .foregroundColor(style.arrowColor)
                .offset(y: arrowStyle.isAnimating ? (!arrowStyle.animationStarted ? -5 : -(style.circleSize/2)) : 0)
                .animation(Animation.linear.speed(!arrowStyle.animationStarted ? 100 : .zero), value: 0)
            
            if progress < 0.1 {
                
                // if progress is less than 0.1 then showing down arrow animation
                DownArrow(
                    initialAnim: arrowStyle.initialAnim,
                    isDownward: arrowStyle.isDownward,
                    progress: Float(progress),
                    circleSize: style.circleSize,
                    isAnimating: arrowStyle.isAnimating
                )
                .stroke(style: StrokeStyle(lineWidth: style.arrowStrokeWidth, lineCap: .round))
                .frame(width: 10, height: 50)
                .padding(.top, -50)
                .offset(y: arrowStyle.isAnimating ? 22 : .zero)
                .foregroundColor(style.arrowColor)
                .scaleEffect(CGSize(width:  1, height: arrowStyle.isAnimating ? 1 : style.circleSize * 0.005))
            } else if progress >= 0.1 && progress < 1.0 {
                
                // if progress is between >= 0.1 and < 1.0 starting wave animation
                WaveView(
                    progress: $progress,
                    arrowStrokeWidth: style.arrowStrokeWidth,
                    width: style.circleSize
                )
                .frame(width: 10, height: 30)
                .foregroundColor(style.arrowColor)
            } else if progress >= 1.0 {
                
                // if progress completed showing check mark
                CheckView(
                    width: style.circleSize,
                    arrowStrokeWidth: style.arrowStrokeWidth
                )
                .padding(.top, -11)
                .offset(y: 22)
                .foregroundColor(style.arrowColor)
            }
        }
    }
}
