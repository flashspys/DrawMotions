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
    
    struct Values {
        let x: Double
        let y: Double
        let z: Double
    }
    
    static let updateInterval = 5.0

    @Published var acceleration: Values = .init(x: 0, y: 0, z: 0)
    @Published var accelerations = [Values]()
    @Published var rotation: Values = .init(x: 0, y: 0, z: 0)
    @Published var rotations = [Values]()
    @Published var magneticField: Values = .init(x: 0, y: 0, z: 0)
    @Published var magneticFields = [Values]()
    @Published var gravity: Values = .init(x: 0, y: 0, z: 0)
    @Published var gravities = [Values]()
    
    init() {
        manager.accelerometerUpdateInterval = Self.updateInterval
        manager.gyroUpdateInterval = Self.updateInterval
        manager.magnetometerUpdateInterval = Self.updateInterval

        manager.startDeviceMotionUpdates(to: .main) { motion, _ in
            guard let motion = motion else { return }
            self.readAcceleration(motion.userAcceleration)
            self.readMagneticField(motion.magneticField)
            self.readGravity(motion.gravity)
            self.readRotation(motion.rotationRate)
        }
    }

    private func readAcceleration( _ values: CMAcceleration) {
        let acceleration = Values(x: values.x, y: values.y, z: values.z)
       // accelerations.append(acceleration)
        self.acceleration = acceleration
    }
    
    private func readMagneticField(_ values: CMCalibratedMagneticField) {
        let magneticField = Values(x: values.field.x, y: values.field.x, z: values.field.z)
      //  magneticFields.append(magneticField)
        self.magneticField = magneticField
    }
    
    private func readGravity( _ values: CMAcceleration) {
        let gravity = Values(x: values.x, y: values.y, z: values.z)
       // gravities.append(gravity)
        self.gravity = gravity
    }
    
    private func readRotation(_ values: CMRotationRate) {
        let rotation = Values(x: values.x, y: values.y, z: values.z)
        rotations.append(rotation)
        self.rotation = rotation
    }
}
