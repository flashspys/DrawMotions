//
//  ContentView.swift
//  Motion
//
//  Created by Christian Menschel on 31.10.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var motionHandler = MotionHandler()
    
    var body: some View {
        ZStack {
            drawAcceleration()
            drawGravity()
            drawRotation()
        }
        .padding()
    }
    
    func drawAcceleration() -> some View {
        Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.draw(motionHandler.accelerations)
        }
        .stroke(Color.red, lineWidth: 5)
    }
    
    func drawGravity() -> some View {
        Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.draw(motionHandler.gravities)
        }
        .stroke(Color.green, lineWidth: 5)
    }
    
    func drawRotation() -> some View {
        Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.draw(motionHandler.rotations)
        }
        .stroke(Color.purple, lineWidth: 5)
    }
}

extension Path {
    static let offset = CGFloat(100)
    mutating func draw(_ values: [MotionHandler.Values]) {
        addLine(to: CGPoint(x: 100, y: 10))
        values.forEach { value in
            addQuadCurve(to: CGPoint(x: value.x * UIScreen.main.bounds.width,
                                     y: value.y * UIScreen.main.bounds.height),
                         control: CGPoint(x: (value.x * UIScreen.main.bounds.width) * 0.9,
                                          y: (value.y * UIScreen.main.bounds.height) * 0.9))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
