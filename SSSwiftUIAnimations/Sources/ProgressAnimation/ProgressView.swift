//
//  Shapes.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 08/04/24.
//

import SwiftUI

struct SSProgressView: View {
    
    // MARK: - Variables
    
    // Dynamic progress while using progress view
    @Binding var progress: Float
    
    // For progressView customization
    @State var style: SSProgressViewStyle = SSProgressViewStyle()
    
    // Animation is started or not
    @State private var isAnimating = false
    
    // Starting initial animation before progress starts
    @State private var initialAnim: CGFloat = 1.0
    
    // Start/stop dot animation
    @State private var startDotAnim = false
    
    // Stating shape is down arrow or not
    @State private var isDownArrow = true
    
    // Hide/show progress percentage
    @State private var showPercent = false
    
    // Handling click on progress view
    @State private var canTap = true
    
    // For handling cancel and restart progress
    @State private var isStarted = true
    @State private var isReset = false
    
    @State private var initialTimer: Timer?
    @State private var bounceTimer: Timer?
    @State private var endTimer: Timer?
    
    // Call back for starting progress when user taps on progress view
    var onProgressViewClick: (() -> Void)?
    
    // Call back for finished animation
    var onProgressCompletion: (() -> Void)?
    
    // Call back for restarting animation in between
    var onCancelProgress: (() -> Void)?
    
    @State var bounceEffect: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Progress Circle with animation
            ProgressCircle(progress: $progress, style: style)
                .if(progress > 0.0) {
                $0.animation(.linear, value: progress)
            }
            
            // Progress percentage text view
            ProgressText(showPercent: showPercent, progress: $progress, style: style)
            
            // Arrow view parameters
            let arrowStyle = ArrowViewParams(isAnimating: isAnimating, progress: Double(progress), initialAnim: initialAnim, isDownward: isDownArrow, animationStarted: startDotAnim)
            
            // Arrow view
            Arrow(arrowStyle: arrowStyle, style: style, progress: $progress, bounceEffect: $bounceEffect)
        }.allowsHitTesting(canTap)
            .onTapGesture {
                if canTap && !(progress > 1.0) {
                    manageAnimation()
                }
            }
    }
    
    //  MARK: - Private functions
    
    // Starting initial animation
    private func startAnimation() {
        canTap = false
        resetProgress()
        startDownArrrowAnim()
        
        // Starting arrow's vertical line animation
        withAnimation(.linear(duration: 0.4)) {
            if !isAnimating {
                isAnimating.toggle()
                progressAnimation()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 0.7)) {
                bounceEffect = 2
            }
        }
        
        // Allowing view to reset properly before starting the progress again
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            canTap = style.allowCancelProgress ? true : false
        }
        
        // Starting progress after initial animation is done
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            onProgressViewClick?()
        }
    }
    
    private func manageAnimation() {
        if style.allowCancelProgress && !isReset {
            isStarted.toggle()
            if isStarted {
                // Cancel animation on clicking again
                resetProgress()
                onCancelProgress?()
            } else {
                startAnimation()
            }
        } else {
            isReset = false
            startAnimation()
        }
    }
    
    private func progressAnimation() {
        // Showing percentage text once initial animation is done
        initialTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { timer in
            withAnimation(Animation.linear(duration: 0.2)) {
                showPercent = true
                startDotAnim = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            endTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                
                // Reset progress after progress is completed
                if progress >= 1.0 {
                    timer.invalidate()
                    
                    // Hide percentage text
                    withAnimation(Animation.easeInOut) {
                        showPercent = false
                    }
                    
                    // Reset progress with animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            resetProgress()
                            isReset = true
                            canTap = true
                        }
                    }
                    onProgressCompletion?()
                }
            }
        }
    }
    
    private func startDownArrrowAnim() {
        var animationIndex = 0
        let animationsCount = 3
        
        // Animate arrow to straight line
        withAnimation(.linear(duration: 0.3)) {
            self.initialAnim = 0.0
        }
        
        // Bounce animation
        bounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            withAnimation(.spring(duration: 0.5)) {
                if animationIndex % 2 == 0 {
                    self.isDownArrow.toggle()
                } else {
                    self.initialAnim = 1.3
                }
            }
            
            animationIndex += 1
            if animationIndex >= animationsCount {
                timer.invalidate()
            }
        }
    }
    
    // Reset progress
    private func resetProgress() {
        endTimer?.invalidate()
        initialTimer?.invalidate()
        bounceTimer?.invalidate()
        progress = 0.0
        isAnimating = false
        initialAnim = 1.0
        isDownArrow = true
        bounceEffect = 1.0
        startDotAnim = false
        showPercent = false
    }
}
