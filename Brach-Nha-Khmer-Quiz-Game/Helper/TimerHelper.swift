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
    
    private var duration: Double = 0
    private var reloader: Double = 0
    private var date: Date? = nil

    
    func setupTimer(duration: Double, reloadPerSec: Float = 0.01, date: Date = Date()) {
        self.duration = duration
        self.reloader = Double(reloadPerSec)
        self.date = date
    }
    
    
    func startCountDown() {
        guard date != nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: reloader, repeats: true) { timer in
            let remainder: Double = self.getTimerRemainder()
            let progress: Float = Float(remainder / Double(self.duration))

            self.delegate?.loadTimer(timer: timer, progress: progress)
            
            if remainder <= 0 {
                self.delegate?.didLoadTimer(timer: timer)
                timer.invalidate()
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
    }
    
    
    func reset() {
        timer?.invalidate()
        timer = nil
        date = nil
    }
    
    func getTimerRemainder() -> Double {
        return Double(self.duration - NSDate().timeIntervalSince(self.date ?? Date()))
    }
    

}
