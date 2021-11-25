//
//  RuleVolMax.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 12/11/2021.
//

import Foundation

class RuleVolMax : CanvasRule {
    override init(sequencer: DrumSequencer, parent: CanvasNode, isX: Bool) {
        super.init(sequencer: sequencer, parent: parent, isX: isX)
        super.limits = 0.0...Constants.maxVol
        super.range = super.limits
    }
    
    override func setNewValue(val: Double, in inRange: ClosedRange<Double>) {
        let newVal = super.map(value: val, from: inRange, to: range!)
        
        for pair in super.getIndices() {
            super.getSequencer().setVolumeMax(trackIndex: pair.0, unitIndex: pair.1, volume: newVal)
        }
    }
    
    override func getName() -> String {
        return "Maximum Volume:"
    }
}
