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
    
    init(sequencer: DrumSequencer, canvas: Canvas) {
        self.textMargin = 15.0
        self.canvas = canvas
        self.sequencer = sequencer
        self.xLabel = "X"
        self.yLabel = "Y"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(self.yLabel) --->")
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
                Text("\(self.xLabel) --->")
                    .frame(height: self.textMargin)
            }
        }
    }
}
