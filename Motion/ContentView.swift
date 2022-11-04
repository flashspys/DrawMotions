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
//            drawCirclesDepth()
//            drawAnimatedSineCurve()
//            drawSoundSineCurves()
//            drawSoundSineArcs()
            drawGravityValues()
        }.edgesIgnoringSafeArea(.all)
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
    
    func drawCirclesDepth() -> some View {
        ForEach(soundHandler.decibels, id: \.id) {decibel in
            Circle()
                .stroke(Color(red: min(1.0, 0.3/Double(decibel.value)),
                              green: min(1.0,0.3/Double(decibel.value)),
                              blue: min(1.0, 0.3/Double(decibel.value))), lineWidth: 1)
                .frame(width: screenW * Double(decibel.value),
                       height: screenH * Double(decibel.value))
        }
    }
    
    func drawAnimatedSineCurve() -> some View {
        Curve(amp: CGFloat(soundHandler.decibel.value))
            .stroke(Color(uiColor: .random()), lineWidth: 1)
            .animation(.easeInOut(duration: 1.0), value: soundHandler.decibel.value)
    }
    
    func drawSoundSineCurves() -> some View {
        ForEach(soundHandler.decibels, id: \.id) {decibel in
            ZStack {
//                Curve(amp: CGFloat(decibel.value))
//                    .stroke(Color(uiColor: .random()), lineWidth: 1)
    //                .stroke(Color(hue: 1.0, saturation: Double(decibel.value), brightness: Double(decibel.value)), lineWidth: 1)
    //                .stroke(Color(hue: Double(decibel.value), saturation: 0.5, brightness: 1.0), lineWidth: 1)
//                    .stroke(Color(uiColor: UIColor(red: 0.7/Double(decibel.value), green: 0.7/Double(decibel.value), blue: 0.7/Double(decibel.value), alpha: 1.0)), lineWidth: 1)
                Curve(amp: CGFloat(decibel.value))
                    .stroke(Color(uiColor: UIColor(red: 0.7/Double(decibel.value), green: 0.7/Double(decibel.value), blue: 0.7/Double(decibel.value), alpha: 1.0)), lineWidth: 1)
                    .rotationEffect(.degrees(20*Double(decibel.value)))
            }

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
    
    func drawGravityValues() -> some View {
        GeometryReader() { reader in
            
            let center = CGPoint(x: reader.size.width / 2, y: reader.size.height / 2)
            let maxDimension = max(reader.size.width, reader.size.height)
            var location = center
            var angle: Double = 0
            let limit = 10000
            let used = min(motionHandler.gravities.count, limit)
            let offset = motionHandler.gravities.count - used
            ForEach(0..<100) { i in
                Path() { path in
                    let start = motionHandler.gravities.count*i / 100
                    let end = motionHandler.gravities.count*(i+1) / 100
                    
                    path.move(to: location)
                    motionHandler.gravities[start..<end].forEach { value in
                        let directionToCenter = center - location
                        let lengthToCenter = (directionToCenter.length+0.1)
                        let normalizedDirectionToCenter = directionToCenter / lengthToCenter
                        let inverseDistanceFromCenter = maxDimension / (lengthToCenter + 1)
                        
                        angle = (angle + value.x).truncatingRemainder(dividingBy: Double.pi*2)
                        let direction = CGPoint(x: sin(angle), y: cos(angle))
                        
                        let cosToCenter = -normalizedDirectionToCenter * direction
                        
                        let length = value.y * inverseDistanceFromCenter * ((cosToCenter + 1.2)/1.2)
                        location += direction * length
                        path.addLine(to: location)
                    }
                }
                .stroke(Color.red, lineWidth: 5)
                .opacity(Double(i) / 100.0)
            }
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static prefix func -(left: CGPoint) -> CGPoint {
        return CGPoint(x: -left.x, y: -left.y)
    }
    
    static func +=(left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func *(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    static func *(left: CGPoint, right: CGPoint) -> Double {
        return left.x * right.x + left.y * right.y
    }
    
    static func /(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    var length: CGFloat {
        return sqrt(self * self)
    }
}

