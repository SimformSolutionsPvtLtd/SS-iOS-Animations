//
//  CheckmarkView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 15/07/24.
//

import SwiftUI

struct CheckmarkView: View {
    
    // MARK: Variables
    
    /// Decide weather to make checkmark visible or not
    @State var displayCheckmark: Bool = false
    
    /// Initial Zoom of Checkmark
    @State private var zoom = 0.1
    
    /// Style for SSWaterProgress View
    var style: SSWaterProgressViewStyle
    
    var body: some View {
        checkMarkImg
    }
    
    private var checkMarkImg: some View {
        Image(systemName: style.checkMarkImg)
            .resizable()
            .frame(width: style.circleSize/3, height: style.circleSize/3)
            .opacity(displayCheckmark ? 1 : 0)
            .foregroundStyle(style.checkMarkImgColor)
            .scaleEffect(zoom, anchor: .center)
            .foregroundColor(.white)
            .animation(.spring(dampingFraction: 0.4), value: displayCheckmark)
            .onAppear() {
                displayCheckmark.toggle()
                zoom = 1.0
            }
    }
}
