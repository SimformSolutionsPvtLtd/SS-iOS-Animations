//
//  Color.swift
//  SSSwiftUIAnimations
//
//  Created by Akash More on 02/09/22.
//

import SwiftUI

extension Color {
    
    static let circleTrackStart: Color = Color(r: 237, g: 242, b: 255)
    static let circleTrackEnd: Color = Color(r: 235, g: 248, b: 255)
    
    static let circleRoundStart: Color = Color(r: 71, g: 198, b: 255)
    static let circleRoundEnd: Color = Color(r: 90, g: 131, b: 255)
    
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }
    
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
