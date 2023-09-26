//
//  WinOrLoseViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 24/9/23.
//

import UIKit

class WinOrLoseViewController: UIViewController {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subMessageLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalTimingLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var replayButton: UIView!
    @IBOutlet weak var nextGameButton: UIView!
    @IBOutlet var stars: [StarView]!
    
    var gamePlay: GamePlay? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findTotalTiming()
        setupTotalScore()
        displayMessages()
        setupHighestScore()
        displayStars()

    }
    
    
    @IBAction func replayTapGesture(_ sender: UITapGestureRecognizer) {
        guard let gamePlayData = gamePlay else {return}

        ButtonEffectAnimation.shared.popEffect(button: replayButton)
        
        switchToReadingQuestionScreen(key: gamePlayData.gameKey,
                                      level: gamePlayData.level,
                                      highestScore: gamePlayData.highestScore)
    }
    
    @IBAction func nextGameTapGesture(_ sender: Any) {
        guard let gamePlayData = gamePlay else {return}
        guard let nextLvl = gameData?.getLevelGameFromLevelNum(gameKey: gamePlayData.gameKey, 
                                                               levelNum: gamePlayData.level.level + 1)else { return }

        ButtonEffectAnimation.shared.popEffect(button: nextGameButton)
        
        
        switchToReadingQuestionScreen(key: gamePlayData.gameKey,
                                      level: nextLvl,
                                      highestScore: 0)
    }
    
    func setupTotalScore() {
        totalScoreLabel.text = convertEngNumToKhNum(engNum: gamePlay?.score ?? 0)
        
    }
    
    func findTotalTiming() {
        guard let gamePlayData = gamePlay else {return}
        let totalTiming = gamePlayData.timings
        
        let minute = totalTiming / 60
        let second = totalTiming % 60
        
        totalTimingLabel.text = "\(convertEngNumToKhNum(engNum: minute)):\(convertEngNumToKhNum(engNum: second))"
        print("\(minute):\(second)")
        
    }
    
    func setupHighestScore() {
        guard let gamePlayData = gamePlay else {return}
        var tmpHighestScore: Int
        
        if gamePlayData.highestScore < gamePlayData.score {
            tmpHighestScore = gamePlayData.score
        } else {
            tmpHighestScore = gamePlayData.highestScore
        }
        
        highestScoreLabel.text = convertEngNumToKhNum(engNum: tmpHighestScore)
    }
    
    func displayMessages() {
        guard let gamePlayData = gamePlay else {return}
        
        if gamePlayData.question >= 5 {
            messageLabel.text = "ចូលរួមអបអរសាទរ​"
            subMessageLabel.text = "អ្នកពិតជាធ្វើបានល្អណាស់!​"
        } else {
            messageLabel.text = "ចូលរួមសោកស្ដាយ"
            subMessageLabel.text = "សូមព្យាយាមលេងម្ដងទៀត!​"
        }
        
        
    }
    
    func displayStars() {
        guard let gamePlayData = gamePlay else {return}
        var numOfStar = 0
        
        if gamePlayData.question == 5 {
            if gamePlayData.score < 500 {
                numOfStar = 1
            } else if gamePlayData.score < 800 {
                numOfStar = 2
            } else {
                numOfStar = 3
            }
        }
        
        DispatchQueue.main.async {
            for i in 0..<numOfStar {
                let sec: Double = Double(i) * 0.2
                DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                    self.stars[i].activateStar(status: true)
                }
            }
        }
        
    }
    
    func switchToReadingQuestionScreen(key: String, level: Level, highestScore: Int) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ReadingQuestionViewController") as! ReadingQuestionViewController
        
        controller.gamePlay = GamePlay(gameKey: key,
                                       level: level,
                                       question: 1,
                                       score: 0,
                                       fail: 0,
                                       timings: 0,
                                       answerHint: HintButton(type: .answer, num: answerHint, enable: true),
                                       halfhalfHint: HintButton(type: .halfhalf, num: halfHint, enable: true),
                                       star: 0,
                                       highestScore: highestScore,
                                       countTimer: Date()
        )
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
    
    
    
    

   

}
