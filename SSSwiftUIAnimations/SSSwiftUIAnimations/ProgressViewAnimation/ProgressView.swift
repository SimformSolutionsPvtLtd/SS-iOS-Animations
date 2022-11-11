//
//  ProgressView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 11/11/22.
//

import SwiftUI

struct ProgressView: View {
    
    var body: some View {
        VStack {
//            HorizontalLine().stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
//               .frame(width: 20, height: 20).foregroundColor(.white).padding(20)
//            Line().stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
//                .frame(width: 20, height: 20).foregroundColor(.white).padding(20)
//            Down().stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
//                .frame(width: 30, height: 30).foregroundColor(.white)
            Progress()
        }.frame(width: 300, height: 300).background(.blue)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}

struct Progress: View {
    @State var isClicked: Bool = false
    var startProgress: CGFloat = 0
    @State var endProgress: CGFloat = 0
    @State var isAnimating = false
    var circleSize: CGFloat = 90
    var animationDuration = 0.4
    @State var clickOffset: CGFloat = -45
    @State var isSelected = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.white.opacity(0.2),
                    lineWidth: 4
                ).frame(width: circleSize, height: circleSize)

            Circle()
                .trim(from: isAnimating ? startProgress : 0 , to: isAnimating ? endProgress : 0)
                .stroke(
                    Color.white,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .butt,
                        lineJoin: .round
                    )
                ).frame(width: circleSize, height: circleSize).rotationEffect(.degrees(-90)).animation(.linear(duration: 1.6).speed(0.03), value: isAnimating)
            ZStack {
//                if !isClicked {
////
//                } else {
//                    HorizontalLine().stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
//                        .frame(width: 20, height: 20).padding(.bottom, circleSize/4).foregroundColor(.white)
//                }
                DownLine(isSelected: $isSelected).stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)).frame(width: 30, height: 30).padding(.bottom, isSelected ? circleSize/4 : 0).foregroundColor(.white).animation(.spring(), value: isSelected)
                Line(isClicked: isClicked).stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .frame(width: 20, height: 30).foregroundColor(.white).padding(20).padding(.bottom, 30).offset(y: isClicked ? clickOffset : 0.0)
            }.onTapGesture {
                endProgress = circleSize
                //isSelected = true
                Timer.scheduledTimer(withTimeInterval: animationDuration * 3, repeats: false) { _ in
                    withAnimation(Animation.linear(duration: animationDuration * 1.7)) {
                        isClicked = true
                        isAnimating = true
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: animationDuration * 0.2, repeats: false) { _ in
                    withAnimation(Animation.easeOut(duration: animationDuration * 0.2)) {
                       isSelected = true
                    }
                }
            }
        }
    }
}

struct Tick: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
            path.move(to: CGPoint(x: rect.maxY, y: rect.minX))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minY, y: rect.midX))
            return path
    }
}

struct DownArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
            path.move(to: CGPoint(x: rect.maxY, y: rect.midX))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY - 10))
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midX))
            return path
    }
}

struct Down: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
            path.move(to: CGPoint(x: rect.maxY, y: rect.midX))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midX))
            return path
    }
}

struct DownLine: Shape {
    @Binding var isSelected: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: isSelected ? rect.minX-10 : rect.maxY, y: isSelected ? rect.maxX : rect.midX))
        path.addLine(to: CGPoint(x: isSelected ? rect.maxY : rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: isSelected ? rect.maxY+10 : rect.minX, y: isSelected ? rect.maxY : rect.midX))
            return path
    }
}

struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
            path.move(to: CGPoint(x: rect.minX-10, y: rect.maxX))
            path.addLine(to: CGPoint(x: rect.maxY+10, y: rect.maxY))
            return path
    }
}

struct Line: Shape {
    var isClicked: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: isClicked ? CGPoint (x: rect.midX, y: rect.maxY - 10) : CGPoint(x: rect.midX, y: rect.maxX))
        path.addLine(to: isClicked ? CGPoint(x: rect.midX, y: rect.minX) : CGPoint(x: rect.midX, y: rect.midX))
//        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 40))
            return path
        
//        var path = Path()
//            path.move(to: CGPoint(x: rect.midX, y: rect.maxX + 20))
//        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
//        path.move(to: CGPoint(x: rect.midX, y: rect.midX + 30))
//        path.addLine(to: CGPoint(x: rect.midX, y: isClicked ? rect.minY + 20 : rect.minY))
//            return path
    }
}
