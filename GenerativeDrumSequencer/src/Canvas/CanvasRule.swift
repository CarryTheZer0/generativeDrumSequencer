//
//  CanvasRule.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 12/11/2021.
//

import Foundation

class CanvasRule : Identifiable, ObservableObject {
    var id: UUID
    var range: ClosedRange<Double>?
    var limits: ClosedRange<Double>?
    private var sequencer: DrumSequencer
    private var indices: [(Int, Int)]  // Format: [(Track index, Unit index)]
    private var isX: Bool
    private var inverted: Bool
    private var parent: CanvasNode
    
    init(sequencer: DrumSequencer, parent: CanvasNode, isX: Bool) {
        self.id = UUID()
        self.isX = isX
        self.sequencer = sequencer
        self.indices = [(Int, Int)]()
        self.inverted = false
        self.parent = parent
    }
    
    func addIndexPair() {
        let pair = self.sequencer.getSelected()
        if (!containsCurrentIndexPair()) {
            self.indices.append(pair)
        }
        self.objectWillChange.send()
    }
    
    func containsCurrentIndexPair() -> Bool {
        let pair = self.sequencer.getSelected()
        if (self.indices.contains(where: { $0 == pair })) { return true }
        return false
    }
    
    func removeIndexPair() {
        let pair = self.sequencer.getSelected()
        self.indices.removeAll(where: { $0 == pair })
        self.objectWillChange.send()
    }
    
    func updateUI() {
        self.objectWillChange.send()
    }
    
    func delete() {
        self.parent.deleteRule(id: self.id)
    }
    
    func onTrackRemoved(trackIndex: Int) {
        var toRemove = [(Int, Int)]()
        var toAdd = [(Int, Int)]()
        for pair in 0..<self.indices.count {
            if (self.indices[pair].0 == trackIndex) {
                // for the removed track, delete the index pairs
                toRemove.append(self.indices[pair])
            }
            else if (indices[pair].0 > trackIndex) {
                // for tracks to be moved down, reduce the pair's track index by one
                toRemove.append(self.indices[pair])
                toAdd.append((self.indices[pair].0 - 1, self.indices[pair].1))
            }
        }
        
        // actual list manipulation done outside of main for loop to avoid indexing errors
        for pair in toRemove {
            self.indices.removeAll(where: { $0 == pair })
        }
        for pair in toAdd {
            self.indices.append(pair)
        }
    }
    
    func setNewValue(val: Double, in inRange: ClosedRange<Double>) {
        fatalError("Virtual method. Must be overriden in subclasses.")
    }
    
    func getName() -> String {
        fatalError("Virtual method. Must be overriden in subclasses.")
    }
    
    func setLowerBound(lower: Double) {
        if (lower > self.range!.upperBound) { return }
        self.range = lower...self.range!.upperBound
    }
    
    func setUpperBound(upper: Double) {
        if (upper < self.range!.lowerBound) { return }
        self.range = self.range!.lowerBound...upper
    }
    
    func setInverted(inverted: Bool) {
        self.inverted = inverted
        self.objectWillChange.send()
    }
    
    func setIsX(isX: Bool) {
        self.isX = isX
        self.objectWillChange.send()
    }
    
    func isXRule() -> Bool {
        return self.isX
    }
    
    func getInverted() -> Bool { return self.inverted }
    
    func getIndices() -> [(Int, Int)] { return self.indices }
    
    func getSequencer() -> DrumSequencer { return self.sequencer }
    
    func getRange() -> ClosedRange<Double> { return self.range! }
    
    func getLimits() -> ClosedRange<Double> { return self.limits! }
    
    func map(value: Double, from: ClosedRange<Double>, to: ClosedRange<Double>) -> Double {
        var val: Double = ((value - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        if (self.inverted) { val = to.upperBound - val + to.lowerBound }
        return val
    }
}
