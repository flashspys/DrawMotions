//
//  SoundHandler.swift
//  Motion
//
//  Created by Christian Menschel on 31.10.22.
//

import Foundation
import AVFoundation

class SoundHandler: ObservableObject {
    
    struct Decibel: Identifiable {
        let id = UUID()
        let value: Float
    }
    
    var decibelLevelTimer: Timer!
    var audioRecorder: AVAudioRecorder?
    @Published var decibel: Decibel = .init(value: 0.0)
    @Published var decibels = [Decibel]()
    
    init() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { result in
                guard result else { return }
            }
        } catch {
            print("Failed to set up recording session")
        }
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("sound.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            self.audioRecorder = audioRecorder
            audioRecorder.isMeteringEnabled = true
            decibelLevelTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) {[weak self] timer in
                guard let self = self else { return }
                audioRecorder.updateMeters()
                let value = (100 + audioRecorder.peakPower(forChannel: 0))/100
                self.decibel = Decibel(value: value)
                self.decibels.append(self.decibel)
            }
        } catch {
            print("Could not start recording")
        }
    }
}
