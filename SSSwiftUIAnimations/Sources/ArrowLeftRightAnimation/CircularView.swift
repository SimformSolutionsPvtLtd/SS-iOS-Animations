//
//  CircularView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 04/09/23.
//

import SwiftUI

struct CircularView: View {
    
    // MARK: - Variables
    
    // End progress of circle stroke
    @State private var endProgress: CGFloat = 0.0
    
    // Arrow click state manage
    @State private var isArrowClicked = false
    
    // Arrow offset manage
    @State private var arrowOffset: CGFloat = 2
    
    // Start progress of circle stroke
    @State private var startProgress: CGFloat = 0.0
    
    // State manage for animation completed
    @State private var isAnimationCompleted = false
    
    // Manage immediate click
    @State private var isDisabled = false
    
    // Arrow size
    @State var arrowSize: CGFloat
    
    // Custom animation style
    var arrowAnimStyle: LRArrowAnimStyle
    
    // Tap callback on view tap
    var tapCallBack: (() -> Void)?
    
    // Animation duration
    var animationDuration = 0.4
    
    // MARK: - Body view
    var body: some View {
        ZStack {
            
            //Empty Stroke circle view
            Circle()
                .stroke(
                    arrowAnimStyle.strokeEmptyColor
                        .opacity(0.3),
                    lineWidth: arrowAnimStyle.circleStrokeSize
                )
                .frame(width: arrowAnimStyle.circleSize, height: arrowAnimStyle.circleSize)
            
            // Animate circle stroke from center left to center right of top circle stroke
            animatedCircle()
                .rotationEffect(.degrees(.zero))
            
            // Animate circle stroke from center left to center right of bottom circle stroke
            animatedCircle()
                .rotation3DEffect(
                    .degrees(180), axis: (x: 1, y: .zero, z: .zero)
                )
            
            // Left arrow with animation
            LeftArrow()
                .stroke(style: StrokeStyle(lineWidth: arrowAnimStyle.arrowStrokeSize, lineCap: .round, lineJoin: .round))
                .frame(
                    width: isArrowClicked ? .zero : arrowSize,
                    height: isArrowClicked ? .zero : arrowSize
                )
                .offset(x: arrowOffset)
                .animation(.linear(duration: 0.3), value: isArrowClicked)
                .foregroundColor(arrowAnimStyle.arrowColor)
                .onTapGesture {
                    animateView()
                    isDisabled = true
                    
                    // Callback for tap gesture
                    tapCallBack?()
                    
                    // For disabling immediate click
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        isDisabled = false
                    }
                }
        }.onAppear {
            adjustArrowSize()
            
            // Arrow's x offset to adjust arrow in center
            arrowOffset = arrowSize / 4.5
        }.disabled(isDisabled)
    }
    
    // MARK: - Private functions
    private func animatedCircle() -> some View {
        return FilledStrokeCircle(isAnimationCompleted: $isAnimationCompleted, startProgress: $startProgress, endProgress: $endProgress, arrowStyle: arrowAnimStyle)
    }
    
    private func animateView() {
        isArrowClicked = true
        startProgress = 0.5
        isAnimationCompleted = false
        arrowOffset = -(arrowAnimStyle.circleSize / 2)
        
        // Animate circle stroke
        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.950, repeats: false) { _ in
            endProgress = arrowAnimStyle.circleSize / 2
            arrowOffset = arrowAnimStyle.circleSize / 2
            isAnimationCompleted = true
        }
        
        // Adjusting arrow back animation
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2, repeats: false) { _ in
            withAnimation(Animation.linear(duration: animationDuration * 0.25)) {
                startProgress = endProgress
                endProgress = .zero
            }
        }
        
        // Adjust arrow position when animation is completed
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2.25, repeats: false) { _ in
            withAnimation(Animation.linear(duration: animationDuration * 1.7)) {
                isArrowClicked = false
                arrowOffset = arrowSize / 4
                isAnimationCompleted = false
            }
        }
        
        // Manage circle stoke animation when animation is about to complete
        Timer.scheduledTimer(withTimeInterval: animationDuration * 3, repeats: false) { _ in
            isArrowClicked = false
            isAnimationCompleted = true
        }
    }
    
    // Validate and adjust minimum arrow size
    private func adjustArrowSize() {
        if arrowSize < arrowAnimStyle.circleSize / 4 {
            arrowSize = arrowAnimStyle.circleSize / 4
        } else if arrowSize >= arrowAnimStyle.circleSize {
            arrowSize = arrowAnimStyle.circleSize/1.2
        }
    }
}
