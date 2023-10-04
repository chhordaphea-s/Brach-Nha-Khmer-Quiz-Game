//
//  UserData.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/2/23.
//

import GameKit
import RealmSwift

class UserData: Object {
    @objc dynamic  var hint: UserHint?
    @objc dynamic  var game: UserGame?
    
    func defaultUsetData() -> UserData? {
        guard let gameData = gameData else { return nil }
        let userdata = UserData()
        
        // hint
        let hint = UserHint()
        hint.answerHint = HintDB().defaultData(key: HintType.answer.rawValue)
        hint.halfHint = HintDB().defaultData(key: HintType.halfhalf.rawValue)
        
        //game

        let game = UserGame()
        game.riddle = UserGameData().defaultData(key: gameData.Riddle.key)
        game.proverb = UserGameData().defaultData(key: gameData.Proverb.key)
        game.generalKnowledge = UserGameData().defaultData(key: gameData.GeneralKnowledge.key)
        
        userdata.hint = hint
        userdata.game = game
        
        return userdata
    }
}

class UserHint: Object {
    @objc dynamic  var answerHint: HintDB?
    @objc dynamic  var halfHint: HintDB?
    
    func defaultData(answerHint: HintDB, halfHint: HintDB) -> UserHint {
        self.answerHint = answerHint
        self.halfHint = halfHint
        
        return self
    }
}

class UserGame: Object {
    @objc dynamic  var riddle: UserGameData?
    @objc dynamic  var proverb: UserGameData?
    @objc dynamic  var generalKnowledge: UserGameData?
    
    func defaultData(riddle: UserGameData? = nil, proverb: UserGameData? = nil, generalKnowledge: UserGameData? = nil) -> UserGame {
        self.riddle = riddle
        self.proverb = proverb
        self.generalKnowledge = generalKnowledge
        
        return self
    }

    func getTotalScore() -> Int {
        var total = 0

        self.riddle?.levels.forEach { data in
            total += data.score 
        }
        
        self.proverb?.levels.forEach { data in
            total += data.score 
        }
        
        self.generalKnowledge?.levels.forEach { data in
            total += data.score 
        }
        
        return total
    }
    
    func getTotalStar() -> Int {
        var total = 0
        
        self.riddle?.levels.forEach { data in
            total += data.star
        }
        
        self.proverb?.levels.forEach { data in
            total += data.star
        }
        
        self.generalKnowledge?.levels.forEach { data in
            total += data.star
        }
        
        return total
    }
    
    func getGameByKey(key: String) -> UserGameData? {
        switch key {
        case generalKnowledge?.key:
            return self.generalKnowledge
        case proverb?.key:
            return self.proverb
        case riddle?.key:
            return self.riddle
        default :
            return nil
        }
    }
    
}

class UserGameData: Object {
    @objc dynamic  var key: String?
    var levels = List<LevelCompleted>()
    
    func defaultData(key: String?, levels: List<LevelCompleted> = List<LevelCompleted>()) -> UserGameData{
        self.key = key
        self.levels = levels
        
        return self
    }
    
    func getLevelGameFromLevelNum(levelNum: Int) -> LevelCompleted? {
        for lvl in self.levels {
            if lvl.level == levelNum {
                return lvl
            }
        }
        
        return nil
    }

}

class LevelCompleted: Object {
    @objc dynamic  var star: Int = 0
    @objc dynamic  var score: Int = 0
    @objc dynamic  var timing: Int = 0
    @objc dynamic  var level: Int = 0

    func defaultData(star: Int, score: Int, timing: Int, level: Int) -> LevelCompleted{
        self.star = star
        self.score = score
        self.timing = timing
        self.level = level
        
        return self
    }
}


class HintDB: Object {
    @objc dynamic  var key: String?
    @objc dynamic  var number: Int = 0

    func defaultData(key: String? , number: Int = 0) -> HintDB {
        self.key = key
        self.number = number
        
        return self
    }
}



