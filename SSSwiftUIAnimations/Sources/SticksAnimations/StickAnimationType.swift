//
//  StickAnimationType.swift
//  SSSwiftUIAnimations
//
//  Created by Brijesh Barasiya on 28/06/24.
//

import SwiftUI

enum StickAnimationType {
    case linearLoading(
        stickWidth: Float = 10,
        spacing: Float = 6,
        allowHeightAnimation: Bool = true
    )
    case linearProgressBar(
        percentage: Binding<Double>,
        stickWidth: Float = 10,
        spacing: Float = 6,
        progressColor: Color = .green,
        allowHeightAnimation: Bool = true
    )
    case circularLoading
    case circularProgressBar(percentage: Binding<Double>)
    case circularReversableProgressBar(
        percentage: Binding<Double>,
        progressColor: Color = .green
    )
}
