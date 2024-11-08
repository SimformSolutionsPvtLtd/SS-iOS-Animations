//
//  ExampleReactionAnimationView.swift
//  SSSwiftUIAnimations
//
//  Created by Faaiz Daglawala on 07/11/24.
//

import SwiftUI

struct ExampleReactionAnimationView: View {
    
    // MARK: - Variables
    
    var body: some View {
        VStack {
            SSReactionAnimationView(
                style: SSReactionAnimationViewStyle(
                    outerCircleColor: .clear,
                    innerCircleColor: .blue,
                    defautHeartColor: .gray,
                    selectedHeartColor: .red
                )) { isSelected in }
                .frame(width: 100, height: 100)
        }
        .customToolbar(title: "ReactionAnimationView Example", fontSize: 17)
    }
    
}

#Preview {
    ExampleReactionAnimationView()
}
