//
//  LeftArrow.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 11/11/22.
//

import SwiftUI

struct LeftArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}
