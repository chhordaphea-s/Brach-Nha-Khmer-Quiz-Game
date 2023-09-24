//
//  HintButton.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 6/9/23.
//

import Foundation

struct HintButton {
    let type: HintType
    var enable: Bool
    var num: Int
    
    init(type: HintType, num: Int, enable: Bool) {
        self.type = type
        self.enable = enable
        self.num = num
    }
}
