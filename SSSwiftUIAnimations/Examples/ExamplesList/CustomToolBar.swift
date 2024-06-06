//
//  CustomToolBar.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 27/05/24.
//

import SwiftUI

//custom view modifier for the toolbar
struct CustomToolbarModifier: ViewModifier {
    var title: String
    var fontSize: CGFloat
    var color: Color
    var displayMode: NavigationBarItem.TitleDisplayMode = .inline
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(displayMode)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: fontSize, weight: .bold))
                        .foregroundColor(color)
                }
            }
    }
}

extension View {
    func customToolbar(title: String, fontSize: CGFloat, color: Color = .indigo, displayMode: NavigationBarItem.TitleDisplayMode = .inline) -> some View {
        self.modifier(CustomToolbarModifier(title: title, fontSize: fontSize, color: color))
    }
}

