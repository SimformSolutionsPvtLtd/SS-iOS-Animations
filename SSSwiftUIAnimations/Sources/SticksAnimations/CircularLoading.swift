//
//  CircularLoading.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 29/01/24.
//

import SwiftUI

struct CircularLoading: View {
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
    
    /// Initializes the `CircularLoading` view.
    /// - Parameters:
    ///   - size: The size of the view.
    ///   - filledColor: The color of a filled stick.
    ///   - unFilledColor: The color of an unfilled stick.
    ///   - duration: The total duration of the animation.
    init(
        size: CGSize,
        filledColor: Color,
        unFilledColor: Color,
        duration: Double
    ) {
        let adjustedSize = min(size.width, size.height)
        let adjustedStickWidth = adjustedSize * 0.05
        let totalStickCount: Int = Int(adjustedSize / (adjustedStickWidth * 0.75))
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
    
    var body: some View {
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
    
    /// Starts and resets the animation on a particular stick view.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - color: The color to animate to.
    private func animateStickView(index: Int, color: Color) {
        if #available(iOS 17.0, *) {
            withAnimation(Animation.linear(duration: perStickDuration)) {
                updateStickViewProperties(index: index, color: color)
            } completion: {
                resetStickViewAnimation(index: index, color: color)
            }
        } else {
            withAnimation(Animation.linear(duration: perStickDuration)) {
                updateStickViewProperties(index: index, color: color)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + perStickDuration) {
                resetStickViewAnimation(index: index, color: color)
            }
        }
    }

    /// Updates the properties of the stick view for animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - color: The color to animate to.
    private func updateStickViewProperties(index: Int, color: Color) {
        sticks[index].xAxis = 0.6
        sticks[index].color = color
    }

    /// Resets the properties of the stick view after animation.
    /// - Parameters:
    ///   - index: The index of the current stick.
    ///   - color: The color to animate to.
    private func resetStickViewAnimation(index: Int, color: Color) {
        withAnimation(Animation.linear(duration: perStickDuration * 10)) {
            sticks[index].xAxis = 0
        }
        if index == sticks.indices.last {
            let newColor = switch color {
            case unFilledColor: filledColor
            case filledColor: unFilledColor
            default: filledColor
            }
            animateStickView(index: 0, color: newColor)
        } else {
            animateStickView(index: index + 1, color: color)
        }
    }
}

#Preview {
    CircularLoading(
        size: CGSize(width: 150, height: 150),
        filledColor: .black,
        unFilledColor: .gray,
        duration: 1
    )
}
