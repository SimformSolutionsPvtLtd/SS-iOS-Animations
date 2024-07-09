//
//  WaterCircleView.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 09/07/24.
//

import SwiftUI

struct WaterCircleView: Shape {
    
    // MARK: - Variables
    
    /// Progress Value used to determine the height of water
    var progress: Double
    
    /// Initial Animation Start
    var offset: Angle
    
    /// Enabling Animation
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    /**
     Creates a path that represents a wave or a solid background, depending on the provided progress value.
     
     - Parameters:
     - rect: A CGRect object defining the rectangle within which the path will be created.
     
     - Returns:
     A Path object representing the wave or solid background.
     
     This function generates a path suitable for drawing a wave or a solid rectangle within the given rectangle. It calculates the wave height and position based on the `progress` value (assumed to be a variable outside the function).
     
     The path creation process involves the following steps:
     
     1. **Wave Parameters:** It defines the lowest and highest possible wave heights (`lowestWave` and `highestWave`).
     2. **Wave Height Calculation:** Calculates the normalized wave height (`newPercent`) based on `progress`, and then determines the wave's amplitude (`waveHeight`) and vertical position (`yOffSet`) within the rectangle. The Animation is of Wave style until progress is not 100% else it will be solid background.
     3. **Path Creation:**
     - **Starting Point:** Sets the starting point on the top of the wave based on `yOffSet` and the initial sine value.
     - **Wave Segments:** Iterates through angles to create line segments that represent the wave's shape.
     - **Connecting Lines:** Connects the last wave point to the bottom-right corner and then to the bottom-left corner, completing the shape.
     - **Closing the Path:** Closes the path by connecting the bottom-left corner back to the starting point.
     
     - Note: This function relies on external variables `progress` and `offset`.
     */
    func path(in rect: CGRect) -> Path {
        var wavePath = Path()
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (progress/100)
        
        let waveHeight = progress == 100 ? 0 : 0.03 * rect.height
        let yOffSet = CGFloat(1 - newPercent) *
        (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360 + 10)
        
        wavePath.move(to: CGPoint(x: 0, y: yOffSet + waveHeight *
                                  CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            wavePath.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        wavePath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        wavePath.addLine(to: CGPoint(x: 0, y: rect.height))
        wavePath.closeSubpath()
        return wavePath
    }
}
