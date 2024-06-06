//
//  WaveView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 24/04/24.
//

import SwiftUI

struct WaveView: View {
    
    // MARK: - Variables
    @State private var amplitude: CGFloat = 0.0
    @State private var phase: CGFloat = 0.0
    @State private var height: CGFloat = 18
    @Binding var progress: Float
    var arrowStrokeWidth: CGFloat
    var width: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            let waveProgress = 1.0 / CGFloat(5)
            let normedAmplitude = (1.5 * waveProgress - 0.8) * self.amplitude
            
            Wave(
                phase: phase,
                normedAmplitude: normedAmplitude,
                width: width
            )
            .stroke(style: StrokeStyle(lineWidth: arrowStrokeWidth, lineCap: .round))
            .frame(width: width * 0.44, height: height)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
                    if progress >= 0.001 && progress < 0.92 {
                        // Wave animation
                        withAnimation( Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            self.amplitude = 0.8
                            self.phase -= 6.0
                        }
                    } else if progress >= 0.92 && progress < 0.99 {
                        // Slowly transforming wave to straight line
                        withAnimation(Animation.linear(duration: 2)) {
                            self.amplitude = 0
                            self.phase -= 0.3
                        }
                    } else if progress >= 0.99 {
                        timer.invalidate()
                    }
                }
            }
        }
    }
}

struct Wave: Shape {
    
    // MARK: - Variables
    var phase: CGFloat
    var normedAmplitude: CGFloat
    var width: CGFloat
    
    // MARK: - Aniamatable data
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(normedAmplitude, phase)}
        
        set {
            self.normedAmplitude = newValue.first
            self.phase = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let maxAmplitude = rect.height / 2
        let mid = rect.width / 2
        let density = 0.7
        let lineWidth =  width < 150 ? 1.5 : 1.0
        
        for x in Swift.stride(from: 0, 
                              to: rect.width + density + lineWidth,
                              by: density
        ) {
            let scaling = -pow(1 / mid * (x - mid), 2) + width * 0.02
            let y = scaling * maxAmplitude * normedAmplitude * sin(CGFloat(2 * Double.pi) * (0.8) * (x / rect.width)  + self.phase) + rect.height / 3
            
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x + 2, y: y))
            }
        }
        return path
    }
}
