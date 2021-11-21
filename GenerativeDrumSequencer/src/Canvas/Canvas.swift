//
//  Canvas.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 15/11/2021.
//

import Foundation

class Canvas : ObservableObject {
    private var nodes: [CanvasNode]
    private var selectedNode: CanvasNode?
    private var sequencer: DrumSequencer
    
    // singleton class
    static let shared = Canvas()
    
    private init() {
        self.nodes = [CanvasNode]()
        self.selectedNode = nil
        self.sequencer = DrumSequencer.shared
    }
    
    func updateUI() {
        self.objectWillChange.send()
    }
    
    func addNode() {
        self.nodes.append(CanvasNode(sequencer: self.sequencer))
        self.objectWillChange.send()
    }
    
    func onTrackRemoved(trackIndex: Int) {
        for node in self.nodes {
            node.onTrackRemoved(trackIndex: trackIndex)
        }
    }
    
    func getSequencer() -> DrumSequencer {
        return self.sequencer
    }
    
    func getSelectedNode() -> CanvasNode? {
        return self.selectedNode
    }
    
    func getNodes() -> [CanvasNode] {
        return self.nodes
    }
    
    func setSelectedNode(node: CanvasNode) {
        self.objectWillChange.send()
        self.selectedNode = node
    }
}
