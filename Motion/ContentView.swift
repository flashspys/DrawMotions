//
//  ContentView.swift
//  Motion
//
//  Created by Christian Menschel on 31.10.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var motionHandler = MotionHandler()
    @StateObject var soundHandler = SoundHandler()
    
    var rotations: [MotionHandler.Values] {
        motionHandler.rotations
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
//            drawCircles()
//            drawSoundCircles()
//            drawAnimatedSineCurve()
            drawSoundSineCurves()
//            drawSoundSineArcs()
        }
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
    
    func drawAnimatedSineCurve() -> some View {
        Curve(amp: CGFloat(soundHandler.decibel.value))
            .stroke(Color(uiColor: .random()), lineWidth: 1)
            .animation(.easeInOut(duration: 1.0), value: soundHandler.decibel.value)
    }
    
    func drawSoundSineCurves() -> some View {
        ForEach(soundHandler.decibels, id: \.id) {decibel in
            Curve(amp: CGFloat(decibel.value))
//                .stroke(Color(uiColor: .random()), lineWidth: 1)
//                .stroke(Color(hue: 1.0, saturation: Double(decibel.value), brightness: Double(decibel.value)), lineWidth: 1)
                .stroke(Color(hue: Double(decibel.value), saturation: 0.5, brightness: 1.0), lineWidth: 1)

        }
    }
    
    func drawSoundSineArcs() -> some View {
        ForEach(soundHandler.decibels, id: \.id) {decibel in
            Arc(start: CGPoint(x: motionHandler.gyro.x, y: motionHandler.gyro.y),
                radius: CGFloat(decibel.value)/2)
                .stroke(Color(uiColor: .random()), lineWidth: 1)
//            Circle()
//                .stroke(Color(red: 1.0 * Double(decibel.value),
//                              green: 1.0 * Double(decibel.value),
//                              blue: 1.0 * Double(decibel.value)), lineWidth: 1)
//                .frame(width: screenW * CGFloat(decibel.value),
//                       height: screenH * CGFloat(decibel.value))
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

struct Curve: Shape {
    var amp: CGFloat
    var animatableData: CGFloat {
        get { amp }
        set { amp = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: 0, y: rect.midY)
        path.move(to: start)
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                      control1: CGPoint(x: rect.midX, y: rect.midY - (rect.height * amp)),
                      control2: CGPoint(x: rect.midX, y: rect.midY + (rect.height * amp)))
        return path
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

struct Arc: Shape {
    var start: CGPoint
    var radius: CGFloat
//    var fill: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX - (rect.midX * start.x), y: rect.midY - (rect.midY * start.y)),
                    radius: rect.size.width * radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIColor {
    static func random() -> UIColor {
//        return UIColor(
//           red:   .random(),
//           green: .random(),
//           blue:  .random(),
//           alpha: 1.0
//        )
        UIColor(hue: .random(), saturation: 0.8, brightness: 1.0, alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
