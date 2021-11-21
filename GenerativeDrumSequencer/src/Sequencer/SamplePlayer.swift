//
//  samplePlayer.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 07/11/2021.
//

import Foundation
import AudioKit

class SamplePlayer
{
    private let mixer: AKMixer
    private var samplesDict: [String: SampleBank]

    init() {
        self.mixer = AKMixer()
        self.samplesDict = [String: SampleBank]()
        
        AKManager.output = mixer
        try!AKManager.start()
        
        let url = Bundle.main.url(forResource: "samples", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let samplesJSON: SamplesJSON = try! JSONDecoder().decode(SamplesJSON.self, from: jsonData)
        
        for file in samplesJSON.samples {
            addSample(filename: file)
        }
    }
    
    public func addSample(filename: String) {
        if (samplesDict.keys.contains(filename)) { return }  // dont add duplicates
        let bank = SampleBank(filename: filename, mixer: self.mixer)
        self.samplesDict[filename] = bank
    }
    
    public func playSample(name: String, volume: Double) {
        let bank = self.samplesDict[name]
        if (bank != nil) {
            bank!.playSample(volume: volume)
        }
    }
    
    public func getSampleNames() -> [String] {
        var keys: [String] = [String]()
        for key in self.samplesDict.keys { keys.append(key) }
        return keys
    }
}

struct SamplesJSON : Decodable {
    let defaults: [String]
    let samples: [String]
}
