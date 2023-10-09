//
//  LevelViewModel.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 28/8/23.
//

import Foundation
import UIKit

struct LevelViewModel{
    let color1 : CGColor
    let color2 : CGColor
    let levelNum : Int
    let star : Int
    var enable: Bool
    
    init(color1: CGColor, color2: CGColor, levelNum: Int, star: Int, enable: Bool = false) {
        self.color1 = color1
        self.color2 = color2
        self.levelNum = levelNum
        self.star = star
        self.enable = enable
    }
    
}
