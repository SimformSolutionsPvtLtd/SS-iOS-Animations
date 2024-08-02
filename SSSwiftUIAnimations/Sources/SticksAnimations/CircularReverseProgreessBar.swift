//
//  SwiftUIView.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 28/02/24.
//

import SwiftUI

struct CircularReverseProgressBar: View {
    /// The last index of the stick that was updated.
    @State private var lastStickIndex: Int = 0
    /// The percentage of progress to be displayed.
    @Binding private var percentage: Double
    /// The sticks to be displayed in the loading indicator.
    @State private var sticks: [Stick]
    /// The size of the circle.
    private let circleSize: CGFloat
    /// The width of each stick.
    private let stickWidth: CGFloat
    /// The color of the progress.
    private let progressColor: Color
    /// The color of a filled stick.
    private let filledColor: Color
    /// The color of an unfilled stick.
    private let unFilledColor: Color
    /// The duration of the animation for each stick.
    private let perStickDuration: Double
    
    /// Initializes the `CircularReverseProgressBar` view.
    /// - Parameters:
    ///   - percentage: The binding to the progress percentage.
    ///   - size: The size of the view.
    ///   - progressColor: The color of the progress.
    ///   - filledColor: The color of a filled stick.
    ///   - unFilledColor: The color of an unfilled stick.
    ///   - duration: The total duration of the animation.
    init(
        percentage: Binding<Double>,
        size: CGSize,
        progressColor: Color,
        filledColor: Color,
        unFilledColor: Color,
        duration: Double
    ) {
        let adjustedSize = min(size.width, size.height)
        let adjustedStickWidth = adjustedSize * 0.05
        let totalStickCount: Int = Int(adjustedSize / (adjustedStickWidth * 0.75))
        self._percentage = percentage
        self.sticks = Array(
            repeating: Stick(xAxis: 0, stickHeight: (adjustedSize * 0.20), color: unFilledColor),
            count: totalStickCount
        )
        self.circleSize = CGFloat(adjustedSize)
        self.stickWidth = CGFloat(adjustedStickWidth)
        self.progressColor = progressColor
        self.filledColor = filledColor
        self.unFilledColor = unFilledColor
        self.perStickDuration = duration / Double(totalStickCount)
    }
    
    private var screenContent: some View {
        Circle()
            .frame(width: circleSize)
            .foregroundColor(Color.clear)
            .overlay {
                ForEach(0..<sticks.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: stickWidth, height: (stickWidth * 3))
                        .foregroundColor(sticks[index].color)
                        .offset(y: (circleSize - sticks[index].stickHeight) / 2)
                        .rotationEffect(
                            .degrees(Double((CGFloat(index) + sticks[index].xAxis) * 360) / Double(sticks.count))
                        )
                }
            }
            .onAppear {
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
        sticks[index].xAxis = isReversing ? -0.6 : 0.6
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
    
    /// Resets the properties of the stick view after animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - isReversing: A boolean indicating whether the animation is in reverse mode.
    private func resertStickViewAnimation(index: Int, isReversing: Bool) {
        withAnimation(Animation.linear(duration: perStickDuration)) {
            sticks[index].xAxis = 0
        }
        let nextIndex = isReversing ? index - 1 : index + 1
        if (index == (lastStickIndex) && isReversing) || (index == sticks.indices.last && !isReversing) {
            animateStickView(index: isReversing ? nextIndex + 1 : nextIndex - 1, isReversing: !isReversing)
        } else {
            animateStickView(index: nextIndex ,isReversing: isReversing)
        }
    }
    
    /// Gets the color for the stick at a specific index.
    /// - Parameters:
    ///   - index: The index of the stick.
    ///   - isReversing: A boolean indicating whether the animation is in reverse mode.
    /// - Returns: The color for the stick.
    private func getStickColor(forIndex index: Int, isReversing: Bool) -> Color {
        return if (index == lastStickIndex) {
            filledColor
        } else if (index == sticks.indices.last) {
            unFilledColor
        } else {
            (isReversing ? unFilledColor : filledColor)
        }
    }
}

#Preview {
    CircularReverseProgressBar(
        percentage: .constant(100),
        size: CGSize(width: 150, height: 150),
        progressColor: .red,
        filledColor: .green,
        unFilledColor: .gray,
        duration: 3
    )
}
