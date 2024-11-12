//
//  AnimationViewModel.swift
//  ReactionAnimationSwiftUI
//
//  Created by Faaiz Daglawala on 15/12/22.
//

import Foundation
import SwiftUI

/// ViewModel for managing the reaction animation in SwiftUI.
final class SSReactionAnimationViewModel: ObservableObject {
    // MARK: - Properties

    /// The style settings for the reaction animation view.
    /// It defines the appearance and behavior of the reaction animation.
    private(set) var style: SSReactionAnimationViewStyle = SSReactionAnimationViewStyle()
    
    /// The number of bubbles that will appear around the heart icon in the animation
    /// when it is tapped. Set to 7 by default, and it is private to prevent external modification.
    private(set) var bubbleCount: Int = 7 {
        didSet {
            self.largeBubbleColors = Array(repeating: .red, count: self.bubbleCount)
            self.smallBubbleColors = Array(repeating: .green, count: self.bubbleCount)
        }
    }
    
    /// Width of the circle's stroke line.
    @Published private(set) var outlineWidth: CGFloat = 50
    
    /// Scale factor for the main circle animation.
    @Published private(set) var circleScale: CGFloat = 0.1
    
    /// Opacity of the lit (highlighted) bubbles.
    @Published private(set) var bubblesOpacity: CGFloat = 0
    
    /// Color options for randomizing bubble colors.
    private var colorOptions: [Color] = [
        .red, .blue, .yellow, .green, .purple, .cyan, .orange, .pink, .indigo, .teal, .mint,
        Color(red: 0.9, green: 0.4, blue: 0.3),
        Color(red: 0.4, green: 0.7, blue: 0.9),
        Color(red: 0.2, green: 0.9, blue: 0.6),
        Color(red: 0.6, green: 0.3, blue: 0.9)
    ]
    
    /// Radius of the larger bubbles in the animation.
    @Published private(set) var largeBubbleRadius: CGFloat = 10
    
    /// Radius of the smaller bubbles in the animation.
    @Published private(set) var smallBubbleRadius: CGFloat = 10
    
    /// Angle spacing for arranging bubbles in a circular pattern.
    let angleSpacing: CGFloat = 360.0 / 10.0
    
    /// Colors assigned to the large bubbles.
    @Published private(set) var largeBubbleColors: [Color] = []
    
    /// Colors assigned to the small bubbles.
    @Published private(set) var smallBubbleColors: [Color] = []
    
    /// Size of each large bubble.
    @Published private(set) var largeBubbleSize: CGFloat = 16
    
    /// Size of each small bubble.
    @Published private(set) var smallBubbleSize: CGFloat = 8
    
    /// Size of the animation view to calculate dynamic properties.
    @Published private(set) var animationViewSize: CGSize = .zero
    
    // Animation state tracking
    @Published private(set) var heartScaleAnimation: Bool = false
    @Published private(set) var circleAnimation: Bool = false
    @Published private(set) var animationProgress: Double = 0
    @Published private(set) var isSelected: Bool = false

    // MARK: - Initializers
    
    /// Default initializer
    init() { }
    
    /// Custom initializer to set style for animation view
    /// - Parameters:
    ///   - style: SSReactionAnimationViewStyle takes outerCircleColor, innerCircleColor,
    ///   defautHeartColor, selectedHeartColor for animaiton view.
    init(style: SSReactionAnimationViewStyle) {
        self.style = style
    }
    
    // MARK: - Methods
    
    /// Calculates the angle in radians for each circle's position, based on the index and an optional offset.
    /// - Parameters:
    ///   - index: Position index of the circle in the sequence.
    ///   - offset: Optional angle offset to adjust the rotation.
    /// - Returns: Angle in radians for the specified circle.
    func angle(for index: Int, withOffset offset: CGFloat = 0) -> CGFloat {
        let angleStep = 360.0 / Double(bubbleCount) // Divide full circle into 7 segments
        let angleInDegrees = angleStep * CGFloat(index) + offset
        return angleInDegrees * .pi / 180
    }
    
    /// Randomizes colors for both large and small circles.
    private func randomizeBubbleColors() {
        largeBubbleColors = (0..<bubbleCount).map { _ in colorOptions.randomElement() ?? .red }
        smallBubbleColors = (0..<bubbleCount).map { _ in colorOptions.randomElement() ?? .green }
    }
    
    /// Triggers the expansion animation for the main circle, with scaling, opacity change, and line width reduction.
    func triggerCircleExpansion() {       
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) { [weak self] in
            guard let self else { return }
            circleScale = 1
        }

        withAnimation(.easeIn(duration: 0.3).delay(0.4)) { [weak self] in
            guard let self else { return }
            bubblesOpacity = 1
        }

        withAnimation(.easeIn(duration: 0.5).delay(0.7)) { [weak self] in
            guard let self else { return }
            outlineWidth = 0
        }
        triggerBubbleExpansion()
    }
    
    /// Animates the smaller circles, expanding their radius, randomizing colors, and eventually fading out.
    private func triggerBubbleExpansion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            withAnimation(.easeInOut(duration: 1)) {
                self.largeBubbleRadius = ((self.animationViewSize.width / 2) * 80) / 100
                self.smallBubbleRadius = ((self.animationViewSize.width / 2) * 65) / 100
                self.randomizeBubbleColors()
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                self.smallBubbleSize = 0
                self.largeBubbleSize = 0
                self.bubblesOpacity = 0.0
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.8)) {
                self.isSelected = true
            }
        }
    }
    
    /// Resets the properties related to small circles to their initial values.
    func resetBubbleProperties() {
        bubblesOpacity = 0.0
        circleScale = 0.1
        calculateSizeProperties()
    }
    
    /// Sets the animation view size, used to dynamically calculate circle sizes.
    /// - Parameter size: The view size as CGSize.
    func setAnimationViewSize(size: CGSize) {
        self.animationViewSize = size        
    }
    
    /// Sets the bubble count.
    func setBubbleCount() {
        self.bubbleCount = 7
    }
    
    /// Dynamically calculates and sets size properties for circle elements based on the animation view size.
    func calculateSizeProperties() {
        outlineWidth = animationViewSize.width / 4
        largeBubbleRadius = ((animationViewSize.width / 2) * 42) / 100
        smallBubbleRadius = ((animationViewSize.width / 2) * 42) / 100
        largeBubbleSize = ((animationViewSize.width / 2) * 16) / 100
        smallBubbleSize = ((animationViewSize.width / 2) * 8) / 100
    }
    
    /// Resets animation sequence properties to prepare for a new animation start.
    func resetAnimation() {
        isSelected = false
        animationProgress = 0
        circleAnimation = false
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            heartScaleAnimation = false
        }
    }
    
    /// Starts the animation sequence, including the heart scaling and circle animations.
    func startAnimationSequence() {
        heartScaleAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            circleAnimation = true
        }
    }
}
