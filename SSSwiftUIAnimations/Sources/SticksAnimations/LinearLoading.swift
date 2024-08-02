//
//  LinearLoading.swift
//  SwiftUIAnimation
//
//  Created by Brijesh Barasiya on 17/05/24.
//

import SwiftUI

struct LinearLoading: View {
    /// The sticks to be displayed in the loading indicator.
    @State private var sticks: [Stick]
    /// The width of each stick.
    private let stickWidth: CGFloat
    /// The height of each stick.
    private let stickHeight: CGFloat
    /// The spacing between each stick.
    private let spacing: CGFloat
    /// The color of a filled stick which indicate as Progressed.
    private let filledColor: Color
    /// The color of an unfilled stick.
    private let unFilledColor: Color
    /// The duration of the animation for each stick.
    private let perStickDuration: Double
    /// A flag to allow height animation for the sticks.
    private let allowHeightAnimation: Bool
    
    /// Initializes the `LinearLoading` view.
    /// - Parameters:
    ///   - size: The size of the view.
    ///   - stickWidth: The width of each stick.
    ///   - spacing: The spacing between each stick.
    ///   - filledColor: The color of a filled stick.
    ///   - unFilledColor: The color of an unfilled stick.
    ///   - duration: The total duration of the animation.
    ///   - allowHeightAnimation: A flag to allow height animation for the sticks.
    init(
        size: CGSize,
        stickWidth: Float,
        spacing: Float,
        filledColor: Color,
        unFilledColor: Color,
        duration: Double,
        allowHeightAnimation: Bool
    ) {
        let screenHeight = Float(size.height)
        let adjustedStickHeight: Float = allowHeightAnimation ? (screenHeight * 0.80) : screenHeight
        let totalStickCount: Int = max(Int(Float(size.width) / (stickWidth + spacing)), 3)
        self.sticks = Array(
            repeating: Stick(xAxis: 0, stickHeight: CGFloat(adjustedStickHeight), color: unFilledColor),
            count: totalStickCount
        )
        self.stickWidth = CGFloat(max(stickWidth, 5))
        self.stickHeight = CGFloat(screenHeight)
        self.spacing = CGFloat(max(min(spacing, stickWidth), 0))
        self.filledColor = filledColor
        self.unFilledColor = unFilledColor
        self.perStickDuration = max(duration, 0.2) / Double(totalStickCount * 2)
        self.allowHeightAnimation = allowHeightAnimation
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(sticks.indices, id: \.self) { index in
                Rectangle()
                    .foregroundColor(sticks[index].color)
                    .frame(width: stickWidth, height: sticks[index].stickHeight)
                    .offset(x: sticks[index].xAxis)
            }
        }
        .frame(height: stickHeight)
        .onAppear {
            sticks[0].color = filledColor
            animateStickView(index: 0, isReversing: false)
        }
    }
    
    /// Starts and resets the animation on a particular stick view.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A flag to indicate if the animation is reversing.
    private func animateStickView(index: Int, isReversing: Bool) {
        if #available(iOS 17.0, *) {
            withAnimation(Animation.linear(duration: perStickDuration)) {
                updateStickViewProperties(index: index, isReversing: isReversing)
            } completion: {
                resertStickViewAnimation(index: index, isReversing: isReversing)
            }
        } else {
            withAnimation(Animation.linear(duration: perStickDuration)) {
                updateStickViewProperties(index: index, isReversing: isReversing)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + perStickDuration) {
                resertStickViewAnimation(index: index, isReversing: isReversing)
            }
        }
    }
    
    /// Updates the properties of the stick view for animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A flag to indicate if the animation is reversing.
    private func updateStickViewProperties(index: Int, isReversing: Bool) {
        sticks[index].xAxis = isReversing ? (spacing * -1) : spacing
        sticks[index].stickHeight = allowHeightAnimation ? stickHeight * 1.25 : stickHeight
        sticks[index].color = getStickColor(forIndex: index, isReversing: isReversing)
    }
    
    /// Gets the color of the stick.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A flag to indicate if the animation is reversing.
    /// - Returns: The color of the stick.
    private func getStickColor(forIndex index: Int, isReversing: Bool) -> Color {
        return switch (index) {
        case 0 : filledColor
        case sticks.indices.last : unFilledColor
        default: isReversing ? unFilledColor : filledColor
        }
    }
    
    /// Resets the properties of the stick view after animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A flag to indicate if the animation is reversing.
    private func resertStickViewAnimation(index: Int, isReversing: Bool) {
        withAnimation(Animation.linear(duration: perStickDuration)) {
            sticks[index].xAxis = 0
            sticks[index].stickHeight = stickHeight
        }
        let nextIndex = isReversing ? index - 1 : index + 1
        if (index == 0 && isReversing) || (index == sticks.indices.last && !isReversing) {
            animateStickView(index: isReversing ? nextIndex + 1 : nextIndex - 1, isReversing: !isReversing)
        } else {
            animateStickView(index: nextIndex, isReversing: isReversing)
        }
    }
}

#Preview {
    LinearLoading(
        size: CGSize(width: 70, height: 30),
        stickWidth: 10,
        spacing: 6,
        filledColor: .black,
        unFilledColor: .gray,
        duration: 1,
        allowHeightAnimation: true
    )
}
