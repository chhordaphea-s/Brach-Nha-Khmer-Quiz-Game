//
//  Constant.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/27/23.
//

import Foundation
import UIKit

class Constant {
    // MARK: - FONT
    static func getFont(size: Float) -> UIFont {
        return UIFont(name: "AKbalthom-KOUPREY-Jais", size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
    }
    
    // MARK: - COLOR
    struct color {
        static func getTextColor() -> UIColor {
            return UIColor(named: "Text Color") ?? UIColor.label
        }
        
        static func getClearColor() -> UIColor {
            return UIColor.clear
        }
        
        static func getPrimaryColor() -> UIColor {
            return UIColor(named: "Primary Color") ?? UIColor.systemGreen
        }
        
    }
    
    
    // MARK: ICON
    struct icon {
        struct music {
            static func getActive() -> UIImage {
                return UIImage(named: "music") ?? UIImage(systemName: "music.note")!
            }
            static func getDisActive() -> UIImage {
                return UIImage(named: "noMusic") ?? UIImage(systemName: "music.note")!
            }
        }
        
        struct sound {
            static func getActive() -> UIImage {
                return UIImage(named: "sound") ?? UIImage(systemName: "speaker.wave.2")!
            }
            static func getDisActive() -> UIImage {
                return UIImage(named: "noSound") ?? UIImage(systemName: "speaker")!
            }
        }
        
        struct virate {
            static func getActive() -> UIImage {
                return UIImage(named: "vibrate") ?? UIImage(systemName: "waveform")!
            }
            static func getDisActive() -> UIImage {
                return UIImage(named: "noVibrate") ?? UIImage(systemName: "waveform.slash")!
            }
        }
    }
    
    
    // MARK: USERDEFAULT
    struct userdefault {
        static let musicBackground = "musicBackgroundKey",
                    soundEffect = "soundEffectKey",
                    vibrate = "vibrateKey",
                    halfHint = "HalfHint",
                    answerHint = "AnswerHint",
                    totalScore = "TotalScore",
                    totalStar = "TotalStar"
        
    }
    
}
