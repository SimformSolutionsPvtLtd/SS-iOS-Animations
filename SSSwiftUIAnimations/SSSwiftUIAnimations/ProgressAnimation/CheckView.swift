//
//  CheckView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 16/04/24.
//

import SwiftUI

struct CheckView: View {
    
    // MARK: - Variables
    
    // For drawing straight line before check mark
    @State private var x = 0.92
    @State private var y = 2.5
    
    // Width of line and check mark
    @State var width: CGFloat = 0

    // For scale and offset of check mark
    @State private var size: CGFloat = 0
    @State private var isAnimating = false
    @State private var straight: CGFloat = 0
    @State private var offset = 0
    
    var arrowStrokeWidth: CGFloat
    
    var body: some View {
        ZStack(alignment:.center) {
            VStack {
                Check(endPoint: CGPoint(
                    x: isAnimating ? 0.3 : x,
                    y: isAnimating ? 4.5 : y),
                    height: size,
                    stright: straight)
                .stroke(style: StrokeStyle(lineWidth: isAnimating ? arrowStrokeWidth / (size * 0.01) : arrowStrokeWidth, lineCap: .round))
                .frame(width: width * 0.57, height: 105)
                .offset(CGSize(width: 0, height: isAnimating ? offset : 0))
            }.scaleEffect(
                CGSize(
                    width: isAnimating ? size * 0.01 : 1,
                    height: isAnimating ? size * 0.01 : 1
                ), anchor: .center
            )
        }.onAppear() {
            size = width
            offset = size <= 150 ? -10 : -1
            
            // For changing width once it turns from line to check mark
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.linear(duration: 0.5)) {
                    isAnimating = true
                    width = 65
                }
            }
            
            // For increasing the Y of check mark
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                straight = 18.0
            }
        }
    }
}

struct Check: Shape {
    
    // MARK: - Variables
    var endPoint: CGPoint
    var height: CGFloat
    var stright: CGFloat
    
    // MARK: - Animatable data
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(endPoint.x, endPoint.y) }
        set {
            endPoint.x = newValue.first
            endPoint.y = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let rightLine = height < 150 ? 1.07 : 1.10
        let start = CGPoint(
            x: rect.midX * 0.23,
            y: rect.midY - 21 * endPoint.x - 0.2
        )
        let end = CGPoint(
            x: rect.maxX/2,
            y: rect.maxY * endPoint.y / 8
        )
        let start2 = CGPoint(
            x: rect.maxX/rightLine,
            y: rect.midY - 21 * endPoint.x - stright
        )
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        path.move(to: start2)
        path.addLine(to: end)
        return path
    }
}
