//
//  UIColor+random.swift
//  Motion
//
//  Created by Christian Menschel on 03.11.22.
//

import UIKit

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
