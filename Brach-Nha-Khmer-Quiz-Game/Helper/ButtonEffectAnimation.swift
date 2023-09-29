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
    
    func triggerRightAnswer(button: UIView, sclaEffect: Float = 1.1) {

        popOutAnimation(view: button, isTrigger: true) {view in
            self.popInAnimation(view: view, isTrigger: true)
        }
    }
    
    private func popInAnimation(view: UIView, isTrigger: Bool = false, sclaEffect: Float = 1 , completion: ((_ view: UIView)->())? = nil) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [.curveEaseIn, .allowUserInteraction], animations: {
            view.transform = CGAffineTransform(scaleX: CGFloat(sclaEffect), y: CGFloat(sclaEffect))
        }, completion: {_ in
            if isTrigger {
                self.popOutAnimation(view: view, isTrigger: true)
            } else {
                completion?(view)
            }
        })
        
    }
                       
    func popOutAnimation(view: UIView, isTrigger: Bool = false, sclaEffect: Float = 1.07, completion: ((_ view: UIView)->())? = nil) {

        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [.curveEaseOut, .allowUserInteraction] , animations: {
            view.transform = CGAffineTransform(scaleX: CGFloat(sclaEffect), y: CGFloat(sclaEffect))
        }, completion: {_ in
            if isTrigger {
                self.popInAnimation(view: view, isTrigger: true)
            } else {
                completion?(view)
            }
        })
    }
    
    func curveAnimation(view: UIView, animationOptions: UIView.AnimationOptions, defaultXMovement: CGFloat, isReset: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: -0.5, delay: 0, options: animationOptions, animations: {
        view.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
      }, completion: {_ in
          completion?()
      })
    }
    

}
