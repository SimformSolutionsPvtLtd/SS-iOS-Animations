//
//  ExampleProgressView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 17/05/24.
//

import SwiftUI

struct ExampleProgressView: View {
    
    // MARK: - Variables
    @State private var progress: Float = 0.0
    @State var timer: Timer?
    
    var body: some View {
            VStack {
                SSProgressView(progress: $progress, style: SSProgressViewStyle(circleSize: 200, circleStrokeWidth: 5, arrowStrokeWidth: 5, progressTextColor: .pink, fillStrokeColor: .blue, arrowColor: .blue, allowCancelProgress: true), onProgressViewClick: {
                    simulateDownloadProgress()
                }, onProgressCompletion: {
                    timer?.invalidate()
                }, onCancelProgress: {
                    progress = 0.0
                    timer?.invalidate()
                })
        }.navigationBarTitle("ProgressView Example", displayMode: .inline)
    }
    
    // MARK: - Private functions
    private func simulateDownloadProgress() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if progress >= 1.0 {
                timer.invalidate()
            } else {
                progress += 0.01
            }
        }
    }
}
