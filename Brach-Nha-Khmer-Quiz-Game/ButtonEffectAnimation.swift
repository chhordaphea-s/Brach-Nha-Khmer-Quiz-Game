//
//  PopEffectButton.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/25/23.
//

import Foundation
import UIKit

class ButtonEffectAnimation {
    static let shared = ButtonEffectAnimation()
    
    func popEffect(button: UIView, sclaEffect: Float = 0.8) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            button.alpha = 1
            button.transform = CGAffineTransform(scaleX: CGFloat(sclaEffect), y: CGFloat(sclaEffect))
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                button.alpha = 1
                // Pop in the view by scaling it up to it's original size
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        })
    }
    

}
