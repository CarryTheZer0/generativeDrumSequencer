//
//  TrackUnitParametersView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 09/11/2021.
//

import SwiftUI

struct TrackControlView : View {
    
    @ObservedObject var sequencer: DrumSequencer
    @State private var active: Bool
    
    init() {
        self.sequencer = DrumSequencer.shared
        self.active = false
    }
    
    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    self.sequencer.toggleUnit()
                }) {
                    ZStack {
                        Text("Enabled")
                            .foregroundColor(Constants.text)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                        
                    }
                }
                .background(self.sequencer.getEnabled() ? Constants.highlight : Constants.foreground3)
                .border(Constants.text)
                .frame(height: 20)
                .padding(.top, 20)
                InfoView(filename: "textTest", width: 200)
                    .offset(x: 100)
            }
            HStack {
                VStack {
                    AudioSliderView(value: Binding(get: {
                            Double(self.sequencer.getHitChance())
                        }, set: { (newVal) in
                            self.sequencer.setHitChance(chance: Int(newVal))
                        }),
                        enabled: Binding(get: { self.sequencer.getSelectionActive()}, set: { _ in } ),
                        in: 1.0...100.0
                    )
                    .padding()
                    Text("Hit Chance")
                }
                VStack {
                    AudioSliderView(value: Binding(get: {
                            self.sequencer.getVolumeMin()
                        }, set: { (newVal) in
                            self.sequencer.setVolumeMin(volume: newVal)
                        }),
                        enabled: Binding(get: { self.sequencer.getSelectionActive()}, set: { _ in } ),
                        in: 0.0...Constants.maxVol
                    )
                    .padding()
                    Text("Min. Volume")
                }
                    VStack {
                    AudioSliderView(value: Binding(get: {
                            self.sequencer.getVolumeMax()
                        }, set: { (newVal) in
                            self.sequencer.setVolumeMax(volume: newVal)
                        }),
                        enabled: Binding(get: { self.sequencer.getSelectionActive()}, set: { _ in } ),
                        in: 0.0...Constants.maxVol
                    )
                    .padding()
                    Text("Max. Volume")
                }
            }
            .background(Constants.foreground2)
            .padding()
        }
        .border(Constants.text)
        .background(Constants.foreground1)
    }
}
