//
//  SampleBank.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 08/11/2021.
//

import Foundation
import AudioKit

class SampleBank {
    private let maxSampleCount: Int
    private var sampleArray: [AKAudioPlayer]
    
    init(maxSamples: Int = 16, filename: String, mixer: AKMixer) {
        self.maxSampleCount = maxSamples
        self.sampleArray = []
        for _ in 0..<self.maxSampleCount {
            let sample = try! AKAudioFile(readFileName: filename, baseDir: .resources)
            let player = try! AKAudioPlayer(file: sample)
            self.sampleArray.append(player)
            mixer.connect(input: player)
        }
    }
    
    func playSample(volume: Double) {
        for sample in self.sampleArray {
            if (sample.isStarted) { continue }
            sample.volume = volume
            sample.play()
            break
        }
    }
}
