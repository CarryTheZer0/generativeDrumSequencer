//
//  Metronome.swift
//  GenerativeDrumSequencer
//
//  Created by Mike Persin on 08/11/2021.
//

import Foundation
import AudioKit

class Metronome{
    private var subscribers: [Track]
    private var currentTime: Double
    private var tickSpeed: Double
    private var running: Bool
    
    init() {
        self.subscribers = [Track]()
        self.currentTime = 0.0
        self.tickSpeed = 0.15
        self.running = false
    }
    
    public func update()
    {
        for track in subscribers {
            track.step()
        }
    }
    
    public func run()
    {
        currentTime = CACurrentMediaTime()
        var accumulator: Double = 0
        
        while (self.running) {
            let newTime = CACurrentMediaTime()
            let deltaTime = newTime - currentTime
            currentTime = newTime
            
            accumulator += deltaTime
            if (accumulator > tickSpeed){
                accumulator -= tickSpeed
                update()
            }
        }
    }
    
    public func play() {
        if (self.running) { return } // dont create a new thread unless others have finished
        
        // the run method will loop indefinately so will be called asynchronously
        let queue = DispatchQueue(label: "metronome")
        queue.async {
            self.running = true
            self.run()
        }
    }
    
    public func stop() {
        self.running = false
    }
    
    public func addSubscriber(subscriber: Track) {
        self.subscribers.append(subscriber)
    }
    
    public func removeSubscriber(subscriberIndex: Int) {
        self.subscribers.removeAll(where: { subscriberIndex == $0.getIndex() })
    }
}
