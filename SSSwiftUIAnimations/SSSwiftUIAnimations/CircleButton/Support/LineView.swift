//
//  LineView.swift
//  SSSwiftUIAnimations
//
//  Created by Akash More on 05/09/22.
//

import SwiftUI

enum Line {
    case upper, lower
}

struct LineView: Shape {
    
    var circleSize: CGFloat = .zero
    var lineAngle: CGFloat = .zero
    var line: Line
    
    var animatableData: CGFloat {
        get { lineAngle }
        set { lineAngle = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: circleSize/2, y: circleSize/2))
            path.addLine(to: CGPoint(x: circleSize/2 + circleSize/4, y: getY()))
        }
    }
    
    func getY() -> CGFloat {
        
        switch line {
            
        case .upper:
            return circleSize/2 - lineAngle
            
        case .lower:
            return circleSize/2 + lineAngle
        }
    }
}

struct TopLeftLineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(circleSize: 200, lineAngle: 50, line: .upper)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}
