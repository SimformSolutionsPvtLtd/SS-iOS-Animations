//
//  SSWaterProgressView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 09/07/24.
//

import SwiftUI

/// This is the Main View of WaterAnimation. Add this to your View Hierarchy to start
/// using animation in your screen. It will include circular progress indicator with water filled in it,
/// along with progress text.
/// Use case Example:
/// ```swift
/// SSWaterProgressView(progress: $progress,
///                showPercent: true ,
///                style: SSWaterProgressViewStyle(
///                    circleSize: 200,
///                    circleStrokeWidth: 10,
///                    progressFont: .system(size: 16, weight: .bold),
///                    progressTextColor: .black,
///                    emptyStrokeColor: .cyan.opacity(0.2) ,
///                    fillStrokeColor: .cyan,
///                    waterColor: .mint,
///                    showBubbles: true,
///                    bubbleColor: .white,
///                    checkMarkImg: "checkmark.circle.fill",
///                    checkMarkImgColor: .brown
///                ),
///                onProgressCompletion: { })
/// ```
public struct SSWaterProgressView: View {
    
    // MARK: - Variables
    
    /// Dynamic progress while using progress view
    @Binding var progress: Double
    
    /// Hide/show progress percentage
    var showPercent = false
    
    /// For progressView customization
    var style: SSWaterProgressViewStyle = SSWaterProgressViewStyle()
    
    /// Call back for finished animation
    var onProgressCompletion: (() -> Void)?
    
    /// Water Wave Animation
    @State private var startAnimation = Angle(degrees: 0)
    
    public var body: some View {
        if #available(iOS 17.0, *) {
            screenContent
                .onChange(of: progress) { oldVal, newValue in
                    progressCompletionBlock(progressVal: newValue)
                }
        } else {
            screenContent
                .onChange(of: progress) { value in
                    progressCompletionBlock(progressVal: value)
                }
        }
    }
    
    private var screenContent: some View {
        ZStack {
            progressOutlineView
            waterCircleView
            progressOverlay
        }
    }
    
    private func progressCompletionBlock(progressVal: Double) {
        if progressVal == 1.0 {
            if let onProgressCompletion {
                onProgressCompletion()
            }
        }
    }
}

extension SSWaterProgressView {
    
    /// Progress Circle With animation
    private var progressOutlineView: some View {
        WaterCircleOutlineView(progress: $progress, style: style)
            .if(progress > 0.0) {
                $0.animation(.linear, value: progress)
            }
    }
    
    /// Water Effect Circular View
    private var waterCircleView: some View {
        WaterCircleView(
            progress: progress * 100,
            offset: Angle(degrees: startAnimation.degrees)
        )
        .fill(style.waterColor)
        .frame(
            width: style.circleSize,
            height: style.circleSize + style.circleStrokeWidth
        )
        .mask {
            Circle()
                .frame(width: style.circleSize - style.circleStrokeWidth,
                       height: style.circleSize - style.circleStrokeWidth)
        }
        .task {
            withAnimation(.linear(duration: 1)
                .repeatForever(autoreverses: false)) {
                    startAnimation = Angle(degrees: 360)
                }
        }
        .overlay {
            BubbleView(style: style)
        }
    }
    
    /// Progress Overlays views such as completion checkmark and Progress TextView
    @ViewBuilder
    private var progressOverlay: some View {
        if progress == 1.0 {
            CheckmarkView(style: style)
        } else {
            // Progress percentage text view
            WaterProgressTextView(
                showPercentage: showPercent,
                progress: $progress,
                style: style
            )
        }
    }
}

#Preview {
    SSWaterProgressView(progress: .constant(20.0))
}
