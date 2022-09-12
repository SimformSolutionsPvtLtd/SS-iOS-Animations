//
//  FeedbackView.swift
//  SSSwiftUIAnimations
//
//  Created by Purva Ruparelia on 31/08/22.
//

import SwiftUI
enum SendState {
    case ready
    case leading
    case moveToEnd
    case origin
    case end
    
    var offset: CGFloat {
        switch self {
        case .origin, .ready:
            return 0
        case .leading:
            return -(UIScreen.main.bounds.width/2 - 180)
        case .moveToEnd:
            return UIScreen.main.bounds.width
        default:
            return UIScreen.main.bounds.width
            
        }
    }
    
    var animation: Animation {
        switch self {
        case .origin, .ready:
            return Animation.easeIn(duration: 0.2)
        case .leading:
            return Animation.easeIn(duration: 0.3)
        case .moveToEnd:
            return Animation.linear(duration: 0.5)
        case .end:
            return Animation.easeOut(duration: 0.4)
        }
    }
    
    var text: String {
        switch self {
        case .origin, .ready:
            return "Send"
        case .leading:
            return "Sending Feedback"
        case .moveToEnd:
            return "Sending Feedback"
        case .end:
            return "Feedback Sent"
        }
    }
}
struct FeedbackView: View {
    @State var isAnimating: Bool = false
    @State var sent: Bool = false
    @State var success: Bool = false
    @State var sendAnimation: SendState
    @State var offsetX: CGFloat = -(UIScreen.main.bounds.width - 24)
    @State var radius: CGFloat = 45
    var body: some View {
        VStack {
            
            ZStack(alignment: .center) {
                Color.cyan
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    ZStack {
                        RoundedCornersShape(corners: [.topRight, .bottomRight], radius: self.radius, animation: self.sendAnimation)
                            .fill(Color(UIColor.green))
                            .offset(x: offsetX, y: 0)
                            .animation(.linear(duration: 0.5), value: offsetX)
                        // .animation(.easeInOut(duration: 10), value: radius)
                        
                    }
                }
                
                HStack(alignment: .center, spacing: 5) {
                    SentView(sent: $sent, animation: self.sendAnimation.animation)
                        .offset(x: sendAnimation.offset)
                        .scaleEffect(1)
                        .animation(sendAnimation.animation, value: sendAnimation)
                    
                    if sendAnimation == .end {
                        Image("ic_checkmark")
                            .offset(x: -20)
                            .frame(width: 60.0, height: 60.0, alignment: .trailing)
                    }
                    
                    Text(self.sendAnimation.text)
                        .foregroundColor(.black)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .offset(x: sendAnimation == .end ? -20 : 0)
                        .opacity(sendAnimation == .moveToEnd ? 0 : 1)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: sendAnimation)
                }
            }
        }
        
        .frame(height: 72)
        .cornerRadius(12)
        .padding()
        .padding([.leading, .trailing], 24)
        .shadow(radius: 10)
        .onTapGesture {
            
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (Timer) in
                self.offsetX = -(UIScreen.main.bounds.width - 24) + 120
                self.sent.toggle()
                self.sendAnimation = .leading
                
            }
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (Timer) in
                self.offsetX = 0
                self.sendAnimation = .moveToEnd
                self.radius = 12
            }
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (Timer) in
                self.sendAnimation = .end
                self.success.toggle()
            }
            Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (Timer) in
                self.offsetX = -(UIScreen.main.bounds.width - 24)
                self.sent.toggle()
                self.success.toggle()
                self.sendAnimation = .origin
                self.radius = 45
            }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(sendAnimation: .ready)
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    var radius: CGFloat
    var animation: SendState
    var animatableData: CGFloat {
        get { return radius }
        set { radius = newValue }
    }
    
    private func arrowShapePath() -> UIBezierPath {
        let size = CGSize(width: UIScreen.main.bounds.width - 48, height: 72)
        let leadingEdgeWidth = size.width * CGFloat(20) / 100
        let trailingEdgeWidth = size.width * (1 - CGFloat(20) / 100)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        //  path.addLine(to: CGPoint(x: leadingEdgeWidth, y: size.height/2))
        //  path.addCurve(to: CGPoint(x: 0, y: size.height), controlPoint1: CGPoint(x: 0, y: size.height/3), controlPoint2: CGPoint(x: 0, y: size.height/2))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: trailingEdgeWidth, y: size.height + 20))
        path.addLine(to: CGPoint(x: size.width, y: size.height/2))
        path.addLine(to: CGPoint(x: trailingEdgeWidth, y: -20))
        path.close()
        
        return path
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(animation == .moveToEnd ? arrowShapePath().cgPath : path.cgPath)
    }
}

