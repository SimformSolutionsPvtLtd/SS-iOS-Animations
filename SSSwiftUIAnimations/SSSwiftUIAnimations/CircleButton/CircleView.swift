//
//  CircleView.swift
//  SSSwiftUIAnimations
//
//  Created by Akash More on 05/09/22.
//

import SwiftUI

enum ButtonDirection {
    
    case left, right, up, down
    
    var angle: Angle {
        
        switch self {
        case .left:
            return .degrees(0)
        case .right:
            return .degrees(180)
        case .up:
            return .degrees(90)
        case .down:
            return .degrees(-90)
        }
    }
}

struct CircleView: View {
    
    //    @State var buttonState: ButtonState = .ready
        
        @State private var circleSize: CGFloat = Constants.circleSize
        @State private var lineWidth: CGFloat = Constants.lineWidth
        
        @State private var startProgress: CGFloat = 0.0
        @State private var endProgress: CGFloat = 0.0
        @State private var lineAngle: CGFloat = Constants.circleSize / 4
        
        
        @State private var percentage: CGFloat = Constants.circleSize * 0.4 // 80
        @State private var xOfArrow: CGFloat = Constants.circleSize * 0.4 // 80
        
        private let animationDuration: Double = 0.4
        private var direction: ButtonDirection = .left
        
        var body: some View {
            
            ZStack {
                
                Color(r: 43, g: 81, b: 253)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    ZStack {
                        
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: lineWidth))
                            .fill(Color(r: 81, g: 129, b: 255))
                        
                        Circle()
                            .trim(from: startProgress, to: endProgress)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt, lineJoin: .round))
                            .frame(width: circleSize, height: circleSize)
                            .rotationEffect(Angle(degrees: -180))
                        
                        Circle()
                            .trim(from: startProgress, to: endProgress)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt, lineJoin: .round))
                            .frame(width: circleSize, height: circleSize)
                            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                        
                        LineView(circleSize: circleSize, lineAngle: lineAngle, line: .upper)
                            .trim(from: 0, to: percentage/100)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                            .offset(x: xOfArrow - (circleSize/2))
                            .frame(width: circleSize, height: circleSize)
                        
                        LineView(circleSize: circleSize, lineAngle: lineAngle, line: .lower)
                            .trim(from: 0, to: percentage/100)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                            .offset(x: xOfArrow - (circleSize/2))
                            .frame(width: circleSize, height: circleSize)
                        
                    }
                    .frame(width: circleSize, height: circleSize)
                    .rotationEffect(direction.angle)
                    .onTapGesture {
                        animateButton()
                    }
                }
            }
        }
        
        private func animateButton() {
            
            // Animate arrow to edge of the circle
            withAnimation(Animation.easeInOut(duration: animationDuration)) {
                percentage = 0
                xOfArrow = 0
            }
            
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                lineAngle = 0
            }
            
            // Start filling the circle from Two sides to 50%
            Timer.scheduledTimer(withTimeInterval: animationDuration * 0.950, repeats: false) { _ in
                withAnimation(Animation.easeInOut(duration: animationDuration)) {
                    endProgress = 0.5
                    xOfArrow = circleSize
                }
            }

            // Move the start point of filled circle path to end point
            Timer.scheduledTimer(withTimeInterval: animationDuration * 1.95, repeats: false) { _ in
                withAnimation(Animation.easeInOut(duration: animationDuration)) {
                    startProgress = 0.5
                }
            }

            // Move circle filled path to zero to re-start the circle fill animation
            Timer.scheduledTimer(withTimeInterval: animationDuration * 3.25, repeats: false) { _ in
                startProgress = 0.0
                endProgress = 0.0
            }
            
            // Animate arrow back into the circle from the trailing edge
            Timer.scheduledTimer(withTimeInterval: animationDuration * 3.00, repeats: false) { _ in
                
                withAnimation(Animation.easeInOut(duration: animationDuration)) {
                    percentage = circleSize * 0.4
                    xOfArrow = circleSize * 0.4
                }
                
                // Separate easeIn animation for arrow to slide into the circle
                withAnimation(Animation.easeIn(duration: animationDuration)) {
                    lineAngle = circleSize/4
                }
            }
        }
    }

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
