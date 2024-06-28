//
//  CircularLoading.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 29/01/24.
//

import SwiftUI

struct CircularProgress: View {
    @Binding private var percentage: Float
    @State private var sticks: [Stick]
    private let circleSize: CGFloat
    private let stickWidth: CGFloat
    private let filledColor: Color
    private let unFilledColor: Color
    private let perStickDuration: Double
    
    init(
        percentage: Binding<Float>,
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
    
    private func animateStickView(index: Int, color: Color) {
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
    }
    
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
        }
    }
    
    private func changeStictsColor(color: Color) {
        sticks.indices.forEach { updateStickColor(at: $0, color: color) }
    }
    
    private func updateStickColor(at index: Int, color: Color) {
        let adjustedIndex = (index + sticks.count) % sticks.count
        sticks[adjustedIndex].color = color
    }
    
    private func resertStickViewAnimation(index: Int, color: Color) {
        let nextIndex = (index == sticks.indices.last) ? 0 : index + 1
        animateStickView(index: nextIndex, color: color)
    }
}

#Preview {
    CircularProgress(
        percentage: .constant(75),
        size: CGSize(width: 50, height: 250),
        filledColor: .green,
        unFilledColor: .gray,
        duration: 1
    )
}
