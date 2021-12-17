//
//  InfoView.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 08/12/2021.
//

import Foundation
import SwiftUI

struct InfoView : View {
    @State var showDropDown: Bool
    let contents: String
    let width: CGFloat
    
    init(filename: String, width: CGFloat) {
        self.showDropDown = false
        self.width = width
        let  filepath = Bundle.main.path(forResource: filename, ofType: "txt")
        do {
            self.contents = try String(contentsOfFile: filepath!)
        } catch {
            fatalError("Info text file not found")
        }
    }
    
    var body: some View {
        ZStack {
            Image(systemName: "info.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Constants.text)
                .frame(width: 20, height: 20)
                .padding(5)
        }
        .popover(isPresented: self.$showDropDown, content: {
            Text(self.contents)
                .padding()
                .frame(width: self.width)
        })
        .gesture(TapGesture()
                    .onEnded({ self.showDropDown = true })
        )
    }
}

struct InfoPopoverView : View {
    var body: some View {
        ZStack {
            
        }
    }
}
