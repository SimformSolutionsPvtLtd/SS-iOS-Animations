//
//  SwiftUIView.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 28/02/24.
//

import SwiftUI

struct CircularReverseProgreessBar: View {
    @State private var lastStickIndex: Int = 0
    @Binding private var percentage: Double
    @State private var sticks: [Stick]
    private let circleSize: CGFloat
    private let stickWidth: CGFloat
    private let progressColor: Color
    private let filledColor: Color
    private let unFilledColor: Color
    private let perStickDuration: Double
    
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
    
    var body: some View {
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
    CircularReverseProgreessBar(
        percentage: .constant(100),
        size: CGSize(width: 50, height: 250),
        progressColor: .red,
        filledColor: .green,
        unFilledColor: .gray,
        duration: 3
    )
}
