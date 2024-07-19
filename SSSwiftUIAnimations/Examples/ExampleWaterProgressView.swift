//
//  ExampleWaterProgressView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 09/07/24.
//

import SwiftUI

struct ExampleWaterProgressView: View {
    
    // MARK: - Variables
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack {
            SSWaterProgressView(progress: $progress,
                                showPercent: true,
                                style: SSWaterProgressViewStyle(
                                    circleSize: 200,
                                    circleStrokeWidth: 10,
                                    progressFont: .system(size: 16, weight: .bold),
                                    progressTextColor: .black,
                                    emptyStrokeColor: .cyan.opacity(0.2),
                                    fillStrokeColor: .cyan,
                                    waterColor: .mint,
                                    showBubbles: true,
                                    bubbleColor: .white,
                                    checkMarkImg: "checkmark",
                                    checkMarkImgColor: .white
                                ),
                                onProgressCompletion: { print("Progress Completed") })
            Spacer()
                .frame(height: 40)
            Slider(value: $progress) {
                Text("Slide to manage progress")
            }
            .frame(width: 150, alignment: .bottom)
        }
        .customToolbar(title: "Water ProgressView Example", fontSize: 17)
    }
}

#Preview {
    ExampleWaterProgressView()
}
