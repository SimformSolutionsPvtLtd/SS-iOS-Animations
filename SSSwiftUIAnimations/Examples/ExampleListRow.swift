//
//  ExampleListRow.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 20/05/24.
//

import SwiftUI

struct ExampleListRow: View {
    var exampleListItem: ExampleListModel
    
    var body: some View {
        NavigationLink(destination: exampleListItem.destinationView) {
            Text(exampleListItem.rowTitle)
                .font(Font.system(size: 16, weight: .bold))
                .foregroundStyle(.indigo)
        }.listRowBackground(
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.mint, Color.pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
                .padding(.vertical, 2).padding(.horizontal, 0)
        )
    }
}
