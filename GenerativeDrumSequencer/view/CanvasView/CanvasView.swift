//
//  CanvasControlView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 11/11/2021.
//

import Foundation
import SwiftUI

struct CanvasView : View {
    private let textMargin: CGFloat
    private let sequencer: DrumSequencer
    @ObservedObject private var canvas: Canvas
    @State private var xLabel: String
    @State private var yLabel: String
    
    init() {
        self.textMargin = 15.0
        self.canvas = Canvas.shared
        self.sequencer = DrumSequencer.shared
        self.xLabel = "X"
        self.yLabel = "Y"
    }
    
    var body: some View {
        VStack {
            HStack {
                let yLabel: String = self.canvas.getSelectedNode() != nil ? self.canvas.getSelectedNode()!.getYLabel() : "Y"
                Text("\(yLabel) --->")
                    .rotationEffect(Angle(degrees: 270.0))
                    .frame(height: self.textMargin)
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .foregroundColor(Constants.pad)
                            .padding()
                            .border(Constants.text)
                        ForEach(self.canvas.getNodes()) { node in
                            CanvasNodeView(node: node, canvas: self.canvas, maxBounds: CGPoint(x: geometry.size.height, y: geometry.size.height))
                        }
                    }
                    .frame(width: geometry.size.height, height: geometry.size.height)
                }
            }
            HStack {
                Spacer()
                    .frame(width: self.textMargin, height: self.textMargin)
                let xLabel: String = self.canvas.getSelectedNode() != nil ? self.canvas.getSelectedNode()!.getXLabel() : "X"
                Text("\(xLabel) --->")
                    .frame(height: self.textMargin)
            }
        }
    }
}
