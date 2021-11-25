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
        VStack(spacing: 0) {
            Text(self.rule.getName())
                .padding(.top, 5)
                .padding(.bottom, 5)
                .frame(alignment: .leading)
            HStack(spacing: 0) {
                Rectangle()
                    .onTapGesture {
                        if (self.rule.getSequencer().getSelectionActive()) {
                            if (!self.rule.containsCurrentIndexPair()) {
                                self.rule.addIndexPair()
                            } else {
                                self.rule.removeIndexPair()
                            }
                        }
                    }
                    .frame(width: 20, height: 20)
                    .foregroundColor(self.rule.containsCurrentIndexPair() && self.rule.getSequencer().getSelectionActive() ?
                                    Constants.highlight : Constants.foreground3)
                    .border(Constants.text)
                Spacer().frame(width: 10)
                Button(action: { self.rule.setIsX(isX: true) }) {
                    ZStack {
                        Text("X")
                            .foregroundColor(Constants.text)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                    }
                }
                .frame(height: 20)
                .background(self.rule.isXRule() ? Constants.highlight : Constants.foreground3)
                .border(Constants.text)
                Button(action: {
                    self.rule.setIsX(isX: false)
                }) {
                    ZStack {
                        Text("Y")
                            .foregroundColor(Constants.text)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                    }
                }
                .background(self.rule.isXRule() ? Constants.foreground3 : Constants.highlight)
                .border(Constants.text)
                .frame(height: 20)
                Button(action: {
                    self.rule.setInverted(inverted: self.rule.getInverted() ? false : true)
                }) {
                    ZStack {
                        Text("Inverted")
                            .foregroundColor(Constants.text)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                    }
                }
                .background(self.rule.getInverted() ? Constants.highlight : Constants.foreground3)
                .border(Constants.text)
                .frame(height: 20)
                Spacer().frame(width: 10)
                Button(action: {
                    self.rule.delete()
                }) {
                    ZStack {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Constants.text)
                            .frame(width: 20, height: 20)
                            .padding(5)
                    }
                    .background(Constants.foreground3)
                    .cornerRadius(3.0)
                }
            }
            Text("Lower Limit")
                .padding(.top, 15)
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
            .padding(.leading, 15)
            .padding(.trailing, 15)
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
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .padding(.bottom, 20)
        }
        .background(Constants.foreground2)
        .padding()
    }
}
