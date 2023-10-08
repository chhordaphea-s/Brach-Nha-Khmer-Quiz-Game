//
//  UserData.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/2/23.
//

import RealmSwift

class UserData: Object {
    @objc dynamic var userID: String?
    @objc dynamic var hint: UserHint?
    @objc dynamic var game: UserGame?
    
    func defaultUsetData(userID: String? = nil) -> UserData? {
        guard let gameData = gameData else { return nil }
        let userdata = UserData()
        userdata.userID = userID
        
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
    @objc dynamic var key: String?
    var levels = List<LevelCompleted>()
    
    func defaultData(key: String?, levels: List<LevelCompleted> = List<LevelCompleted>()) -> UserGameData{
        self.key = key
        self.levels = levels
        
        return self
    }
    
    func getLevelGameFromLevelNum(levelNum: Int) -> LevelCompleted? {
        for lvl in levels {
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


// MARK: Object -> Firestore Dictionary

extension UserData {
    func toFirestoreDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        data["userID"] = userID
        data["hint"] = hint?.toFirestoreDictionary()
        data["game"] = game?.toFirestoreDictionary()
        return data
    }
    

}

extension UserHint {
    func toFirestoreDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        data["answerHint"] = answerHint?.toFirestoreDictionary()
        data["halfHint"] = halfHint?.toFirestoreDictionary()
        return data
    }
}

extension UserGame {
    func toFirestoreDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        data["riddle"] = riddle?.toFirestoreDictionary()
        data["proverb"] = proverb?.toFirestoreDictionary()
        data["generalKnowledge"] = generalKnowledge?.toFirestoreDictionary()
        return data
    }
}

extension UserGameData {
    func toFirestoreDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        data["key"] = key
        // Convert List<LevelCompleted> to an array of dictionaries
        var levelsArray: [[String: Any]] = []
        
        for lvl in levels{
            levelsArray.append(lvl.toFirestoreDictionary())
        }
        
        data["levels"] = levelsArray
        return data
    }
}

extension LevelCompleted {
    func toFirestoreDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        data["star"] = star
        data["score"] = score
        data["timing"] = timing
        data["level"] = level
        return data
    }
}

extension HintDB {
    func toFirestoreDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        data["key"] = key
        data["number"] = number
        return data
    }
}


// MARK: Dictionary -> Object

extension UserData {
    static func fromFirestoreDictionary(_ dictionary: [String: Any]) -> UserData {
        let userData = UserData()
        
        if let userID = dictionary["userID"] as? String {
            userData.userID = userID
        }
        
        if let hintData = dictionary["hint"] as? [String: Any] {
            userData.hint = UserHint.fromFirestoreDictionary(hintData)
        }
        
        if let gameData = dictionary["game"] as? [String: Any] {
            userData.game = UserGame.fromFirestoreDictionary(gameData)
        }
        
        return userData
    }
}

extension UserHint {
    static func fromFirestoreDictionary(_ dictionary: [String: Any]) -> UserHint {
        let userHint = UserHint()
        
        if let answerHintData = dictionary["answerHint"] as? [String: Any],
           let halfHintData = dictionary["halfHint"] as? [String: Any] {
            userHint.answerHint = HintDB.fromFirestoreDictionary(answerHintData)
            userHint.halfHint = HintDB.fromFirestoreDictionary(halfHintData)
        }
        
        return userHint
    }
}

extension UserGame {
    static func fromFirestoreDictionary(_ dictionary: [String: Any]) -> UserGame {
        let userGame = UserGame()
        
        if let riddleData = dictionary["riddle"] as? [String: Any],
           let proverbData = dictionary["proverb"] as? [String: Any],
           let generalKnowledgeData = dictionary["generalKnowledge"] as? [String: Any] {
            userGame.riddle = UserGameData.fromFirestoreDictionary(riddleData)
            userGame.proverb = UserGameData.fromFirestoreDictionary(proverbData)
            userGame.generalKnowledge = UserGameData.fromFirestoreDictionary(generalKnowledgeData)
        }
        
        return userGame
    }
}

extension UserGameData {
    static func fromFirestoreDictionary(_ dictionary: [String: Any]) -> UserGameData {
        let userGameData = UserGameData()
        
        if let key = dictionary["key"] as? String,
           let levelsData = dictionary["levels"] as? [[String: Any]] {
            userGameData.key = key
            
            for levelData in levelsData {
                if let level = LevelCompleted.fromFirestoreDictionary(levelData) {
                    userGameData.levels.append(level)
                }
            }
        }
        
        return userGameData
    }
}

extension LevelCompleted {
    static func fromFirestoreDictionary(_ dictionary: [String: Any]) -> LevelCompleted? {
        guard let star = dictionary["star"] as? Int,
              let score = dictionary["score"] as? Int,
              let timing = dictionary["timing"] as? Int,
              let level = dictionary["level"] as? Int else {
            return nil
        }
        
        let levelCompleted = LevelCompleted()
        levelCompleted.star = star
        levelCompleted.score = score
        levelCompleted.timing = timing
        levelCompleted.level = level
        
        return levelCompleted
    }
}

extension HintDB {
    static func fromFirestoreDictionary(_ dictionary: [String: Any]) -> HintDB {
        let hintDB = HintDB()
        
        if let key = dictionary["key"] as? String,
           let number = dictionary["number"] as? Int {
            hintDB.key = key
            hintDB.number = number
        }
        
        return hintDB
    }
}
