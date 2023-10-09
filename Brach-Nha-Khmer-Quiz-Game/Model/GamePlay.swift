//
//  GamePlay.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 19/9/23.
//

import Foundation

struct GamePlay {
    let gameKey: String
    let readingTime: Double
    let answerTime: Double
    let multiplyer: Int
    let startPlayTime: Date
    
    var level: Level
    var question: Int
    
    var score: Int
    var fail: Int
    var timings: Int
    var answerHint: HintButton
    var halfhalfHint: HintButton
    var star: Int
    var highestScore: Int
    
    
    init(gameKey: String, 
         readingTime: Double = 15,
         answerTime: Double = 40,
         multiplyer: Int = 5,
         startPlayTime: Date, level: Level,
         question: Int = 1,
         score: Int = 0,
         fail: Int = 0,
         timings: Int = 0,
         answerHint: HintButton,
         halfhalfHint: HintButton,
         star: Int = 0,
         highestScore: Int) {
        self.gameKey = gameKey
        self.readingTime = readingTime
        self.answerTime = answerTime
        self.multiplyer = multiplyer
        self.startPlayTime = startPlayTime
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
