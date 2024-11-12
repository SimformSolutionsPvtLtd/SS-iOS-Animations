//
//  SSLRArrowView.swift
//  SSSwiftUIAnimations
//
//  Created by Mansi Prajapati on 31/10/22.
//

import SwiftUI

public struct SSLRArrowView: View {
    
    // MARK: - Variables
    
    // arrow size
    var arrowSize: CGFloat = 20
    
    // Custom arrow animation style
    var arrowViewAnimStyle: LRArrowAnimStyle = LRArrowAnimStyle()
    
    // Callback for left arrow view tap
    var leftArrowViewTap: (() -> Void)?
    
    // Callback for right arrow view tap
    var rightArrowViewTap: (() -> Void)?
    
    // MARK: - Body view
    public var body: some View {
        HStack(spacing: 20 + arrowViewAnimStyle.circleStrokeSize) {
            
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
            }.rotationEffect(Angle(degrees: 180))
            .padding(.vertical, 30)
        }
    }
    
    // MARK: - Private functions
    private func CircleArrowView() -> some View {
        CircularView(arrowSize: arrowSize, arrowAnimStyle: arrowViewAnimStyle)
    }
}
