//
//  ArrowAnimation.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 31/10/22.
//

import SwiftUI

struct ArrowView: View {
    
    var arrowSize: CGFloat = 20
    var circleSize: CGFloat = 80
    var strokeEmptyColor: Color = Color.white
    var strokeFillColor: Color = Color.white
    var arrowColor: Color = Color.white
    
    var body: some View {
        HStack(spacing: 20) {
            CircularView(arrowSize: arrowSize, strokeEmptyColor: strokeEmptyColor, strokeFillColor: strokeFillColor, circleSize: circleSize, arrowColor: arrowColor)
            CircularView(arrowSize: arrowSize, strokeEmptyColor: strokeEmptyColor, strokeFillColor: strokeFillColor, circleSize: circleSize, arrowColor: arrowColor).rotationEffect(Angle(degrees: 180)).padding(.vertical, 30)
        }.frame(width: 300, height: 300).background(.blue)
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView(arrowSize: 25, circleSize: 80)
    }
}

struct CircularView: View {
    
    @State var endProgress = 0.0
    @State var isRightArrowCLicked = false
    @State var clickOffset: CGFloat = 30/4
    @State var startProgress: CGFloat = 0.0
    var animationDuration = 0.4
    @State var arrowSize: CGFloat
    var strokeEmptyColor: Color
    var strokeFillColor: Color
    @State var circleSize: CGFloat
    var arrowColor: Color
    
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    strokeEmptyColor.opacity(0.2),
                    lineWidth: 4
                ).frame(width: circleSize, height: circleSize)
            
            Circle()
                .trim(from: isAnimating ? startProgress : 0.5 , to: isAnimating ? endProgress : 0.5)
                .stroke(
                    strokeFillColor,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .butt,
                        lineJoin: .round
                    )
                ).frame(width: circleSize, height: circleSize).rotationEffect(.degrees(0)).animation(.linear(duration: 1.6).speed(0.08), value: endProgress)
            
            Circle()
                .trim(from: isAnimating ? startProgress : 0.5 , to: isAnimating ? endProgress : 0.5)
                .stroke(
                    strokeFillColor,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .butt,
                        lineJoin: .round
                    )
                ).frame(width: circleSize, height: circleSize).rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0)).animation(.linear(duration: 1.6).speed(0.08), value: endProgress)
            
            
            Arrow().stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: isRightArrowCLicked ? 0 : arrowSize, height: isRightArrowCLicked ? 0 : arrowSize).offset(x: clickOffset).animation(.linear(duration: 0.3), value: isRightArrowCLicked).foregroundColor(arrowColor).onTapGesture {
                    isRightArrowCLicked = true
                    startProgress = 0.5
                    isAnimating = false
                    clickOffset = -(circleSize/2)
                    
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 0.950, repeats: false) { _ in
                        endProgress = circleSize/2
                        clickOffset = circleSize/2
                        isAnimating = true
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 2, repeats: false) { _ in
                        withAnimation(Animation.linear(duration: animationDuration * 0.25)) {
                            startProgress = endProgress
                            endProgress = 0
                        }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 2.25, repeats: false) { _ in
                        withAnimation(Animation.linear(duration: animationDuration * 1.7)) {
                            isRightArrowCLicked = false
                            clickOffset = arrowSize / 4
                            isAnimating = false
                        }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 3, repeats: false) { _ in
                        isRightArrowCLicked = false
                        isAnimating = true
                    }
                }
        }.onAppear {
            if arrowSize < circleSize/4 {
                arrowSize = circleSize/4
            }
            if circleSize < arrowSize + 20 {
                circleSize = arrowSize + 20
            }
        }
    }
}
