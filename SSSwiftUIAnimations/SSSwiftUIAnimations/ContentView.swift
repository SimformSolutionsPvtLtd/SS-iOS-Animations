//
//  ContentView.swift
//  SSSwiftUIAnimations
//
//  Created by Purva Ruparelia on 12/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FeedbackView(sendAnimation: .origin)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
