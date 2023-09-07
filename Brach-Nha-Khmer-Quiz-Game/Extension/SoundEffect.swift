//
//  SoundEffect.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/3/23.
//

import UIKit
import AVFAudio

extension UIView {
    private struct AssociatedKeys {
        static var soundEffectKey = "soundEffectKey"
    }
    
    // Create an @IBInspectable property with a supported type
    @IBInspectable var soundFileName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.soundEffectKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.soundEffectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.first != nil {
            guard let soundName = soundFileName else {return}
            if !soundName.isEmpty && soundEffect{
                buttonSoudEffect.musicConfigure(audioName: soundName)
                buttonSoudEffect.player?.play()
            }
        }
    }
}

extension UIButton {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let soundName = soundFileName else {return}
        if !soundName.isEmpty && soundEffect{
            buttonSoudEffect.musicConfigure(audioName: soundName)
            buttonSoudEffect.player?.play()
        }
    }
}
