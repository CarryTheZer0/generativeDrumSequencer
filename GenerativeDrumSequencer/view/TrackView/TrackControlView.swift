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
    
    init(sequencer: DrumSequencer) {
        self.sequencer = sequencer
        self.active = false
    }
    
    var body: some View {
        VStack {
            Button("Enabled", action: {
                self.sequencer.toggleUnit()
            })
            .padding()
            HStack {
                AudioSliderView(value: Binding(get: {
                        Double(self.sequencer.getHitChance())
                    }, set: { (newVal) in
                        self.sequencer.setHitChance(chance: Int(newVal))
                    }),
                    enabled: Binding(get: { self.sequencer.getSelectionActive()}, set: { _ in } ),
                    in: 1.0...100.0
                )
                .padding()
                AudioSliderView(value: Binding(get: {
                        self.sequencer.getVolumeMin()
                    }, set: { (newVal) in
                        self.sequencer.setVolumeMin(volume: newVal)
                    }),
                    enabled: Binding(get: { self.sequencer.getSelectionActive()}, set: { _ in } ),
                    in: 0.0...Constants.maxVol
                )
                .padding()
                AudioSliderView(value: Binding(get: {
                        self.sequencer.getVolumeMax()
                    }, set: { (newVal) in
                        self.sequencer.setVolumeMax(volume: newVal)
                    }),
                    enabled: Binding(get: { self.sequencer.getSelectionActive()}, set: { _ in } ),
                    in: 0.0...Constants.maxVol
                )
                .padding()
            }
            .background(Constants.foreground2)
        }
        .border(Constants.text)
        .background(Constants.foreground1)
    }
}
