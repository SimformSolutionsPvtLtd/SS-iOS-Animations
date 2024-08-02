//
//  ExampleSticksAnimations.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 25/10/24.
//

import SwiftUI

struct ExampleSticksAnimations: View {
    
    // MARK: - Variables
    @State private var percentage: Double = 0
    
    var body: some View {
        VStack {
            Text("Horizontal Loading")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            StickAnimations(type: .linearLoading(), duration: 3)
                .frame(width: 200, height: 80)
            
            Spacer().frame(height: 20)
            
            Text("Circular Loading")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            StickAnimations(type: .circularLoading, duration: 3)
                .frame(width: 200, height: 80)
            
            Spacer().frame(height: 20)
            
            Text("Horizontal Progress")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            StickAnimations(type: .linearProgressBar(percentage: $percentage), duration: 3)
                .frame(width: 200, height: 80)
            
            Spacer().frame(height: 20)
            
            Text("Circular Progress")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            StickAnimations(type: .circularProgressBar(percentage: $percentage), duration: 3)
                .frame(width: 200, height: 80)
            
            Spacer().frame(height: 20)
            
            Text("Circular Reversable Progress")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            StickAnimations(type: .circularReversableProgressBar(percentage: $percentage), duration: 3)
                .frame(width: 200, height: 80)
            
            Slider(value: $percentage, in: 1...100)
                .padding(.horizontal, 30)
        }.customToolbar(title: "Stick Animations Example", fontSize: 17)
    }
}

#Preview {
    ExampleSticksAnimations()
}

