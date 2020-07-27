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
    
    var body: some View {
        getSinWave()
            .stroke(lineWidth: 2)
    }
    
    func getSinWave(baseline: CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: baseline))
            path.addCurve(
                to: CGPoint(x: universalSize.width, y: baseline),
                control1: CGPoint(x: universalSize.width * 0.25, y: 150 + baseline),
                control2: CGPoint(x: universalSize.width * 0.75, y: -150 + baseline))
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
