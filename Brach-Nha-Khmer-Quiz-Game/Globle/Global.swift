//
//  MusicManager.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/3/23.
//

import Foundation

let userdefault = UserDefaults.standard

var gameData: GameData? = {
    if let url = Bundle.main.url(forResource: "GameData", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(GameData .self, from: data)

            print("Load data successgully")
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}()

let backgroundMusic = AudioHelper(audioName: "background", player: nil, loop: true)
var buttonSoudEffect = AudioHelper()

var soundEffect: Bool { return userdefault.bool(forKey: Constant.userdefault.soundEffect) }
var vibrate: Bool = true

var halfHint: Int { return userdefault.integer(forKey: Constant.userdefault.halfHint)  }
var answerHint: Int {  return userdefault.integer(forKey: Constant.userdefault.answerHint) }
var totalScore: Int { return userdefault.integer(forKey: Constant.userdefault.totalScore) }
var totalStar: Int { return userdefault.integer(forKey: Constant.userdefault.totalStar) }



// MARK: FUNCTION
func getPossiableAnswer(game: Game, level: Int, question: Int) {
    let correctAns = game.levels[level-1].questions[question-1].answer
    var allAnswer: [String] = []
    var possiableAnswwer: [String] = [correctAns]
    
    
    for i in game.levels{
        for j in i.questions{
            allAnswer.append(j.answer)
        }
    }
    
    for _ in 0...2 {
        var tmpAnswer = allAnswer.randomElement()
        while game.levels[level-1].questions[question-1].answer == tmpAnswer {
            tmpAnswer = allAnswer.randomElement()
        }
        possiableAnswwer.append(tmpAnswer ?? "")

    }
    
    possiableAnswwer.shuffle()
    
    print("Possiable Answer: ", possiableAnswwer)
    print("Answer: ", correctAns)
}
