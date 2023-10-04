//
//  DatabaseHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/3/23.
//

import RealmSwift

class DatabaseHelper {
    
    private let realm = try! Realm()
    
    
    func isEmpty() -> Bool {
        return realm.isEmpty
    }
    
    func getPath() {
        let realmConfig = Realm.Configuration()
        
        if let realmFileURL = realmConfig.fileURL {
            print("Realm file path: \(realmFileURL.path)")
        } else {
            print("Realm file URL is nil")
        }
    }
    
    func loadData() {
        if isEmpty() {
            guard let userData = UserData().defaultUsetData() else { return }
            
            
            try! realm.write({
                realm.add(userData)
            })
        } else {
            print("UserData: ", fetchData())
        }
    }
    
    
    func fetchData() -> UserData {
        let result = realm.objects(UserData.self)
        return result[0]
    }
    
    func getLevelCompleted(gameKey: String) -> [LevelCompleted]? {
        guard let gameData = gameData else { return nil }
        let result = realm.objects(UserData.self)
        let userData = fetchData()
        
        var levels: [LevelCompleted]? = nil
        
        switch gameKey {
        case gameData.Riddle.key:
            levels = userData.game?.riddle?.levels.map { $0 }
            
        case gameData.Proverb.key:
            levels = userData.game?.proverb?.levels.map { $0 }
            
        case gameData.GeneralKnowledge.key:
            levels = userData.game?.generalKnowledge?.levels.map { $0 }
            
        default:
            
            print("Wrong Game Key")
            return nil
        }
        
        
        return levels
    }
    
    func resetData() {
        try! realm.write {
            let objectsToDelete = realm.objects(UserData.self)
            realm.delete(objectsToDelete)
            
            print("Database reset successfully!")
        }
    }
    
    func addCompletedLevel(gameKey: String, level: LevelCompleted) {
        guard let gameData = gameData else { return }
        let userData = realm.objects(UserData.self)[0]
        
        try! realm.write{

            switch gameKey {
            case gameData.Riddle.key:
                userData.game?.riddle?.levels.append(level)
                
            case gameData.Proverb.key:
                userData.game?.proverb?.levels.append(level)
                
            case gameData.GeneralKnowledge.key:
                userData.game?.generalKnowledge?.levels.append(level)
                
            default:
                
                print("Wrong Game Key")
                return
            }
            
            
        }
        print("UserData: ", fetchData())
    }
    
    func getTotalScore() -> Int {
        let userData = realm.objects(UserData.self)[0]
        return userData.game?.getTotalScore() ?? 0
    }
    
    func getTotalStar() -> Int {
        let userData = realm.objects(UserData.self)[0]
        return userData.game?.getTotalStar() ?? 0
    }
    
    func getHint(hintType: HintType) -> Int {
        let userData = fetchData()
        
        switch hintType {
        case .answer:
            return userData.hint?.answerHint?.number ?? 0
        case .halfhalf:
            return userData.hint?.halfHint?.number ?? 0
        }
    }
    
    func updateHint(hintType: HintType, number: Int) {
        
        let userData = realm.objects(UserData.self)[0]
        
        try! realm.write{

            switch hintType {
            case .answer:
                userData.hint?.answerHint?.number += number
            case .halfhalf:
                userData.hint?.halfHint?.number += number
            }
        }
        print("UserData: ", fetchData())
    }
    
    

    
    
    
}
