//
//  Shapes.swift
//  Motion
//
//  Created by Christian Menschel on 03.11.22.
//

import SwiftUI

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
