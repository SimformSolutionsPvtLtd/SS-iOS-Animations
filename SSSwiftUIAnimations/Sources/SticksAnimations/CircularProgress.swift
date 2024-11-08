//
//  CircularLoading.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 29/01/24.
//

import SwiftUI

struct CircularProgress: View {
    /// The percentage of progress to be displayed.
    @Binding private var percentage: Double
    /// The sticks to be displayed in the loading indicator.
    @State private var sticks: [Stick]
    /// The size of the circle.
    private let circleSize: CGFloat
    /// The width of each stick.
    private let stickWidth: CGFloat
    /// The color of a filled stick.
    private let filledColor: Color
    /// The color of an unfilled stick.
    private let unFilledColor: Color
    /// The duration of the animation for each stick.
    private let perStickDuration: Double
    
    /// Initializes the `CircularProgress` view.
    /// - Parameters:
    ///   - percentage: The binding to the progress percentage.
    ///   - size: The size of the view.
    ///   - filledColor: The color of a filled stick.
    ///   - unFilledColor: The color of an unfilled stick.
    ///   - duration: The total duration of the animation.
    init(
        percentage: Binding<Double>,
        size: CGSize,
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
                        .frame(width: stickWidth, height: sticks[index].stickHeight)
                        .foregroundColor(sticks[index].color)
                        .offset(y: (circleSize - sticks[index].stickHeight) / 2)
                        .rotationEffect(
                            .degrees(Double((CGFloat(index) + sticks[index].xAxis) * 360) / Double(sticks.count))
                        )
                }
            }
            .onAppear {
                animateStickView(index: 0, color: filledColor)
            }
    }
    
    public var body: some View {
        if #available(iOS 17.0, *) {
            screenContent
                .onChange(of: percentage) { oldVal, newValue in
                    if oldVal == 100 {
                        animateStickView(index: 0, color: filledColor)
                    }
                }
        } else {
            screenContent
                .onChange(of: percentage) { value in
                    animateStickView(index: 0, color: filledColor)
                }
        }
    }
    
    /// Starts and resets the animation on a particular stick view.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - color: The color to animate to.
    private func animateStickView(index: Int, color: Color) {
        if percentage < 100 {
            if #available(iOS 17.0, *) {
                withAnimation(Animation.linear(duration: perStickDuration)) {
                    updateStickViewProperties(index: index, color: color)
                } completion: {
                    resertStickViewAnimation(index: index, color: color)
                }
            } else {
                withAnimation(Animation.linear(duration: perStickDuration)) {
                    updateStickViewProperties(index: index, color: color)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + perStickDuration) {
                    resertStickViewAnimation(index: index, color: color)
                }
            }
        } else {
            changeStictsColor(color: filledColor)
        }
    }
    
    /// Updates the properties of the stick view for animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - color: The color to animate to.
    private func updateStickViewProperties(index: Int, color: Color) {
        changeStictsColor(color: unFilledColor)
        let validatedPercentage = min(max(0, percentage), 100)
        let sticksAccordingToPercentage = Double(sticks.count) * Double(validatedPercentage / 200)
        let numberOfSticksToChange = max(Int(sticksAccordingToPercentage), 0)
        for stickIndex in 0..<Int(numberOfSticksToChange) {
            updateStickColor(at: index + stickIndex, color: filledColor)
            updateStickColor(at: (index - 1) - stickIndex, color: filledColor)
        }
        if Double(numberOfSticksToChange) != round(sticksAccordingToPercentage) {
            updateStickColor(at: index + (Int(numberOfSticksToChange)), color: filledColor)
        } else if (numberOfSticksToChange == 0) {
            updateStickColor(at: index, color: color)
        }
    }
    
    /// Changes the color of all sticks.
    /// - Parameter color: The color to set for all sticks.
    private func changeStictsColor(color: Color) {
        sticks.indices.forEach { updateStickColor(at: $0, color: color) }
    }
    
    /// Updates the color of a specific stick.
    /// - Parameters:
    ///   - index: The index of the stick to update.
    ///   - color: The color to set.
    private func updateStickColor(at index: Int, color: Color) {
        let adjustedIndex = (index + sticks.count) % sticks.count
        sticks[adjustedIndex].color = color
    }
    
    /// Resets the properties of the stick view after animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - color: The color to animate to.
    private func resertStickViewAnimation(index: Int, color: Color) {
        let nextIndex = (index == sticks.indices.last) ? 0 : index + 1
        animateStickView(index: nextIndex, color: color)
    }
}

#Preview {
    CircularProgress(
        percentage: .constant(75),
        size: CGSize(width: 150, height: 150),
        filledColor: .green,
        unFilledColor: .gray,
        duration: 1
    )
}
