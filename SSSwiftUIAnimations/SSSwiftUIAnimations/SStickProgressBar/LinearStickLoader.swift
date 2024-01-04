//
//  LinearStickProgressBar.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 04/01/24.
//

import SwiftUI

struct LinearStickLoader: View {
    @State private var sticks: [Stick]
    private let spacing: CGFloat
    private let stickWidth: CGFloat
    private let stickHeight: CGFloat
    private let filledColor: Color
    private let unFilledColor: Color
    private let perStickDuration: Double
    private let allowStickHeightAnimation: Bool
    
    init(
        stickCount: Int,
        spacing: Float,
        stickWidth: Float = 10,
        stickHeight: Float = 55,
        filledColor: Color = .black,
        unFilledColor: Color = .white,
        duration: Double = 1,
        allowStickHeightAnimation: Bool = true
    ) {
        let screenBounds = UIScreen.main.bounds
        let screenWidth = Float(screenBounds.width)
        let screenHeight = Float(screenBounds.height)
        
        // Adjust stick width, ensuring a minimum value of 10
        let adjustedStickWidth = max(stickWidth, 10)
        
        // Adjust spacing, ensuring a space is not lowerthan 0.
        let adjustedSpacing = max(spacing, 0)
        
        // Adjust stick height, ensuring it doesn't exceed the screen height - 50
        let adjustedStickHeight = min(max(stickHeight, adjustedSpacing + 10), screenHeight - 50)
        
        // Calculate the total number of sticks, considering screen width and spacing
        let totalStickCount = min(Int(screenWidth / (adjustedStickWidth + adjustedSpacing)) - 1, max(stickCount, 3))
        
        // Calculate the animation duration per stick
        self.perStickDuration = max(duration / Double(totalStickCount), 1 / Double(totalStickCount))
        
        self.sticks = Array(repeating: Stick(xAxis: 0, color: unFilledColor), count: totalStickCount)
        self.spacing = CGFloat(adjustedSpacing)
        self.stickWidth = CGFloat(adjustedStickWidth)
        self.stickHeight = CGFloat(adjustedStickHeight)
        self.filledColor = filledColor
        self.unFilledColor = unFilledColor
        self.allowStickHeightAnimation = allowStickHeightAnimation
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(sticks.indices, id: \.self) { index in
                Rectangle()
                    .foregroundColor(sticks[index].color)
                    .frame(width: stickWidth, height: allowStickHeightAnimation ? abs(sticks[index].xAxis) + (stickHeight - spacing) : stickHeight)
                    .offset(x: sticks[index].xAxis)
            }
        }
        .frame(height: stickHeight)
        .onAppear {
            sticks[0].color = filledColor
            animateStickView(index: 0, isReversing: false)
        }
    }
    
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
    
    private func updateStickViewProperties(index: Int, isReversing: Bool) {
        sticks[index].xAxis = isReversing ? (spacing * -1) : spacing
        sticks[index].color = getStickColor(forIndex: index, isReversing: isReversing)
    }
    
    private func getStickColor(forIndex index: Int, isReversing: Bool) -> Color {
        return switch (index) {
        case 0 : filledColor
        case sticks.indices.last : unFilledColor
        default: isReversing ? unFilledColor : filledColor
        }
    }
    
    private func resertStickViewAnimation(index: Int, isReversing: Bool) {
        withAnimation(Animation.linear(duration: perStickDuration)) {
            sticks[index].xAxis = 0
        }
        let nextIndex = isReversing ? index - 1 : index + 1
        if (index == 0 && isReversing) || (index == sticks.indices.last && !isReversing) {
            animateStickView(index: isReversing ? nextIndex + 1 : nextIndex - 1, isReversing: !isReversing)
        } else {
            animateStickView(index: nextIndex, isReversing: isReversing)
        }
    }
}

struct Stick {
    var xAxis: CGFloat
    var color: Color
}

#Preview {
    LinearStickLoader(
        stickCount: 0,
        spacing: -10,
        stickWidth: 3,
        stickHeight: 50,
        filledColor: .black,
        unFilledColor: .blue,
        duration: 10,
        allowStickHeightAnimation: true
    )
}
