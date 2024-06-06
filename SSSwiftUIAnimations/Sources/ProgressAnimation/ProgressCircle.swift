//
//  ProgressCircle.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 15/05/24.
//

import SwiftUI

struct ProgressCircle: View {
    
    // MARK: - Variables
    @Binding var progress: Float
    var style: SSProgressViewStyle
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style.emptyStrokeColor, 
                        style: StrokeStyle(lineWidth: style.circleStrokeWidth, lineCap: .round))
                .frame(
                    width: style.circleSize,
                    height: style.circleSize
                )
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style.fillStrokeColor, 
                        style: StrokeStyle(lineWidth: style.circleStrokeWidth, lineCap: .round))
                .frame(
                    width: style.circleSize,
                    height: style.circleSize
                )
                .rotationEffect(.degrees(-90))
                .transition(.slide)
        }
    }
}

struct ProgressText : View {
    
    // MARK: - Variables
    var showPercent: Bool
    @Binding var progress: Float
    var style: SSProgressViewStyle
    
    var body: some View {
        ZStack {
            if showPercent {
                Text("\(Int(progress * 100))%")
                    .padding(.top, style.circleSize/2)
                    .font(Font.system(size: style.fontSize, weight: style.fontWeight))
                    .foregroundColor(style.progressTextColor)
            }
        }
    }
}

