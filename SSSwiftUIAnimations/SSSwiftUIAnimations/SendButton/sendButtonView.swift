//
//  sendButton.swift
//  SSSwiftUIAnimation
//
//  Created by Darshan Gujarati on 11/11/22.
//

import SwiftUI

enum SendState {
    case origin
    case arrowOut
    case changeArrowColor
    case arrowAtP1
    case arrowAtP2
    case arrowAtP3
    case arrowToTick
    case sentOut
    case viewCenter
    
    var animation: Animation {
        switch self {
        case .arrowOut: return Animation.easeIn(duration: 1.0)
        case .arrowAtP1, .arrowAtP3:
            return Animation.easeIn(duration: 0.1)
        case .arrowToTick:
            return Animation.easeIn(duration: 0.0)
        default: return Animation.easeIn
        }
    }
    var text: String {
        switch self {
        case .origin: return "Send"
        default: return ""
        }
    }
    var imageRotation: Double {
        switch self {
        case .arrowAtP1, .changeArrowColor: return -80
        case .arrowAtP2: return 100
        case .arrowAtP3: return 230
        default: return 0
        }
    }
    var imageName: String {
        switch self {
        case .origin, .arrowOut, .changeArrowColor, .arrowAtP1, .arrowAtP2, .arrowAtP3:
            return "arrow"
        case .arrowToTick, .sentOut, .viewCenter:
            return "checkmark"
        }
    }
    var imageColor: Color {
        switch self {
        case .changeArrowColor, .arrowOut, .arrowAtP2, .arrowAtP3: return Color.cyan
        default: return Color.white
        }
    }
    var offY: CGFloat {
        switch self {
        case . arrowOut, .arrowAtP2, .arrowAtP3, .arrowToTick, .viewCenter: return -5
        default: return 0
        }
    }
}

struct sendButtonView: View {
    let duration: Double = 3
    var geo: GeometryProxy
    var p1: CGPoint {
        return CGPoint(x: geo.size.width / 4, y: geo.size.height / 2)
    }
    var p2: CGPoint {
        return CGPoint(x: geo.size.width + 20, y: -geo.size.height)
    }
    var p3: CGPoint {
        return CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
    }
    var curvePoint1: CGPoint {
        return CGPoint(x: geo.size.width, y: -geo.size.height * 2)
    }
    var curvePoint2: CGPoint {
        return CGPoint(x: geo.size.width, y: geo.size.height * 3)
    }
    var sizeArrowOut: CGSize {
        return CGSize(width: geo.size.height + 10, height: geo.size.height + 10)
    }
    var sizeSentOut: CGSize {
        return CGSize(width: geo.size.height, height: geo.size.height)
    }
    var path : Path {
        var result = Path()
        result.move(to: p1)
        result.addCurve(to: p2, control1: curvePoint1, control2: curvePoint1)
        result.move(to: p2)
        result.addCurve(to: p3, control1: curvePoint2, control2: curvePoint2)
        return result
    }
    
    @State var frameSize = CGSize(width: 120, height: 60)
    @State var isMovingForward = false
    @State var animationState: SendState = .origin
    
    var tMax : CGFloat { isMovingForward ? 1 : 0 }
    var opac : Double  { isMovingForward ? 1 : 0 }
    
    var body: some View {
        VStack {
            ZStack {
                Text("Sent!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(width: animationState == .sentOut ? geo.size.width / 1.1 : 0, height: geo.size.height / 1.5, alignment: .center)
                    .background(.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .offset(x: animationState == .sentOut ? geo.size.width / 1.71 : 0)
                
                ZStack {
                    Text(animationState.text)
                        .frame(alignment: .center)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .offset(x: 15)
                }
                .frame(width: frameSize.width, height:  frameSize.height)
                .background(Color.cyan)
                .cornerRadius(animationState == .origin ? geo.size.height / 5 : frameSize.height / 2)
                .offset(y: animationState.offY)
                .animation(animationState.animation, value: animationState)
                
                Image(animationState.imageName)
                    .rotationEffect(Angle(degrees: animationState.imageRotation), anchor: .center)
                    .foregroundColor(animationState.imageColor)
                    .modifier(Moving(time: tMax, path: path, start: p1))
            }
        }
        .shadow(radius: 10)
        .offset(x: (animationState == .sentOut || animationState == .viewCenter) ? -geo.size.width / 2.5 : 0)
        .onAppear {
            frameSize = geo.size
        }
        .onTapGesture {
            Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { (Timer) in
                self.animationState = .arrowAtP1
            }
            Timer.scheduledTimer(withTimeInterval: 0.09, repeats: false) { (Timer) in
                self.animationState = .changeArrowColor
            }
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (Timer) in
                frameSize =  sizeArrowOut
                self.animationState = .arrowOut
                isMovingForward = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
                    isMovingForward = false
                }
            }
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (Timer) in
                self.animationState = .arrowAtP2
            }
            Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { (Timer) in
                self.animationState = .arrowAtP3
            }
            Timer.scheduledTimer(withTimeInterval: 1.1, repeats: false) { (Timer) in
                self.animationState = .arrowToTick
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.9, repeats: false) { (Timer) in
                self.animationState = .viewCenter
            }
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (Timer) in
                frameSize = sizeSentOut
                self.animationState = .sentOut
            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (Timer) in
                frameSize = geo.size
                self.animationState = .origin
            }
        }
        .animation(animationState.animation, value: animationState)
    }
}

struct Moving: AnimatableModifier {
    var time : CGFloat
    let path : Path
    let start: CGPoint
    
    var animatableData: CGFloat {
        get { time }
        set { time = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .position(
                path.trimmedPath(from: 0, to: time).currentPoint ?? start
            )
    }
}

struct sendButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GeometryReader { geo in
                sendButtonView(geo: geo)
            }
            .frame(width: 120, height: 60, alignment: .center)
        }
    }
}
