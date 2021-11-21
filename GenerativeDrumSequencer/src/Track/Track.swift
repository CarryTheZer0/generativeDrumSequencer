//
//  Track.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 07/11/2021.
//

import Foundation

class Track : ObservableObject
{
    @Published var track: [TrackUnit]
    
    private let parent: DrumSequencer
    private let player: SamplePlayer
    private var filename: String
    private var current: Int
    private var trackIndex: Int
    
    init(parent: DrumSequencer, index: Int, player: SamplePlayer, name: String, measures: Int = 16) {
        self.filename = name
        self.current = 0
        self.player = player
        self.trackIndex = index
        self.parent = parent
        track = []
        
        for _ in 1...measures {
            track.append(TrackUnit(enabled: false, hitChance: 100, volumeMin: 0.3, volumeMax: 1.0))
        }
    }
    
    func step() {
        let volume = Double.random(in: self.track[self.current].volumeMin...self.track[self.current].volumeMax)
        
        // Information published to the view must be done so from the main thread
        DispatchQueue.main.async {
            if (self.track[self.current].enabled && Int.random(in: 0..<100) < self.track[self.current].hitChance) {
                self.player.playSample(name: self.filename, volume: volume)
            }
            
            if (self.current > 0) {
                self.track[self.current - 1].highlighted = false
            } else {
                self.track[self.track.count - 1].highlighted = false
            }
            self.track[self.current].highlighted = true
            self.current += 1
            if (self.current >= self.track.count) {
                self.current = 0
            }
        }
    }
    
    func increment() {
        self.track.append(TrackUnit(enabled: true, hitChance: 100, volumeMin: 1.0, volumeMax: 1.0))
    }
    
    func decrement() {
        // dont decrease to 0
        if (self.track.count == 1) { return }
        if (self.current >= self.track.count - 1) { self.current = 0 }
        self.parent.deselectCurrent()
        self.track.removeLast()
    }
    
    func toggle(index: Int) {
        self.track[index].enabled.toggle()
    }
    
    func select(index: Int) {
        self.track[index].enabled = true
        self.track[index].selected = true
        self.parent.select(trackIndex: self.trackIndex, unitIndex: index)
    }
    
    func deselect(index: Int) {
        self.track[index].selected = false
    }
    
    func unhighlightAll() {
        for i in 0..<self.getLength() {
            self.track[i].highlighted = false
        }
    }
    
    func delete() {
        self.parent.removeTrack(index: self.trackIndex)
    }
    
    func getName() -> String {
        return self.filename
    }
    
    func getIndex() -> Int {
        return self.trackIndex
    }
    
    func getLength() -> Int {
        return self.track.count
    }
    
    func getUnit(index: Int) -> TrackUnit {
        return self.track[index]
    }
    
    func getCurrent() -> Int {
        return self.current
    }
    
    func getVolumeMin(index: Int) -> Double {
        return self.track[index].volumeMin
    }
    
    func getVolumeMax(index: Int) -> Double {
        return self.track[index].volumeMax
    }
    
    func getHitChance(index: Int) -> Int {
        return self.track[index].hitChance
    }
    
    func getSampleNames() -> [String] {
        return self.player.getSampleNames()
    }
    
    func setName(name: String) {
        self.filename = name
        self.objectWillChange.send()
    }
    
    func decrementIndex() {
        self.trackIndex -= 1
    }
    
    func setVolumeMin(index: Int, volume: Double) {
        if (self.track[index].volumeMax < volume) {
            self.track[index].volumeMax = volume
        }
        self.track[index].volumeMin = volume
    }
    
    func setVolumeMax(index: Int, volume: Double) {
        if (self.track[index].volumeMin > volume) {
            self.track[index].volumeMin = volume
        }
        self.track[index].volumeMax = volume
    }
    
    func setHitChance(index: Int, chance: Int) {
        self.track[index].hitChance = chance
    }
    
    func setCurrent(c: Int, reselect: Bool = false) {
        self.unhighlightAll()
        self.current = c < self.track.count ? c : self.track.count - 1
        if (reselect) {
            self.track[self.current].highlighted = true
        }
    }

}

struct TrackUnit : Hashable
{
    var enabled: Bool
    var selected: Bool = false
    var highlighted: Bool = false
    var hitChance: Int
    var volumeMin: Double
    var volumeMax: Double
}
