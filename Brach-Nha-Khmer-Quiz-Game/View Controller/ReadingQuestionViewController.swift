//
//  ReadingQuestionViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 14/9/23.
//

import UIKit
import Hero

class ReadingQuestionViewController: UIViewController {

    @IBOutlet weak var score: UILabel!
    @IBOutlet var lifePlaying: [UIImageView]!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionOrder: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var continueButton: UIView!
 
    var gamePlay: GamePlay? = nil
    let settingView = SettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameData()
        setupSettingView()
        
        ButtonEffectAnimation.shared.triggerRightAnswer(button: continueButton)
        
        ActivateContinueButton()
        setProgressTime()
        
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(ActivateContinueButton))
        continueButton.addGestureRecognizer(tab)
    }
    
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 348)
        ButtonEffectAnimation.shared.popEffect(button: sender)
    }
    
    // MARK: ~Body
    
    @objc func ActivateContinueButton() {
        print("Player ready!")
        ButtonEffectAnimation.shared.popEffect(button: continueButton)
        
        switchToAnswerScreen()
        
        
    }
    
    func setupSettingView() {
        settingView.delegate = self
        settingView.setup(type: .playing)
    }
    
    func setLifeOfGame() {
        for life in 0..<(gamePlay?.fail ?? 0) {
            lifePlaying[life].isHidden = true
            
        }
    }
    
    func getQuestion(level: Level, numOfQuestion: Int) -> String {
        return level.questions[numOfQuestion-1].question
    }
    
    func setupGameData() {
        guard let gamePlayData = gamePlay else { return }
        guard let currentGame = gameData?.getGameByKey(key: gamePlayData.gameKey) else { return }
        
        score.text = "ពិន្ទុ \(convertEngNumToKhNum(engNum: gamePlayData.score))"
        setLifeOfGame()
        questionOrder.text = "សំណួរទី\(convertEngNumToKhNum(engNum: gamePlayData.question))"
        question.text = getQuestion(level: gamePlayData.level,
                    numOfQuestion: gamePlayData.question)
        
        if self.gamePlay?.level.questions[gamePlayData.question - 1].possibleAnswer == nil {
            self.gamePlay?.level.questions[gamePlayData.question - 1].possibleAnswer = getPossiableAnswer(game: currentGame, level: gamePlayData.level.level, question: gamePlayData.question)
        } else {
            gamePlay?.level.questions[gamePlayData.question - 1].possibleAnswer?.shuffle()
        }
        
    }

    func setProgressTime() {
        progressBar.setAnimatedProgress(progress: 0, duration: 15){
            print("Done")
            self.switchToAnswerScreen()
        }
    }
    
    func switchToAnswerScreen() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        controller.gamePlay = gamePlay
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
    
    func switchToLevelScreen(game: Game){
        let controller = storyboard?.instantiateViewController(withIdentifier: "LevelViewController") as! LevelViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.game = game
        self.present(controller, animated: true)
    }
    
    

}



extension ReadingQuestionViewController: SettingViewDelegate {
    func quitGame() {
        guard let gamePlayData = gamePlay else { return }
        guard let game = gameData?.getGameByKey(key: gamePlayData.gameKey) else { return }
        
        switchToLevelScreen(game: game)
    }
     
    
    func dismissButton(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}
