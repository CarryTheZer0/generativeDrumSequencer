//
//  CanvasNodeView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 11/11/2021.
//

import Foundation
import SwiftUI

struct CanvasNodeView : View {
    private var node: CanvasNode
    private var canvas: Canvas
    @State private var position: CGPoint
    
    private let minBounds: CGPoint
    private let maxBounds: CGPoint
    private let radius: CGFloat
    
    init(node: CanvasNode, canvas: Canvas, maxBounds: CGPoint) {
        self.node = node
        self.canvas = canvas
        
        self.minBounds = CGPoint(x: 0.0, y: 0.0)
        self.maxBounds = maxBounds
        self.position = CGPoint(x: maxBounds.x / 2, y: maxBounds.y / 2)
        self.radius = 30.0
    }
    
    var body: some View {
        Circle()
            .frame(width: self.radius)
            .position(self.position)
            .gesture(self.drag)
    }
    
    var drag : some Gesture {
        DragGesture().onChanged { value in
            self.position = CGPoint(x: value.location.x, y: value.location.y)
            self.canvas.setSelectedNode(node: self.node)
            
            clamp()
            
            self.node.setX(val: Double(self.position.x), in: Double(self.minBounds.x + self.radius)...Double(self.maxBounds.x - self.radius))
            self.node.setY(val: Double(self.maxBounds.y - self.position.y), in: Double(self.minBounds.y + self.radius)...Double(self.maxBounds.y - self.radius))
        }
    }
    
    func clamp() {
        if (self.position.x - self.radius < self.minBounds.x) { self.position.x = self.minBounds.x + self.radius }
        else if (self.position.x + self.radius > self.maxBounds.x) { self.position.x = self.maxBounds.x - self.radius }
        if (self.position.y - self.radius < self.minBounds.y) { self.position.y = self.minBounds.y + self.radius }
        else if (self.position.y + self.radius > self.maxBounds.y) { self.position.y = self.maxBounds.y - self.radius }
    }
}
