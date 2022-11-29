//
//  sendButton.swift
//  SSSwiftUIAnimation
//
//  Created by Darshan Gujarati on 11/11/22.
//

import SwiftUI

let p1 = CGPoint(x: 165, y: 378)
let p2 = CGPoint(x: 270, y: 320)
let p3 = CGPoint(x: 195, y: 378)
let curvePoint1 = CGPoint(x: 230, y: 230)
let curvePoint2 = CGPoint(x: 250, y: 490)

let sizeOrigin = CGSize(width: 120, height: 60)
let sizeArrowOut = CGSize(width: 70, height: 70)
let sizeSentOut = CGSize(width: 60, height: 60)

var arrowPath : Path {
    
    var result = Path()
    result.move(to: p1)
    result.addCurve(to: p2, control1: curvePoint1, control2: curvePoint1)
    result.move(to: p2)
    result.addCurve(to: p3, control1: curvePoint2, control2: curvePoint2)
    return result
}

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
    var buttonXOffset: CGFloat {
        switch self {
        case .viewCenter, .sentOut: return -48
        default: return 0
        }
    }
    var sentTextOffset: CGFloat {
        switch self {
        case .sentOut: return 70
        default: return 0
        }
    }
    var sentWidth: CGFloat {
        switch self {
        case .sentOut: return 110
        default: return 0
        }
    }
    var text: String {
        switch self {
        case .origin: return "Send"
        default: return ""
        }
    }
    var cornerRadius: CGFloat {
        switch self {
        case .origin: return Constants.cornerRadiusTwelve
        case .arrowOut, .changeArrowColor, .arrowAtP1, .arrowAtP2, .arrowAtP3,.arrowToTick: return Constants.cornerRadiusThirtyFive
        default: return Constants.cornerRadiusThirty
        }
    }
    var imageRotation: Double {
        switch self {
        case .arrowAtP1,.changeArrowColor: return -80
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
}

struct sendButtonView: View {
    let path: Path
    let start: CGPoint
    let duration: Double = 3
    
    @State var frameSize = sizeOrigin
    @State var isMovingForward = false
    
    var tMax : CGFloat { isMovingForward ? 1 : 0 }
    var opac : Double  { isMovingForward ? 1 : 0 }
    @State var animationState: SendState
    var body: some View {
        VStack {
            ZStack {
                Text("Sent!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(width: animationState.sentWidth, height: 40, alignment: .center)
                    .background(.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .offset(x: animationState.sentTextOffset)
                
                ZStack {
                    Text(animationState.text)
                        .frame(alignment: .center)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .offset(x: 15)
                }
                .frame(width: frameSize.width, height:  frameSize.height)
                .background(Color.cyan)
                .cornerRadius(animationState.cornerRadius)
                .animation(animationState.animation, value: animationState)
                
                Image(animationState.imageName)
                    .rotationEffect(Angle(degrees: animationState.imageRotation), anchor: .center)
                    .foregroundColor(animationState.imageColor)
                    .modifier(Moving(time: tMax, path: path, start: start))
            }
        }
        .shadow(radius: 10)
        .offset(x: animationState.buttonXOffset)
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
                frameSize = sizeOrigin
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
        sendButtonView(path: arrowPath, start: p1, animationState: .origin)
    }
}
