//
//  CanvasRuleView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 15/11/2021.
//

import Foundation
import SwiftUI

struct CanvasRuleView : View {
    @ObservedObject private var rule: CanvasRule
    @State private var sliderEnabled: Bool
    
    init(rule: CanvasRule) {
        self.sliderEnabled = true
        self.rule = rule
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button(action: { self.rule.setIsX(isX: true) }) {
                    ZStack {
                        Text("X")
                            .foregroundColor(Constants.text)
                            .padding(5)
                    }
                }
                .background(self.rule.isXRule() ? Constants.highlight : Constants.foreground3)
                .border(Constants.text)
                Button(action: {
                    self.rule.setIsX(isX: false)
                }) {
                    ZStack {
                        Text("Y")
                            .foregroundColor(Constants.text)
                            .padding(5)
                    }
                }
                .background(self.rule.isXRule() ? Constants.foreground3 : Constants.highlight)
                .border(Constants.text)
                Button(action: {
                    self.rule.setInverted(inverted: self.rule.getInverted() ? false : true)
                }) {
                    ZStack {
                        Text("Inverted")
                            .foregroundColor(Constants.text)
                            .padding(5)
                    }
                }
                .background(self.rule.getInverted() ? Constants.highlight : Constants.foreground3)
                .border(Constants.text)
                Button(action: {
                    self.rule.delete()
                }) {
                    ZStack {
                        Image(systemName: "minus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Constants.text)
                            .frame(width: 10, height: 10)
                            .padding(5)
                    }
                    .background(Constants.foreground3)
                    .cornerRadius(3.0)
                }
                Button(action: {
                    if (self.rule.getSequencer().getSelectionActive()) {
                        if (!self.rule.containsCurrentIndexPair()) {
                            self.rule.addIndexPair()
                        } else {
                            self.rule.removeIndexPair()
                        }
                    }
                }) {
                    ZStack {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Constants.text)
                            .frame(width: 10, height: 10)
                            .padding(5)
                    }
                    .background(self.rule.containsCurrentIndexPair() && self.rule.getSequencer().getSelectionActive() ?
                                    Constants.highlight : Constants.foreground3)
                    .cornerRadius(3.0)
                }
            }
            Text("Lower Limit")
            AudioSliderView(
                value:
                    Binding(get: { self.rule.getRange().lowerBound },
                            set: { (newVal) in
                                self.rule.setLowerBound(lower: newVal)
                            }
                    ),
                enabled: self.$sliderEnabled,
                in: self.rule.getLimits(),
                isHorizontal: true
            )
            .padding()
            Text("Upper Limit")
            AudioSliderView(
                value:
                    Binding(get: { self.rule.getRange().upperBound },
                            set: { (newVal) in
                                self.rule.setUpperBound(upper: newVal)
                            }
                    ),
                enabled: self.$sliderEnabled,
                in: self.rule.getLimits(),
                isHorizontal: true
            )
            .padding()
        }
        .background(Constants.foreground2)
        .padding()
    }
}
