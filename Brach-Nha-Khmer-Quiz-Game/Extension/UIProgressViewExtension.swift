//
//  UIProgressViewExtension.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 7/9/23.
//

import Foundation
import UIKit

private var progressTimerKey: UInt8 = 0


extension UIProgressView {

    private var progressTimer: Timer? {
        get {
            return objc_getAssociatedObject(self, &progressTimerKey) as? Timer
        }
        set {
            objc_setAssociatedObject(self, &progressTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @available(iOS 10.0, *)
    func setAnimatedProgress(timer: Timer, progress: Float = 0, duration: Float = 40, completion: (() -> ())? = nil) {
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
        DispatchQueue.main.async {
            let current = self.progress
            self.setProgress(current-(1/(100 * duration)), animated: true)
        }
            
            if self.progress <= progress {
                self.progressTimer?.invalidate()
                timer.invalidate()
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func timeRemainder(duration: Float = 40) -> Int {
        let timeRemainder = self.progress * duration
        return Int(timeRemainder)
    }

    func pauseProgress() {
        progressTimer?.invalidate()
        progressTimer = Timer()
    }
    
}
