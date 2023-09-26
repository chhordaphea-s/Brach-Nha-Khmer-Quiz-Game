//
//  Hint.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/7/23.
//

import Foundation

struct HintView {
    let hinType: HintType
    let number: Int
    
    init(hinType: HintType, number: Int) {
        self.hinType = hinType
        self.number = number
    }
    
}

enum HintType: String  {
    case answer = "ប្រាបចម្លើយ";
    case halfhalf = "៥០:៥០";
}
