//
//  LinearLoading.swift
//  SwiftUIAnimation
//
//  Created by Brijesh Barasiya on 17/05/24.
//

import SwiftUI

struct LinearLoading: View {
    @State private var sticks: [Stick]
    private let stickWidth: CGFloat
    private let stickHeight: CGFloat
    private let spacing: CGFloat
    private let filledColor: Color
    private let unFilledColor: Color
    private let perStickDuration: Double
    private let allowHeightAnimation: Bool
    
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
        sticks[index].stickHeight = allowHeightAnimation ? stickHeight * 1.25 : stickHeight
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
