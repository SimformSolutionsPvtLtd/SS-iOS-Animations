//
//  CircularLoading.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 29/01/24.
//

import SwiftUI

struct CircularLoading: View {
    @State private var sticks: [Stick]
    private let circleSize: CGFloat
    private let stickWidth: CGFloat
    private let filledColor: Color
    private let unFilledColor: Color
    private let perStickDuration: Double
    
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
        sticks[index].xAxis = 0.6
        sticks[index].color = color
    }
    
    private func resertStickViewAnimation(index: Int, color: Color) {
        withAnimation(Animation.linear(duration: perStickDuration * 10)) {
            sticks[index].xAxis = 0
        }
        if (index == sticks.indices.last) {
            let newColor = switch color {
            case unFilledColor: filledColor
            case filledColor : unFilledColor
            default : filledColor
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
