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
    
}
