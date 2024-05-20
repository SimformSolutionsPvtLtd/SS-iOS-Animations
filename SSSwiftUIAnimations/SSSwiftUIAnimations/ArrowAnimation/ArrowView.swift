//
//  ArrowAnimation.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 31/10/22.
//

import SwiftUI

struct ArrowView: View {
    
    // MARK: - Variables
    // arrow size
    var arrowSize = ArrowAnimConstant.arrowDefaultSize
    
    // Custom arrow animation style
    var arrowViewAnimStyle: ArrowAnimStyle = ArrowAnimStyle()
    
    // Callback for left arrow view tap
    var leftArrowViewTap: (() -> Void)?
    
    // Callback for right arrow view tap
    var rightArrowViewTap: (() -> Void)?
    
    // MARK: - Body view
    var body: some View {
        HStack(spacing: 20) {
            
            // Left arrow view
            CircularView(
                arrowSize: arrowSize,
                arrowAnimStyle: arrowViewAnimStyle
            ) {
                leftArrowViewTap?()
            }
            
            // Right arrow view
            CircularView(
                arrowSize: arrowSize,
                arrowAnimStyle: arrowViewAnimStyle
            ) {
                rightArrowViewTap?()
            }.rotationEffect(Angle(degrees: ArrowAnimConstant.oppositeDirectionAngle))
            .padding(.vertical, ArrowAnimConstant.rightViewPadding)
        }
    }
    
    // MARK: - Private functions
    private func CircleArrowView() -> some View {
        CircularView(arrowSize: arrowSize, arrowAnimStyle: arrowViewAnimStyle)
    }
}
