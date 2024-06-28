//
//  ContentView.swift
//  SSSwiftUIAnimations
//
//  Created by Purva Ruparelia on 12/09/22.
//

import SwiftUI

struct ContentView: View {
    @State private var percentage: Double = 0
    private var exampleList = ExampleListModel.exampleList
    
    var body: some View {
        NavigationView {
            VStack {
                StickAnimations(
                    type: .circularReversableProgressBar(percentage: $percentage),
                    duration: 3
                )
                .frame(width: 150)
                Text(String(percentage))
                Slider(value: $percentage, in: 0...100, step: 1)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
