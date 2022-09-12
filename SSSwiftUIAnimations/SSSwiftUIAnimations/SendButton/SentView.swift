//
//  SentView.swift
//  SSSwiftUIAnimations
//
//  Created by Purva Ruparelia on 31/08/22.
//

import SwiftUI

struct SentView: View {
    @Binding var sent: Bool
    var animation: Animation
   
    var body: some View {
       ZStack {
            Image("ic_sent")
                .resizable()
                .frame(width: 35, height: 35)
                .rotationEffect(self.sent ? .degrees(45) : .degrees(0))
                .animation(self.animation, value: self.sent)
        }
    }
}

struct SentView_Previews: PreviewProvider {
    static var previews: some View {
        SentView(sent: .constant(true), animation: Animation.easeIn(duration: 0.55).delay(0.25))
    }
}
