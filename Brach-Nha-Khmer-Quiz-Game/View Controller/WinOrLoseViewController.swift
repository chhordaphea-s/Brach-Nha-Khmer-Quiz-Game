//
//  WinOrLoseViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 24/9/23.
//

import UIKit
import AudioToolbox


class WinOrLoseViewController: UIViewController {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subMessageLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalTimingLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var replayButton: UIView!
    @IBOutlet weak var nextGameButton: UIView!
    @IBOutlet weak var nextGameIcon: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var stars: [StarView]!
    
    var gamePlay: GamePlay? = nil
    var shouldGiveHint = false
    
    let databaseHelper = DatabaseHelper()
    private let hintView = HintPopupView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNextButton()

        
        guard let gamePlay = gamePlay else { return }
        if gamePlay.question == 6 {
            if gamePlay.highestScore == 0 && gamePlay.level.level % 5 == 0 {
                shouldGiveHint = true
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findTotalTiming()
        setupTotalScore()
        displayMessages()
        setupHighestScore()
        displayStars()
        setupSoundEffect()
        
        writeDataToDatabase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        giftHint()
    }
    
    
    
    @IBAction func replayTapGesture(_ sender: UITapGestureRecognizer) {
        guard let gamePlayData = gamePlay else {return}

        ButtonEffectAnimation.shared.popEffect(button: replayButton)
        
        switchToReadingQuestionScreen(key: gamePlayData.gameKey,
                                      level: gamePlayData.level,
                                      highestScore: gamePlayData.highestScore)
    }
    
    @IBAction func nextGameTapGesture(_ sender: Any) {
        guard let gamePlay = gamePlay else {return}
        ButtonEffectAnimation.shared.popEffect(button: nextGameButton)

        if gamePlay.question == 6 {
            guard let nextLvl = gameData?.getLevelGameFromLevelNum(gameKey: gamePlay.gameKey,
                                                                   levelNum: gamePlay.level.level + 1)else { return }

            switchToReadingQuestionScreen(key: gamePlay.gameKey,
                                          level: nextLvl,
                                          highestScore: 0)
        } else {
            guard let gameData = gameData else { return }
            guard let game = gameData.getGameByKey(key: gamePlay.gameKey) else { return }
            
            self.gotoLevelViewController(data: game)
        }
    }
    
    @IBAction func menuButtonPressed(_ sener: UIButton) {
        guard let gameData = gameData else { return }
        guard let gamePlay = gamePlay else {return}
        guard let game = gameData.getGameByKey(key: gamePlay.gameKey) else { return }
        
        self.gotoLevelViewController(data: game)
    }
    
    // MARK: - Function
    
    func giftHint() {
        if !shouldGiveHint { return }
        
        hintView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.increaseHint(hint: .answer)
        }
        

    }
    
    func increaseHint(hint: HintType) {
        hintView.setup(data: Hint(hinType: hint, number: 1))
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: hintView, width: 314, height: 276, tapBackground: false)
    }
    
    func configureNextButton() {
        
        if gamePlay?.question != 6 {
            nextGameIcon.image = UIImage(named: "level")!
            menuButton.isHidden = true
            nextGameIcon.tintColor = .white
        }
    }
    
    func writeDataToDatabase() {
        guard let gamePlay = gamePlay else {return}

        if gamePlay.question == 6 {
            let levelCompleted = LevelCompleted().defaultData(star: getStar() ?? 1,
                                                              score: getHighestScore() ?? 0,
                                                              timing: gamePlay.timings,
                                                              level: gamePlay.level.level)
            
            databaseHelper.addCompletedLevel(gameKey: gamePlay.gameKey, level: levelCompleted)
        }
        
    }
    
    func setupSoundEffect() {
        guard let gamePlayData = gamePlay else {return}
        
        peformVibrate(win: gamePlayData.question == 6 ? true : false)

        buttonSoudEffect.musicConfigure(audioName: gamePlayData.question == 6 ? "winner" : "lostGame")

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
        var tmpHighestScore = getHighestScore() ?? 0
        
        highestScoreLabel.text = convertEngNumToKhNum(engNum: tmpHighestScore)
    }
    
    func getHighestScore() -> Int? {
        guard let gamePlayData = gamePlay else {return nil}
        var tmpHighestScore: Int
        
        if gamePlayData.highestScore < gamePlayData.score {
            tmpHighestScore = gamePlayData.score
        } else {
            tmpHighestScore = gamePlayData.highestScore
        }
        
        return tmpHighestScore
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
        var numOfStar = getStar() ?? 0
        
        DispatchQueue.main.async {
            for i in 0..<numOfStar {
                let sec: Double = Double(i) * 0.2
                DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                    self.stars[i].activateStar(status: true)
                }
            }
        }
        
    }
    
    func getStar() -> Int? {
        guard let gamePlayData = gamePlay else {return nil}

        var numOfStar = 0
        
        if gamePlayData.question == 6 {
            if gamePlayData.score < 500 {
                numOfStar = 1
            } else if gamePlayData.score < 800 {
                numOfStar = 2
            } else {
                numOfStar = 3
            }
        }
        return numOfStar
    }
    
    func switchToReadingQuestionScreen(key: String, level: Level, highestScore: Int) {
        let userData = databaseHelper.fetchData()
        guard let answerHint = userData.hint?.answerHint?.number else { return }
        guard let halfHint = userData.hint?.halfHint?.number else { return }
                
        let gamePlay = GamePlay(gameKey: key,
                                startPlayTime: Date(),
                                level: level,
                                answerHint: HintButton(type: .answer, num: answerHint, enable: true),
                                halfhalfHint: HintButton(type: .halfhalf, num: halfHint, enable: true),
                                highestScore: userData.game?.getGameByKey(key: key)?.getLevelGameFromLevelNum(levelNum: level.level)?.score ?? 0)
        self.gotoReadingQuestionViewController(data: gamePlay)
    }
}


extension WinOrLoseViewController: HintPopupViewDelegate {
    func dismissHintView(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
        
        if shouldGiveHint {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.increaseHint(hint: .halfhalf)
                self.shouldGiveHint = false
            }
        }
    }
    
    
}
