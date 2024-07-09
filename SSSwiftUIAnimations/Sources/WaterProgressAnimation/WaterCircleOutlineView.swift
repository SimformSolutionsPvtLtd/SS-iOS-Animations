//
//  WaterCircleOutlineView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 09/07/24.
//

import SwiftUI

struct WaterCircleOutlineView: View {
    
    // MARK: - Variables
    
    /// Outline Progress value
    @Binding var progress: Double
    
    /// Used for styling the view
    var style: SSWaterProgressViewStyle
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style.emptyStrokeColor, style: StrokeStyle(lineWidth: style.circleStrokeWidth, lineCap: .round))
                .frame(width: style.circleSize,
                       height: style.circleSize)
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style.fillStrokeColor, style: StrokeStyle(lineWidth: style.circleStrokeWidth, lineCap: .round))
                .frame(width: style.circleSize, height: style.circleSize)
                .rotationEffect(.degrees(-90))
                .transition(.slide)
        }
    }
}
