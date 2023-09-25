//
//  Data.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/9/23.
//

import Foundation

struct GameData: Decodable {
    let GeneralKnowlage: Game
    let Proverb: Game
    let Riddle: Game
    
    init(GeneralKnowlage: Game, Proverb: Game, Riddle: Game) {
        self.GeneralKnowlage = GeneralKnowlage
        self.Proverb = Proverb
        self.Riddle = Riddle
    }
    
    func getGameByKey(key: String) -> Game? {
        switch key {
        case GeneralKnowlage.key:
            return self.GeneralKnowlage
        case Proverb.key:
            return self.Proverb
        case Riddle.key:
            return self.Riddle
        default :
            return nil
        }
    }
    
    func getLevelGameFromLevelNum(gameKey: String, levelNum: Int) -> Level? {
        let game = self.getGameByKey(key: gameKey)!
        for lvl in game.levels {
            if lvl.level == levelNum {
                return lvl
            }
        }
        
        return nil
    }
}

struct Game: Decodable {
    let key: String
    let title: String
    let object: String
    let description: String
    let levels: [Level]
    
    init(key: String, title: String, object: String, description: String, levels: [Level]) {
        self.key = key
        self.title = title
        self.object = object
        self.description = description
        self.levels = levels
    }
}

struct Level: Decodable {
    let level: Int
    var questions: [Question]
    
    init(level: Int, questions: [Question]) {
        self.level = level
        self.questions = questions
    }
}

struct Question: Decodable {
    let question: String
    let answer: String
    var possibleAnswer: [String]?
    
    init(question: String, answer: String, possibleAnswer: [String]?) {
        self.question = question
        self.answer = answer
        self.possibleAnswer = possibleAnswer
    }

}


