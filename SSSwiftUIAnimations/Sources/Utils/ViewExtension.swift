//
//  ViewExtension.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 23/05/24.
//

import SwiftUI

// For using property based on condition
extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
