//
//  ContentView.swift
//  SSSwiftUIAnimations
//
//  Created by Purva Ruparelia on 12/09/22.
//

import SwiftUI

struct ContentView: View {

    @State var isActive = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, world!")
                    .padding()
                NavigationLink(destination: ArrowView()) {
                    Text("Login")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
