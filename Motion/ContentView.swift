//
//  ContentView.swift
//  Motion
//
//  Created by Christian Menschel on 31.10.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var motionHandler = MotionHandler()
    
    var rotations: [MotionHandler.Values] {
        motionHandler.rotations
    }
    var lastRotation: MotionHandler.Values {
        motionHandler.rotation
    }
    var screenW: CGFloat {
        UIScreen.main.bounds.width
    }
    var screenH: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var body: some View {
        ZStack {
            
            //            drawAcceleration()
            //            drawGravity()
            //            drawRotation()
//            drawLines()
            drawCircles()
        }.padding()
    }
    
    func drawCircles() -> some View {
        ForEach(rotations, id: \.x) {rotation in
            Circle()
                .stroke(Color(red: 1.0 * (fabs(rotation.x) * 10),
                              green: 1.0 * (fabs(rotation.y) * 10),
                              blue: 1.0 * (fabs(rotation.z) * 10)), lineWidth: 1)
                .frame(width: screenW * fabs(rotation.x),
                       height: screenH * fabs(rotation.y))
        }
    }
    
    func drawLines() -> some View {
        Path() {path in
            path.drawLine(rotations, screenW, screenH)
        }.stroke(Color.red, lineWidth: 1)
    }
    
    func drawAcceleration() -> some View {
        Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.drawCurves(motionHandler.accelerations)
        }
        .stroke(Color.red, lineWidth: 5)
    }
    
    func drawGravity() -> some View {
        Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.drawCurves(motionHandler.gravities)
        }
        .stroke(Color.green, lineWidth: 5)
    }
    
    func drawRotation() -> some View {
        Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.drawCurves(motionHandler.rotations)
        }
        .stroke(Color.purple, lineWidth: 5)
    }
}

extension Path {
    static let offset = CGFloat(100)
    mutating func drawCurves(_ values: [MotionHandler.Values]) {
        addLine(to: CGPoint(x: 100, y: 10))
        values.forEach { value in
            addQuadCurve(to: CGPoint(x: fabs(value.x) * UIScreen.main.bounds.width,
                                     y: fabs(value.y) * UIScreen.main.bounds.height),
                         control: CGPoint(x: (value.x * UIScreen.main.bounds.width) * 0.9,
                                          y: (fabs(value.y) * UIScreen.main.bounds.height) * 0.9))
        }
    }
    
    mutating func drawLine(_ values: [MotionHandler.Values],
                           _ width: CGFloat,
                           _ height: CGFloat) {
        values.forEach { value in
            move(to: CGPoint(x: 0, y: 0 ))
            addLine(to: CGPoint(x: width * fabs(value.x), y: height * fabs(value.y)))
        }
    }
}

struct Line: Shape {
    var start, end: CGPoint
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(start.animatableData, end.animatableData) }
        set { (start.animatableData, end.animatableData) = (newValue.first, newValue.second) }
    }
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
