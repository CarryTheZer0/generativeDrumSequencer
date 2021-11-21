//
//  MetronomeControlView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 11/11/2021.
//

import Foundation
import SwiftUI

struct MetronomeControlView : View {
    private var sequencer: DrumSequencer
    
    init(sequencer: DrumSequencer) {
        self.sequencer = sequencer
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.sequencer.play()
            }) {
                ZStack {
                    Image(systemName: "play")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
            .background(Color.green)
            .cornerRadius(5.0)
            Button(action: {
                self.sequencer.stop()
            }) {
                ZStack {
                    Image(systemName: "pause")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
            .background(Color.red)
            .cornerRadius(5.0)
            Button(action: {
                self.sequencer.addTrack(filename: "Empty", measures: 8)
            }) {
                ZStack {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
            Button(action: {
                self.sequencer.sync()
            }) {
                ZStack {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
        }
        .border(Constants.text)
        .background(Constants.foreground1)
    }
}
