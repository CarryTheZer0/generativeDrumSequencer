//
//  TrackView.Swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 08/11/2021.
//

import Foundation
import SwiftUI

struct TrackView: View {
    @ObservedObject var track: Track
    @State private var showDropDown: Bool
    private var canvas: Canvas
    
    let unitHeight: CGFloat
    
    init(track: Track, canvas: Canvas) {
        self.track = track
        self.canvas = canvas
        self.unitHeight = 60.0
        self.showDropDown = false
    }
    
    var body: some View {
        HStack {
            ZStack {
                Capsule()
                    .fill(Constants.foreground3)
                    .frame(width: 100)
                Text(self.track.getName())
                    .foregroundColor(Constants.text)
                    .lineLimit(1)
                    .frame(width: 80)
            }
            .popover(isPresented: self.$showDropDown, arrowEdge: Edge.leading, content: {
                SampleSelectorView(track: self.track, isActive: self.$showDropDown)
            })
            .gesture(TapGesture()
                        .onEnded({ self.showDropDown = true })
            )
            .padding()
            Button(action: {
                self.track.delete()
                self.canvas.onTrackRemoved(trackIndex: self.track.getIndex())
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
            
            GeometryReader { geometry in
                let unitWidth = geometry.size.width / CGFloat(self.track.getLength())
                let margin = self.unitHeight * 0.2
                HStack(alignment: .center, spacing: 0, content: {
                    ForEach((0..<track.getLength()), id: \.self) { unitIndex in
                        VStack {
                            if(track.getUnit(index: unitIndex).selected) {
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Constants.foreground3)
                                        .frame(width: unitWidth, height: margin)
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .fill(Constants.foreground3)
                                            .frame(width: margin, height: self.unitHeight - (margin * 2))
                                        Spacer()
                                            .frame(width: unitWidth - (margin * 2))
                                        Rectangle()
                                            .fill(Constants.foreground3)
                                            .frame(width: margin, height: self.unitHeight - (margin * 2))
                                    }
                                    Rectangle()
                                        .fill(Constants.foreground3)
                                        .frame(width: unitWidth, height: margin)
                                }
                            }
                        }
                        .frame(width: unitWidth, height: self.unitHeight)
                        .background(self.getTrackUnitBackground(unit: self.track.getUnit(index: unitIndex)))
                        .border(Color.black)
                        .gesture(
                            TapGesture(count: 1).onEnded {
                                self.track.select(index: unitIndex)
                            }
                        )
                    }
                })
            }
            .frame(height: self.unitHeight)
            .border(Color.black)
            Button(action: {
                self.track.increment()
            }) {
                ZStack {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Constants.text)
                        .frame(width: 10, height: 10)
                        .padding(5)
                }
                .background(Constants.foreground3)
                .cornerRadius(3.0)
            }
            .padding(.leading, 5)
            .padding(.trailing, 3)
            Button(action: {
                self.track.decrement()
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
            .padding(.leading, 3)
            .padding(.trailing, 10)
        }
    }
    
    func getTrackUnitBackground(unit: TrackUnit) -> Color {
        if (unit.highlighted) { return Constants.foreground3 }
        if (!unit.enabled) { return Constants.foreground1 }
        
        // scale color based on hitChance ranging from gray (r: 0.45, g: 0.45, b: 0.45) to cyan (r: 0.2, g: 0.8, b: 0.8)
        let colorVal: Double = (Double(unit.hitChance) / 100)
        let baseGray: Double = 0.45  // the background
        return Color(red: baseGray - colorVal * 0.25, green: baseGray + colorVal * 0.35, blue: baseGray + colorVal * 0.35)
    }
}

struct SampleSelectorView : View {
    @Binding var isActive: Bool
    var track: Track
    
    init(track: Track, isActive: Binding<Bool>) {
        self.track = track
        self._isActive = isActive
    }
    
    var body : some View {
        VStack {
            ForEach(self.track.getSampleNames(), id: \.self) { filename in
                Button(filename, action: {
                    self.track.setName(name: filename)
                    self.isActive = false
                })
                .padding()
                .foregroundColor(Constants.text)
                Divider()
            }
        }
        .background(Constants.foreground2)
    }
}
