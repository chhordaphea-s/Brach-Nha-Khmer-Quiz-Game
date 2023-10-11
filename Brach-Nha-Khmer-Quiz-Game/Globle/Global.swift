//
//  MusicManager.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/3/23.
//

import Foundation
import UIKit
import AudioToolbox

let userdefault = UserDefaults.standard

let gameData: GameData? = {
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
var vibrate: Bool { return userdefault.bool(forKey: Constant.userdefault.vibrate) }


// MARK: FUNCTION
func getPossiableAnswer(game: Game, level: Int, question: Int) -> [String] {
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
        while game.levels[level-1].questions[question-1].answer == tmpAnswer || possiableAnswwer.contains(tmpAnswer ?? ""){
            tmpAnswer = allAnswer.randomElement()
        }
        possiableAnswwer.append(tmpAnswer ?? "")

    }
    
    possiableAnswwer.shuffle()
    return possiableAnswwer
}

func convertEngNumToKhNum(engNum: Int) -> String{
    var khNumStr = ""

    let khNum = ["០", "១", "២", "៣", "៤", "៥", "៦", "៧", "៨", "៩"]
    let engString = String(engNum)
    
    for each in engString {
        let i = Int(String(each)) ?? 0
        khNumStr += khNum[i]
    }
    return khNumStr
}



func performButtonVibrate(vibrateType: UINotificationFeedbackGenerator.FeedbackType) {
    if !vibrate { return }
    UINotificationFeedbackGenerator().notificationOccurred(vibrateType)
}

func peformVibrate(win: Bool) {
    if win {
        AudioServicesPlaySystemSound(SystemSoundID(1329))
    } else {
//       AudioServicesPlaySystemSound(SystemSoundID(1027))
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)


    }

    
//                AudioServicesPlaySystemSound(SystemSoundID(1301))
//               AudioServicesPlaySystemSound(SystemSoundID(1027))
//               AudioServicesPlaySystemSound(SystemSoundID(1028))
//                let alert = SystemSoundID(1011)
//                AudioServicesPlaySystemSoundWithCompletion(alert, nil)
//               AudioServicesPlaySystemSound(SystemSoundID(1333))
//               AudioServicesPlaySystemSound(SystemSoundID(4095))
            
}

func stringToDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "YY/MMM/d, HH:mm:ss"
    return dateFormatter.date(from: date)!
}
    
func dateToString(date: Date?) -> String? {
    guard let date = date else {
        return nil
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MMM/d, HH:mm:ss"
    return dateFormatter.string(from: date)
}

