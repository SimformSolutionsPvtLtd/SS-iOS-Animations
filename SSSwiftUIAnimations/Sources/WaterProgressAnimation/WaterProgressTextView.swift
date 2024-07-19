//
//  WaterProgressTextView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 16/07/24.
//

import SwiftUI

struct WaterProgressTextView: View {
    
    // MARK: - Variable
    
    /// Decide weather to show percentage text or not
    var showPercentage: Bool
    
    /// Progress percent value
    @Binding var progress: Double
    
    /// For Styling text
    var style: SSWaterProgressViewStyle
    
    var body: some View {
        if showPercentage {
            Text("\(Int(progress * 100))%")
                .font(style.progressFont)
                .foregroundStyle(style.progressTextColor)
        }
    }
}
