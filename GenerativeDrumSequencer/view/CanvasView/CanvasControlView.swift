//
//  CanvasParameterView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 15/11/2021.
//

import Foundation
import SwiftUI

struct CanvasControlView : View {
    @ObservedObject private var canvas: Canvas
    @State private var showDropDown: Bool
    
    init(canvas: Canvas) {
        self.canvas = canvas
        self.showDropDown = false
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button("Add", action: { self.canvas.addNode() } )
                if (self.canvas.getSelectedNode() != nil) {
                    Text("Rules:")
                    ScrollView {
                        VStack {
                            ZStack {
                                Capsule()
                                    .fill(Constants.foreground3)
                                    .frame(width: 100, height: 20)
                                HStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Constants.text)
                                        .frame(width: 10, height: 10)
                                    Text("Add Rule")
                                }
                            }
                            .popover(isPresented: self.$showDropDown, arrowEdge: Edge.leading, content: {
                                RuleSelectorView(isActive: self.$showDropDown, canvas: self.canvas)
                            })
                            .gesture(TapGesture()
                                        .onEnded({ self.showDropDown = true })
                            )
                            ForEach(self.canvas.getSelectedNode()!.getRules()) { rule in
                                CanvasRuleView(rule: rule)
                            }
                        }
                    }
                }
                else {
                    Text("No node selected")
                        .frame(width: 280)
                }
            }
        }
        .border(Constants.text)
        .background(Constants.foreground1)
    }
}

struct RuleSelectorView : View {
    @Binding var isActive: Bool
    private var canvas: Canvas
    
    init(isActive: Binding<Bool>, canvas: Canvas) {
        self.canvas = canvas
        self._isActive = isActive
    }
    
    var body: some View {
        VStack {
            Button("Minimum Volume", action: {
                let new = RuleVolMin(sequencer: self.canvas.getSequencer(), parent: self.canvas.getSelectedNode()!, isX: false)
                self.canvas.getSelectedNode()!.addRule(rule: new)
                self.isActive = false
            })
            .padding()
            .foregroundColor(Constants.text)
            Divider()
            Button("Maximum Volume", action: {
                let new = RuleVolMin(sequencer: self.canvas.getSequencer(), parent: self.canvas.getSelectedNode()!, isX: false)
                self.canvas.getSelectedNode()!.addRule(rule: new)
                self.isActive = false
            })
            .padding()
            .foregroundColor(Constants.text)
            Divider()
            Button("Hit Chance", action: {
                let new = RuleHitChance(sequencer: self.canvas.getSequencer(), parent: self.canvas.getSelectedNode()!, isX: false)
                self.canvas.getSelectedNode()!.addRule(rule: new)
                self.isActive = false
            })
            .padding()
            .foregroundColor(Constants.text)
        }
        .background(Constants.foreground2)
    }
}
