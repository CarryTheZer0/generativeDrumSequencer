//
//  CanvasNode.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 15/11/2021.
//

import Foundation

class CanvasNode : Identifiable {
    private var rules: [CanvasRule]
    var id: UUID
    private var xLabel: String
    private var yLabel: String
    
    init(sequencer: DrumSequencer) {
        self.id = UUID()
        self.rules = [CanvasRule]()
        self.xLabel = "X"
        self.yLabel = "Y"
        
        let xRule = RuleVolMin(sequencer: sequencer, parent: self, isX: true)
        xRule.addIndexPair()
        
        let yRule = RuleHitChance(sequencer: sequencer, parent: self, isX: false)
        yRule.addIndexPair()

        
        self.rules.append(xRule)
        self.rules.append(yRule)
    }
    
    func addRule(rule: CanvasRule) {
        self.rules.append(rule)
        Canvas.shared.updateUI()
    }
    
    func deleteRule(id: UUID) {
        self.rules.removeAll(where: { $0.id == id } )
        Canvas.shared.updateUI()
    }
    
    func onTrackRemoved(trackIndex: Int) {
        for rule in self.rules {
            rule.onTrackRemoved(trackIndex: trackIndex)
        }
    }
    
    func updateUI(){
        for rule in self.rules {
            rule.updateUI()
        }
    }
    
    func setX(val: Double, in inRange: ClosedRange<Double>) {
        for rule in self.rules {
            if (rule.isXRule()) {
                rule.setNewValue(val: val, in: inRange)
            }
        }
    }
    
    func setY(val: Double, in inRange: ClosedRange<Double>) {
        for rule in self.rules {
            if (!rule.isXRule()) {
                rule.setNewValue(val: val, in: inRange)
            }
        }
    }
    
    func getXLabel() -> String {
        return self.xLabel
    }
    
    func getYLabel() -> String {
        return self.yLabel
    }
    
    func getRules() -> [CanvasRule] {
        return rules
    }
}
