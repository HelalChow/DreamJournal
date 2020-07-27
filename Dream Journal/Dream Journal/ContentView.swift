//
//  ContentView.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/27/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let universalSize = UIScreen.main.bounds
    
    @State var isAnimated = false
    var body: some View {
        
        ZStack {
            getSinWave()
                .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1 * universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 2)
                    .repeatForever(autoreverses: false)
                )
        }.onAppear() {
            self.isAnimated = true
        }
        
    }
    
    func getSinWave(baseline: CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: baseline))
            path.addCurve(
                to: CGPoint(x: universalSize.width, y: baseline),
                control1: CGPoint(x: universalSize.width * 0.25, y: 150 + baseline),
                control2: CGPoint(x: universalSize.width * 0.75, y: -150 + baseline))
            path.addCurve(
                to: CGPoint(x: 2 * universalSize.width, y: baseline),
                control1: CGPoint(x: universalSize.width * 1.25, y: 150 + baseline),
                control2: CGPoint(x: universalSize.width * 1.75, y: -150 + baseline))
            path.addLine(to: CGPoint(x: 2 * universalSize.width, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
        }
        
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
