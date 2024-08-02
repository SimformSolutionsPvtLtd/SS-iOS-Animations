//
//  LinearLoading.swift
//  SwiftUIAnimation
//
//  Created by Brijesh Barasiya on 17/05/24.
//

import SwiftUI
    
struct LinearProgress: View {
    /// The last index of the stick that was updated.
    @State private var lastStickIndex: Int = 0
    /// The percentage of progress to be displayed.
    @Binding private var percentage: Double
    /// The sticks to be displayed in the progress bar.
    @State private var sticks: [Stick]
    /// The width of each stick.
    private let stickWidth: CGFloat
    /// The height of each stick.
    private let stickHeight: CGFloat
    /// The spacing between each stick.
    private let spacing: CGFloat
    /// The color of the progress.
    private let progressColor: Color
    /// The color of a filled stick.
    private let filledColor: Color
    /// The color of an unfilled stick.
    private let unFilledColor: Color
    /// The duration of the animation for each stick.
    private let perStickDuration: Double
    /// Whether to allow height animation for the sticks.
    private let allowHeightAnimation: Bool
    
    /// Initializes the `LinearProgress` view.
    /// - Parameters:
    ///   - percentage: The binding to the progress percentage.
    ///   - size: The size of the view.
    ///   - stickWidth: The width of each stick.
    ///   - spacing: The spacing between each stick.
    ///   - progressColor: The color of the progress.
    ///   - filledColor: The color of a filled stick.
    ///   - unFilledColor: The color of an unfilled stick.
    ///   - duration: The total duration of the animation.
    ///   - allowHeightAnimation: Whether to allow height animation for the sticks.
    init(
        percentage: Binding<Double>,
        size: CGSize,
        stickWidth: Float,
        spacing: Float,
        progressColor: Color,
        filledColor: Color,
        unFilledColor: Color,
        duration: Double,
        allowHeightAnimation: Bool
    ) {
        let screenHeight = Float(size.height)
        let adjustedStickHeight: Float = allowHeightAnimation ? (screenHeight * 0.80) : screenHeight
        let totalStickCount: Int = max(Int(Float(size.width) / (stickWidth + spacing)), 3)
        self._percentage = percentage
        self.sticks = Array(
            repeating: Stick(xAxis: 0, stickHeight: CGFloat(adjustedStickHeight), color: unFilledColor),
            count: totalStickCount
        )
        self.stickWidth = CGFloat(max(stickWidth, 5))
        self.stickHeight = CGFloat(screenHeight)
        self.spacing = CGFloat(max(min(spacing, stickWidth), 0))
        self.progressColor = progressColor
        self.filledColor = filledColor
        self.unFilledColor = unFilledColor
        self.perStickDuration = max(duration, 0.2) / Double(totalStickCount * 2)
        self.allowHeightAnimation = allowHeightAnimation
    }
    
    private var screenContent: some View {
        HStack(spacing: spacing) {
            ForEach(sticks.indices, id: \.self) { index in
                Rectangle()
                    .foregroundColor(sticks[index].color)
                    .frame(width: stickWidth, height: sticks[index].stickHeight)
                    .offset(x: sticks[index].xAxis)
            }
        }
        .onAppear {
            sticks[0].color = filledColor
            animateStickView(index: 0, isReversing: false)
        }
    }
    
    var body: some View {
        if #available(iOS 17.0, *) {
            screenContent
                .onChange(of: percentage) { oldVal, newValue in
                    if oldVal == 100 {
                        animateStickView(index: 0, isReversing: false)
                    }
                }
        } else {
            screenContent
                .onChange(of: percentage) { value in
                    animateStickView(index: 0, isReversing: false)
                }
        }
    }
    
    /// Starts and resets the animation on a particular stick view.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A boolean indicating whether the animation is in reverse mode.
    private func animateStickView(index: Int, isReversing: Bool) {
        if percentage < 100 {
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
        } else {
            sticks.indices.forEach { index in
                sticks[index].color = progressColor
            }
        }
    }
    
    /// Updates the properties of the stick view for animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A boolean indicating whether the animation is in reverse mode.
    private func updateStickViewProperties(index: Int, isReversing: Bool) {
        sticks[index].xAxis = isReversing ? (spacing * -1) : spacing
        sticks[index].stickHeight = allowHeightAnimation ? stickHeight * 1.25 : stickHeight
        sticks[index].color = getStickColor(forIndex: index, isReversing: isReversing)
        let validatedPercentage = min(max(0, percentage), 100)
        let sticksAccordingToPercentage = Double(sticks.count) * Double(validatedPercentage / 100)
        let numberOfSticksToChange = max(Int(sticksAccordingToPercentage), 0)
        for stickIndex in 0..<min(numberOfSticksToChange, index) {
            sticks[stickIndex].color = progressColor
        }
        let finalIndex = index >= numberOfSticksToChange ? numberOfSticksToChange : lastStickIndex
        lastStickIndex = finalIndex
    }
    
    /// Gets the color for the stick at a specific index.
    /// - Parameters:
    ///   - index: The index of the stick.
    ///   - isReversing: A boolean indicating whether the animation is in reverse mode.
    /// - Returns: The color for the stick.
    private func getStickColor(forIndex index: Int, isReversing: Bool) -> Color {
        switch index {
        case sticks.indices.last:
            return unFilledColor
        case lastStickIndex:
            return filledColor
        default:
            return isReversing ? unFilledColor : filledColor
        }
    }
    
    /// Resets the properties of the stick view after animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A boolean indicating whether the animation is in reverse mode.
    private func resertStickViewAnimation(index: Int, isReversing: Bool) {
        withAnimation(Animation.linear(duration: perStickDuration)) {
            sticks[index].xAxis = 0
            sticks[index].stickHeight = stickHeight
        }
        let nextIndex = isReversing ? index - 1 : index + 1
        if (index == lastStickIndex && isReversing) || (index == sticks.indices.last && !isReversing) {
            animateStickView(index: isReversing ? nextIndex + 1 : nextIndex - 1, isReversing: !isReversing)
        } else {
            animateStickView(index: nextIndex, isReversing: isReversing)
        }
    }
}

#Preview {
    LinearProgress(
        percentage: .constant(75),
        size: CGSize(width: 70, height: 30),
        stickWidth: 10,
        spacing: 6,
        progressColor: .green,
        filledColor: .black,
        unFilledColor: .gray,
        duration: 1,
        allowHeightAnimation: true
    )
}
