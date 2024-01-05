//
//  CircularStickProgressBar.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 05/01/24.
//

import SwiftUI

struct CircularStickLoader: View {
    @State private var sticks: [Stick]
    private let circleRadius: CGFloat
    private let stickWidth: CGFloat
    private var spacing: CGFloat = 0.6
    private let filledColor: Color
    private let unFilledColor: Color
    private let duration: Double
    
    init(
        size: Float = 50,
        stickWidth: Float = 0,
        filledColor: Color = .black,
        unFilledColor: Color = .gray,
        duration: Double = 1
    ) {
        let screenBounds = UIScreen.main.bounds
        let screenWidth = Float(screenBounds.width)
        let screenHeight = Float(screenBounds.height)
        
        // Adjust stick size, ensuring it doesn't exceed the screen size - 50
        let adjustedSize: Float = min(max(size, 50), min(screenWidth, screenHeight) - 50)
        
        // Adjust stick width, ensuring a minimum value of 9% of size.
        let adjustedStickWidth = min(max((adjustedSize / 100) * 9, stickWidth), (adjustedSize / 100) * 20)
        
        let circumference = 2 * .pi * adjustedSize
        let spacing = circumference / adjustedStickWidth
        let totalStickCount: Int = Int((spacing * 25) / 100)
        self.sticks = Array(repeating: Stick(xAxis: 0, color: unFilledColor), count: totalStickCount)
        self.circleRadius = CGFloat(adjustedSize/2)
        self.stickWidth = CGFloat(adjustedStickWidth)
        self.filledColor = filledColor
        self.unFilledColor = unFilledColor
        self.duration = duration / Double(totalStickCount)
    }
    
    var body: some View {
        Circle()
            .frame(width: circleRadius * 2)
            .foregroundColor(Color.clear)
            .overlay {
                ForEach(0..<sticks.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: stickWidth, height: (stickWidth * 2))
                        .foregroundColor(sticks[index].color)
                        .offset(y: (circleRadius - stickWidth))
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
            withAnimation(Animation.linear(duration: duration)) {
                updateStickViewProperties(index: index, color: color)
            } completion: {
                resertStickViewAnimation(index: index, color: color)
            }
        } else {
            withAnimation(Animation.linear(duration: duration)) {
                updateStickViewProperties(index: index, color: color)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                resertStickViewAnimation(index: index, color: color)
            }
        }
    }
    
    private func updateStickViewProperties(index: Int, color: Color) {
        sticks[index].xAxis = spacing
        sticks[index].color = color
    }
    
    private func resertStickViewAnimation(index: Int, color: Color) {
        withAnimation(Animation.linear(duration: duration * 12)) {
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
    CircularStickLoader()
}
