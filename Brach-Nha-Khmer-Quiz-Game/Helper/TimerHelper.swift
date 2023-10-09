//
//  TimerHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/27/23.
//

import UIKit

protocol TimerHelperDelegate: NSObjectProtocol {
    func loadTimer(timer: Timer, progress: Float)
    func didLoadTimer(timer: Timer)
}

class TimerHelper {
    var timer: Timer?
    
    weak var delegate: TimerHelperDelegate?
    
    private var duration: TimeInterval = 0
    private var reloader: Double = 0
    private var counter: Double = 0
    
    
    
    func setupTimer(duration: Double, reloadPerSec: Float = 0.01) {
        self.duration = TimeInterval(duration)
        self.reloader = Double(reloadPerSec)
    }
    
    
    func startCountDown() {
        self.counter = duration

        timer = Timer.scheduledTimer(withTimeInterval: reloader, repeats: true) { timer in
            let progress: Float = Float(self.counter / self.duration)
            self.delegate?.loadTimer(timer: timer, progress: progress)
            
            if self.counter <= 0 {
                self.delegate?.didLoadTimer(timer: timer)
                timer.invalidate()
            }
            self.counter -= self.reloader
            
        }
    }
    
    func pause() {
        timer?.invalidate()
    }
    
    
    func reset() {
        timer?.invalidate()
        timer = nil
        self.counter = self.duration
    }
    
    func getTimerRemainder() -> Double {
        return self.counter
    }
    

}
