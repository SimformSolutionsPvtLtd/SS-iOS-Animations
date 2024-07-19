//
//  BubbleView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 15/07/24.
//

import SwiftUI

/// Create a view with Bubbles used in animation
struct BubbleView: View {
    
    // MARK: Variables
    
    /// Used for styling the view
    @State var style: SSWaterProgressViewStyle = SSWaterProgressViewStyle()
    
    /// Initial Bubble Scale
    @State private var scale : CGFloat = 1
    
    var body: some View {
        if style.showBubbles {
            ZStack {
                // Number of bubbles
                ForEach (1...10, id:\.self) { _ in
                    Circle()
                        .foregroundColor(style.bubbleColor.opacity(Double.random(in: 0.15...0.25)))
                        .scaleEffect(self.scale * .random(in: 0.5...1))
                        .frame(width: .random(in: 1...25),
                               height: CGFloat.random (in: 20...25),
                               alignment: .center)
                        .position(
                            CGPoint(
                                x: .random(in: style.circleSize/4...style.circleSize/1.3),
                                y: .random (in: style.circleSize/5...style.circleSize/1.2)
                            )
                        )
                }
            }
            .task {
                withAnimation(
                    .spring (dampingFraction: 0.5)
                    .repeatForever()
                    .speed(.random(in: 0.1...0.15))
                    .delay(.random(in: 0.01...0.1))
                ) {
                    self.scale = 1.2 // default circle scale
                }
            }
        }
    }
}

#Preview {
    BubbleView()
}
