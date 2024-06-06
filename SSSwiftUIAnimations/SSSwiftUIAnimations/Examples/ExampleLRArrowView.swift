//
//  ExampleLRArrowView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 20/05/24.
//

import SwiftUI

struct ExampleLRArrowView: View {
    var body: some View {
        SSLRArrowView(arrowSize: 10,  arrowViewAnimStyle: LRArrowAnimStyle(circleSize: 100, strokeEmptyColor: .blue, strokeFillColor: .blue, arrowColor: .blue, circleStrokeSize: 5, arrowStrokeSize: 5), leftArrowViewTap: ({
            print("left arrow tap")
        }), rightArrowViewTap: ({
            print("right arrow tap")
        })).customToolbar(title: "ArrowLRView Example", fontSize: 17)
    }
}

#Preview {
    ExampleLRArrowView()
}
