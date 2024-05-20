//
//  ExampleArrowAnimation.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 20/05/24.
//

import SwiftUI

struct ExampleArrowAnimation: View {
    var body: some View {
        ArrowView(arrowSize: 10, arrowViewAnimStyle: ArrowAnimStyle(strokeFillColor: .blue, arrowColor: .blue), leftArrowViewTap: ({
            print("left arrow tap")
        }), rightArrowViewTap: ({
            print("right arrow tap")
        }))
    }
}
