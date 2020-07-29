//
//  Animation.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/27/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI

struct WaveAnimation: View {
    let universalSize = UIScreen.main.bounds
    
    @State var isAnimated = false
    var body: some View {
        ZStack {
            getSinWave(interval: universalSize.width, amplitude: 200, baseline: 100 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1 * universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 10)
                    .repeatForever(autoreverses: false))
            getSinWave(interval: universalSize.width * 1.5, amplitude: 150, baseline: 140 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1 * 1.5 * universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 6)
                    .repeatForever(autoreverses: false)
            )
            getSinWave(interval: universalSize.width * 3, amplitude: 100, baseline: 180 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1 * 3 * universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false)
            )
            
        }.onAppear() {
            self.isAnimated = true
        }
    }
    func getSinWave(interval: CGFloat, amplitude: CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: baseline))
            path.addCurve(
                to: CGPoint(x: interval, y: baseline),
                control1: CGPoint(x: interval * 0.35, y: 150 + baseline),
                control2: CGPoint(x: interval * 0.65, y: -150 + baseline))
            path.addCurve(
                to: CGPoint(x: 2 * interval, y: baseline),
                control1: CGPoint(x: interval * 1.35, y: 150 + baseline),
                control2: CGPoint(x: interval * 1.65, y: -150 + baseline))
            path.addLine(to: CGPoint(x: 2 * interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
        }
 
    }
}
