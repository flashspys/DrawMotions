//
//  MotionHandler.swift
//  Motion
//
//  Created by Christian Menschel on 31.10.22.
//

import Foundation
import CoreMotion

class MotionHandler: ObservableObject {
    let manager = CMMotionManager()
    
    struct Acceleration {
        let x: Double
        let y: Double
        let z: Double
    }
    
    struct Rotation {
        let x: Double
        let y: Double
        let z: Double
    }
    
    struct MagneticField {
        let x: Double
        let y: Double
        let z: Double
    }
    
    struct Gravity {
        let x: Double
        let y: Double
        let z: Double
    }

    @Published var acceleration: Acceleration?
    @Published var rotation: Rotation?
    @Published var magneticField: MagneticField?
    @Published var gravity: Gravity?
    
    init() {
        manager.accelerometerUpdateInterval = 0.1
        manager.gyroUpdateInterval = 0.1
        manager.magnetometerUpdateInterval = 0.1

        manager.startDeviceMotionUpdates(to: .main) { motion, _ in
            guard let motion = motion else { return }
            self.readAcceleration(motion.userAcceleration)
            self.readMagneticField(motion.magneticField)
            self.readGravity(motion.gravity)
            self.readRotation(motion.rotationRate)
        }
    }

    private func readAcceleration( _ values: CMAcceleration) {
        self.acceleration = Acceleration(x: values.x, y: values.y, z: values.z)
    }
    
    private func readMagneticField(_ values: CMCalibratedMagneticField) {
        self.magneticField = MagneticField(x: values.field.x, y: values.field.x, z: values.field.z)
    }
    
    private func readGravity( _ values: CMAcceleration) {
        self.gravity = Gravity(x: values.x, y: values.y, z: values.z)
    }
    
    private func readRotation(_ values: CMRotationRate) {
        self.rotation = Rotation(x: values.x, y: values.y, z: values.z)
    }
}
