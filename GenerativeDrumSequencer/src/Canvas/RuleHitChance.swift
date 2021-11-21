//
//  RuleHitChance.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 12/11/2021.
//

import Foundation

class RuleHitChance : CanvasRule {
    override init(sequencer: DrumSequencer, parent: CanvasNode, isX: Bool) {
        super.init(sequencer: sequencer, parent: parent, isX: isX)
        super.limits = 0...100
        super.range = super.limits
    }
    
    override func setNewValue(val: Double, in inRange: ClosedRange<Double>) {
        let newVal = super.map(value: val, from: inRange, to: range!)
        
        for pair in super.getIndices() {
            super.getSequencer().setHitChance(trackIndex: pair.0, unitIndex: pair.1, chance: Int(newVal))
        }
    }
}
