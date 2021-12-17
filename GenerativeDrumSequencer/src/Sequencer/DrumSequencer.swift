//
//  Sequencer.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 09/11/2021.
//

import Foundation

class DrumSequencer : ObservableObject {
    @Published var tracks: [Track]
    private let metronome: Metronome
    private var samplePlayer: SamplePlayer
    private var selectionActive: Bool
    private var selectedTrack: Int
    private var selectedUnit: Int
    private var nextIndex: Int
    private var currentRule: CanvasRule?
    
    // singleton class
    static let shared = DrumSequencer()
    
    private init() {
        self.tracks = []
        self.metronome = Metronome()
        self.samplePlayer = SamplePlayer()
        self.nextIndex = 0
        self.selectedTrack = 0
        self.selectedUnit = 0
        self.selectionActive = false
        self.currentRule = nil
    }
    
    func addTrack(filename: String, measures: Int) {
        let newTrack = Track(parent: self, index: self.nextIndex, player: self.samplePlayer, name: filename, measures: measures)
        self.nextIndex += 1
        self.tracks.append(newTrack)
        self.metronome.addSubscriber(subscriber: newTrack)
    }
    
    func removeTrack(index: Int) {
        if (self.tracks.count <= 1) { return }
        self.deselectCurrent()
        self.metronome.removeSubscriber(subscriberIndex: index)
        
        self.tracks.remove(at: index)
        for track in tracks {
            if (track.getIndex() > index) { track.decrementIndex() }
        }
        self.nextIndex -= 1
    }
    
    func toggleUnit() {
        if (self.selectionActive) {
            self.tracks[self.selectedTrack].toggle(index: self.selectedUnit)
            self.objectWillChange.send()
        }
    }
    
    func deselectCurrent() {
        if (self.selectionActive) {
            self.tracks[self.selectedTrack].deselect(index: self.selectedUnit)
        }
        self.selectionActive = false
        self.objectWillChange.send()
    }
    
    func select(trackIndex: Int, unitIndex: Int) {
        // deselect previous
        if (trackIndex != self.selectedTrack || unitIndex != self.selectedUnit) {
            deselectCurrent()
        }
        self.objectWillChange.send()
        // set new selection
        self.selectedTrack = trackIndex
        self.selectedUnit = unitIndex
        self.selectionActive = true
        Canvas.shared.updateUI()
    }
    
    func stop() {
        self.deselectCurrent()
        self.metronome.stop()
        for track in self.tracks {
            track.setCurrent(c: 0)
        }
    }
    
    func play() {
        self.deselectCurrent()
        self.metronome.play()
    }

    func sync() {
        let current = self.tracks[0].getCurrent()
        for track in self.tracks {
            track.setCurrent(c: current, reselect: true)
        }
    }
    
    func getEnabled() -> Bool {
        if (self.selectionActive) {
            return self.tracks[self.selectedTrack].getEnabled(index: self.selectedUnit)
        }
        else { return false }
    }
    
    func getSelected() -> (Int, Int) {
        return (self.selectedTrack, self.selectedUnit)
    }
    
    func getLength() -> Int {
        return self.tracks.count
    }
    
    func getTrack(index: Int) -> Track {
        return self.tracks[index]
    }
    
    func getVolumeMin() -> Double {
        if (self.selectionActive) {
            return self.tracks[self.selectedTrack].getVolumeMin(index: self.selectedUnit)
        }
        else { return 0.0 }
    }
    
    func getVolumeMax() -> Double {
        if (self.selectionActive) {
            return self.tracks[self.selectedTrack].getVolumeMax(index: self.selectedUnit)
        }
        else { return 0.0 }
    }
    
    func getHitChance() -> Int {
        if (self.selectionActive) {
            return self.tracks[self.selectedTrack].getHitChance(index: self.selectedUnit)
        }
        else { return 0 }
    }
    
    func getSelectionActive() -> Bool {
        return self.selectionActive
    }
    
    func setVolumeMin(volume: Double) {
        if (self.selectionActive) {
            self.tracks[self.selectedTrack].setVolumeMin(index: self.selectedUnit, volume: volume)
        }
        self.objectWillChange.send()
    }
    
    func setVolumeMin(trackIndex: Int, unitIndex: Int, volume: Double) {
        if (trackIndex < self.tracks.count &&
                unitIndex < self.tracks[trackIndex].getLength())
        {
            self.tracks[trackIndex].setVolumeMin(index: unitIndex, volume: volume)
            self.objectWillChange.send()
        }
    }
    
    func setVolumeMax(volume: Double) {
        if (self.selectionActive) {
            self.tracks[self.selectedTrack].setVolumeMax(index: self.selectedUnit, volume: volume)
        }
        self.objectWillChange.send()
    }
    
    func setVolumeMax(trackIndex: Int, unitIndex: Int, volume: Double) {
        if (trackIndex < self.tracks.count &&
                unitIndex < self.tracks[trackIndex].getLength())
        {
            self.tracks[trackIndex].setVolumeMax(index: unitIndex, volume: volume)
            self.objectWillChange.send()
        }
    }
    
    func setHitChance(chance: Int) {
        if (self.selectionActive) {
            self.tracks[self.selectedTrack].setHitChance(index: self.selectedUnit, chance: chance)
        }
    }
    
    func setHitChance(trackIndex: Int, unitIndex: Int, chance: Int) {
        if (trackIndex < self.tracks.count &&
                unitIndex < self.tracks[trackIndex].getLength())
        {
            self.tracks[trackIndex].setHitChance(index: unitIndex, chance: chance)
            self.objectWillChange.send()
        }
    }
}
