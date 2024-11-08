//
//  ContentView.swift
//  ReactionAnimationSwiftUI
//
//  Created by Faaiz Daglawala on 15/12/22.
//

import SwiftUI

/// This is the Main View of ReactionAnimation. Add this to your View Hierarchy to start
/// using animation in your screen. It will displays a heart animation with expanding circles and smaller animated circles surrounding it.
/// Use case Example:
/// ```swift
///  SSReactionAnimationView(
///      style: SSReactionAnimationViewStyle(
///          outerCircleColor: .clear,
///          innerCircleColor: .blue,
///          defautHeartColor: .gray,
///          selectedHeartColor: .red
///      )
///  )
///  .frame(width: 100, height: 100)
/// ```
public struct SSReactionAnimationView: View {
    
    // MARK: - Properties
    
    /// The ViewModel that manages the animation states and properties.
    @ObservedObject var viewModel: SSReactionAnimationViewModel
    
    /// A closure that is triggered when the animation is completed.
    /// The closure takes a single `Bool` parameter that indicates whether
    /// the animation concluded with the item in a selected state.
    var onAnimationCompleted: ((_ isSelected: Bool) -> ())?
        
    // MARK: - Initializer
    
    /// Initializes a new `SSReactionAnimationView` with a specified style and an optional
    /// completion handler for the animation.
    ///
    /// - Parameters:
    ///   - style: A `SSReactionAnimationViewStyle` object that defines the colors and other styling options for the animation.
    ///   - onAnimationCompleted: An optional closure that is called when the animation completes,
    ///     with a `Bool` indicating if the item is in a selected state.
    public init(style: SSReactionAnimationViewStyle, onAnimationCompleted: ((_ isSelected: Bool) -> ())? = nil) {
        self.viewModel = SSReactionAnimationViewModel(style: style)
        self.onAnimationCompleted = onAnimationCompleted
    }
    
    public var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                // Background Circle
                Circle()
                    .fill(viewModel.style.outerCircleColor)
                
                // Heart Icon - shows either a default or selected version based on animation state.
                if viewModel.isSelected {
                    // Display a selected-color heart after all animations are complete.
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometryProxy.size.width / 2, height: geometryProxy.size.height / 2)
                        .foregroundColor(viewModel.style.selectedHeartColor)
                        .opacity(1)
                        .onTapGesture {
                            // Reset small circles and animations when the selected heart is tapped.
                            viewModel.resetBubbleProperties()
                            viewModel.resetAnimation()
                        }
                } else {
                    // Default-colored heart that scales down when the animation starts.
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometryProxy.size.width / 2, height: geometryProxy.size.height / 2)
                        .foregroundColor(viewModel.style.defautHeartColor)
                        .opacity(viewModel.heartScaleAnimation ? 0 : 1)
                        .scaleEffect(viewModel.heartScaleAnimation ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.heartScaleAnimation)
                        .onTapGesture {
                            // Start the animation when the default heart is tapped.
                            viewModel.startAnimationSequence()
                        }
                }
                
                // Main expanding circles animation when the `circleAnimation` state is active.
                if viewModel.circleAnimation {
                    MainAnimationCircles(viewModel: viewModel)
                }
            }
            .onChange(of: viewModel.isSelected) { _ in
                onAnimationCompleted?(viewModel.isSelected)
            }
            .onAppear {
                viewModel.setBubbleCount()
                // Set the geometry size in the ViewModel for positioning calculations.
                viewModel.setAnimationViewSize(size: geometryProxy.size)
                viewModel.calculateSizeProperties()
            }
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
        }
    }
    
    /// A view that handles displaying the main animated circles around the central circle.
    private struct MainAnimationCircles: View {
        
        // MARK: - Properties
        
        /// Binding to the parent view's ViewModel to access animation properties.
        @ObservedObject var viewModel: SSReactionAnimationViewModel
        
        // MARK: - Body
        
        var body: some View {
            ZStack {
                // Seven Large Circles around the central circle, each positioned based on angle calculation.
                ForEach(0..<viewModel.bubbleCount, id: \.self) { index in
                    Circle()
                        .fill(viewModel.largeBubbleColors[index])
                        .frame(width: viewModel.largeBubbleSize, height: viewModel.largeBubbleSize)
                        .opacity(viewModel.bubblesOpacity)
                        .offset(x: viewModel.largeBubbleRadius * cos(viewModel.angle(for: index)),
                                y: viewModel.largeBubbleRadius * sin(viewModel.angle(for: index)))
                }
                
                // Seven Small Circles around the central circle, offset by an additional angle spacing.
                ForEach(0..<viewModel.bubbleCount, id: \.self) { index in
                    Circle()
                        .fill(viewModel.smallBubbleColors[index])
                        .frame(width: viewModel.smallBubbleSize, height: viewModel.smallBubbleSize)
                        .opacity(viewModel.bubblesOpacity)
                        .offset(x: viewModel.smallBubbleRadius * cos(viewModel.angle(for: index, withOffset: viewModel.angleSpacing)),
                                y: viewModel.smallBubbleRadius * sin(viewModel.angle(for: index, withOffset: viewModel.angleSpacing)))
                }
                
                // Expanding blue circle animation around the main heart.
                Circle()
                    .strokeBorder(viewModel.style.innerCircleColor, lineWidth: viewModel.outlineWidth)
                    .frame(width: viewModel.animationViewSize.width / 2, height: viewModel.animationViewSize.height / 2)
                    .scaleEffect(viewModel.circleScale)
            }
            .onAppear {
                // Start the expansion animation when view appears.
                viewModel.triggerCircleExpansion()
            }
        }
    }
}
