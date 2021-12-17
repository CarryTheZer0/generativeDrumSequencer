//
//  ContentView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 07/11/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sequencer: DrumSequencer
    var canvas: Canvas
    
    init() {
        self.sequencer = DrumSequencer.shared
        self.canvas = Canvas.shared
        
        let url = Bundle.main.url(forResource: "samples", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let samplesJSON: SamplesJSON = try! JSONDecoder().decode(SamplesJSON.self, from: jsonData)
        
        for file in samplesJSON.defaults {
            self.sequencer.addTrack(filename: file, measures: 8)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let trackHeight: CGFloat = 300
            ZStack {
                Color(Constants.background)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        HStack {
                            VStack {
                                TrackControlView()
                                    .padding()
                                    .frame(width: 300)
                                MetronomeControlView()
                                    .padding()
                                    .frame(width: 300)
                            }
                                .frame(height: geometry.size.height - trackHeight)
                            CanvasControlView()
                                .padding()
                                .frame(width: 300, height: geometry.size.height - trackHeight)
                        }
                        CanvasView()
                    }
                    .frame(height: geometry.size.height - trackHeight)
                    ScrollView {
                        VStack(alignment: .center, spacing: 0, content: {
                            ForEach((0..<self.sequencer.getLength()), id: \.self) { trackIndex in
                                TrackView(track: self.sequencer.getTrack(index: trackIndex), canvas: self.canvas)
                            }
                        })
                    }
                    .frame(height: trackHeight)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
            ContentView()
        }
    }
}
