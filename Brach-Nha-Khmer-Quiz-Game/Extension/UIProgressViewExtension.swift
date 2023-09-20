//
//  UIProgressViewExtension.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 7/9/23.
//

import Foundation
import UIKit

extension UIProgressView {
    @available(iOS 10.0, *)
    func setAnimatedProgress(progress: Float = 0, duration: Float = 1, completion: (() -> ())? = nil) {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            DispatchQueue.main.async {
                let current = self.progress
                self.setProgress(current-(1/(100 * duration)), animated: true)
            }
            
            if self.progress <= progress {
                timer.invalidate()
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func timeRemainder(duration: Float = 1) -> Int{
        let timeRemainder = self.progress * duration
        return Int(timeRemainder)
    }
    
}
