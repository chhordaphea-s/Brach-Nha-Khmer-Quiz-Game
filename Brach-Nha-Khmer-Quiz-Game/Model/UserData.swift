//
//  UserData.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/2/23.
//

import GameKit

struct UserData: Codable {
//    var user: GKLocalPlayer
    var hint: UserHint
    var game: UserGame
    
    init(hint: UserHint, game: UserGame) {
        self.hint = hint
        self.game = game
    }
}

struct UserHint: Codable {
    let answerHint: Hint
    let halfHint: Hint
    
    init(answerHint: Hint, halfHint: Hint) {
        self.answerHint = answerHint
        self.halfHint = halfHint
    }
}

struct UserGame: Codable {
    var riddle: UserGameData
    var proverb: UserGameData
    var generalKnowledge: UserGameData
    
    init(riddle: UserGameData, proverb: UserGameData, generalKnowledge: UserGameData) {
        self.riddle = riddle
        self.proverb = proverb
        self.generalKnowledge = generalKnowledge
    }
    
    func getTotalScore() -> Int {
        var total = 0

        self.riddle.level.forEach { data in
            total += data.score
        }
        
        self.proverb.level.forEach { data in
            total += data.score
        }
        
        self.generalKnowledge.level.forEach { data in
            total += data.score
        }
        
        return total
    }
    
    func getTotalStar() -> Int {
        var total = 0
        
        self.riddle.level.forEach { data in
            total += data.star
        }
        
        self.proverb.level.forEach { data in
            total += data.star
        }
        
        self.generalKnowledge.level.forEach { data in
            total += data.star
        }
        
        return total
    }
}

struct UserGameData: Codable {
    let key: String
    var level: [UserLevel]
}

struct UserLevel: Codable {
    var star: Int
    var score: Int
    var timing: Int
    let level: Level
    
    init(star: Int, score: Int, timing: Int, level: Level) {
        self.star = star
        self.score = score
        self.timing = timing
        self.level = level
    }
}


