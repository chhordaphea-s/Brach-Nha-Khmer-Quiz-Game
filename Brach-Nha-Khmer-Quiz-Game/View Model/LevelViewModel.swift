//
//  LevelViewModel.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 28/8/23.
//

import Foundation
struct LevelViewModel{
    let star : Int
    let levelNum : Int
    
    init(star: Int, levelNum: Int) {
        self.star = star
        self.levelNum = levelNum
    }
}
