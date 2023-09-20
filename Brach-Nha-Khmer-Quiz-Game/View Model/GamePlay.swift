//
//  GamePlay.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 19/9/23.
//

import Foundation

struct GamePlay {
    let gameKey: String
    var level: Level
    var question: Int
    
    var score: Int
    var fail: Int
    var timings: Int
    var answerHint: HintButton
    var halfhalfHint: HintButton
    var star: Int
    var highestScore: Int
    
    init(gameKey: String, level: Level, question: Int, score: Int, fail: Int, timings: Int, answerHint: HintButton, halfhalfHint: HintButton, star: Int, highestScore: Int) {
        self.gameKey = gameKey
        self.level = level
        self.question = question
        self.score = score
        self.fail = fail
        self.timings = timings
        self.answerHint = answerHint
        self.halfhalfHint = halfhalfHint
        self.star = star
        self.highestScore = highestScore
    }
    
}
