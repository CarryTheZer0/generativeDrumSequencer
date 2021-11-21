//
//  AudioSliderView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 11/11/2021.
//

import Foundation
import SwiftUI

struct AudioSliderView : View {
    @State private var offset: CGFloat
    @State private var prevOffset: CGFloat
    @State private var isChanging: Bool
    
    @Binding var enabled: Bool
    @Binding var value: Double
    
    private let isHorizontal: Bool
    private let barColor: Color
    private let knobColor: Color
    private let disabledColor: Color
    
    private var range: ClosedRange<Double>
    
    init(value: Binding<Double>, enabled: Binding<Bool>, in range: ClosedRange<Double>, isHorizontal: Bool = false) {
        self.isHorizontal = isHorizontal
        self._value = value
        self.range = range
        self.prevOffset = 0.0
        self.isChanging = false
        self.offset = 0.0
        self._enabled = enabled
        
        self.barColor = Color(red: 0.7, green: 0.7, blue: 0.7)
        self.knobColor = Color(red: 0.4, green: 0.4, blue: 0.4)
        self.disabledColor = Color(red: 0.8, green: 0.8, blue: 0.8)
    }
    
    var body : some View {
        GeometryReader { geometry in
            let geometryLimit = self.isHorizontal ? geometry.size.width : geometry.size.height
            ZStack {
                Rectangle()
                    .frame(
                        width: self.isHorizontal ? geometry.size.width : 3,
                        height: self.isHorizontal ? 3 : geometry.size.height
                    )
                    .foregroundColor(self.enabled ? self.barColor : self.disabledColor)
                RoundedRectangle(cornerRadius: 3.0)
                    .frame(
                        width: self.isHorizontal ? 15 : 40,
                        height: self.isHorizontal ? 40 : 15
                    )
                    .foregroundColor(self.enabled ? self.knobColor : self.disabledColor)
                    .offset(
                        x: self.isHorizontal ? map(value: self.value, from: self.range, to: 0...Double(geometryLimit)) - (geometry.size.width / 2) : 0,
                        y: self.isHorizontal ? 0 : -map(value: self.value, from: self.range, to: 0...Double(geometryLimit)) + (geometry.size.height / 2)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                if(!self.isChanging) {
                                    self.prevOffset = map(value: self.value, from: self.range, to: 0...Double(geometryLimit))
                                    self.isChanging = true
                                }
                          
                                self.offset = self.prevOffset + (self.isHorizontal ? value.translation.width : -value.translation.height)
                                
                                clamp(limit: geometryLimit)
                                self.value = Double(map(value: Double(self.offset), from: 0...Double(geometryLimit), to: self.range))
                            })
                            .onEnded({ _ in
                                self.isChanging = false
                            })
                    )
            }
        }
    }
    
    private func clamp(limit: CGFloat) {
        if (self.offset > limit) { self.offset = limit }
        if (self.offset < 0) { self.offset = 0 }
    }
    
    private func map(value: Double, from: ClosedRange<Double>, to: ClosedRange<Double>) -> CGFloat {
        return CGFloat(((value - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound)
    }
}
