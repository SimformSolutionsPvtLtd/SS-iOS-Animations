//
//  ContentView.swift
//  SSSwiftUIAnimations
//
//  Created by Purva Ruparelia on 12/09/22.
//

import SwiftUI

struct ContentView: View {
    private var exampleList = ExampleListModel.exampleList
    
    var body: some View {
        NavigationView {
            ZStack {
                List{
                    ForEach(exampleList) {item in
                        ExampleListRow(exampleListItem: item)
                    }
                }.listStyle(.insetGrouped)
                    .listRowSpacing(10)
                    .listRowSeparator(.hidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Examples").font(Font.system(size: 30, weight: .bold)).foregroundStyle(Color.indigo)
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
