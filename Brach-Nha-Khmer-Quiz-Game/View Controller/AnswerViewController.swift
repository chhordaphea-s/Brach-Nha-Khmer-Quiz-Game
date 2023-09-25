//
//  AnswerViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 4/9/23.
//

import UIKit
import GoogleMobileAds


class AnswerViewController: UIViewController {
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var score: UILabel!
    @IBOutlet var lifePlaying: [UIImageView]!
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var timeCountDown: UIProgressView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var hintAnswerButton: HintTellAnswerButton!
    @IBOutlet weak var hintHaftHaftButton: HintHalfHalfButton!
    @IBOutlet var answerView: [AnswerButton]!
    
    let lostView = LostView()
    
    var gamePlay: GamePlay? = nil
    let settingView = SettingView()
    var watchedAd = false
    
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?

    
    var incorrectAnswer = [AnswerButton]()
    var correctAnswer = AnswerButton()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideButton(views: answerView)
        hideHintButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGameData()
        setupSettingView()
        setupAnswerIntoButton()
        setProgressTime()
        setupHint()
        adsLoads()
        
        lostView.delegate = self

        hintAnswerButton.roundCorners(corners: [.bottomRight, .topRight], radius: 15)
        hintHaftHaftButton.roundCorners(corners: [.bottomLeft, .topLeft], radius: 15)
        
   
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(ActivateHintAnswerButton))
        let click = UITapGestureRecognizer(target: self, action: #selector(ActivateHintHalfHalfButton))
        hintAnswerButton.addGestureRecognizer(tab)
        hintHaftHaftButton.addGestureRecognizer(click)
        

        DispatchQueue.main.async {
            self.animateInAnswerButton(views: self.answerView)
            self.animateHintButton()
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 348)
        ButtonEffectAnimation.shared.popEffect(button: sender)
    }
    
    func setupHint() {
        guard let gamePlayData = gamePlay else { return }
        
        hintAnswerButton.setupData(data: HintButton(type: gamePlayData.answerHint.type, 
                                                    num: gamePlayData.answerHint.num,
                                                    enable: gamePlayData.answerHint.enable))
        
        hintHaftHaftButton.setupData(data: HintButton(type: gamePlayData.halfhalfHint.type, 
                                                      num: gamePlayData.halfhalfHint.num,
                                                      enable: gamePlayData.halfhalfHint.enable))
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
    
    func resetLifeOfGame() {
        for life in 0..<(lifePlaying.count) {
            lifePlaying[life].isHidden = false
        }
    }
    
    func getQuestion(level: Level, numOfQuestion: Int) -> String{
        return level.questions[numOfQuestion-1].question
    }
    
    func setupGameData() {
        guard let gamePlayData = gamePlay else { return }
        
        score.text = "ពិន្ទុ \(convertEngNumToKhNum(engNum: gamePlayData.score))"
        setLifeOfGame()
        questionNum.text = "សំណួរទី\(convertEngNumToKhNum(engNum: gamePlayData.question))"
        question.text = getQuestion(level: gamePlayData.level, numOfQuestion: gamePlayData.question)
        
    }


    
    func setProgressTime() {
        timeCountDown.setAnimatedProgress(progress: 0, duration: 50){
            if self.gamePlay?.fail ?? 0 < 2 {
                self.gamePlay?.fail += 1
            } else {
                self.gamePlay?.fail += 1
                DispatchQueue.main.asyncAfter(deadline: .now()+2 ) {
                    self.lostView.animateViewIn(baseView: self.view, popUpView: self.lostView)
                }
            }
            self.reloadViewController()
        }
    }
    
    func setupAnswerIntoButton(){
        guard let gamePlayData = gamePlay else { return }
        guard let possibleAnswer = gamePlayData.level.questions[gamePlayData.question-1].possibleAnswer else { return }
        let correctAnswer = gamePlayData.level.questions[gamePlayData.question-1].answer
        var index = 0
        
        for view in answerView {
            view.setup(data: AnswerView(index: index,
                                        title: possibleAnswer[index],
                                        correctAnswer: correctAnswer) )
            view.delegate = self
            index += 1
            
        }
    }

    
    // set animation to hint
    
    @objc func ActivateHintAnswerButton() {
        print("Hint Answer Used!")
        curveAnimation(view: hintAnswerButton, animationOptions: .curveEaseOut, defaultXMovement: -240, isReset: false, completion: nil)
        hintHandler(hintType: .answer)
        
        for view in answerView {
            if view.checkCorrectAnswer() {
                ButtonEffectAnimation.shared.triggerRightAnswer(button: view)
            }
        }
    }
    
    @objc func ActivateHintHalfHalfButton() {
        print("Hint HalfHalf Used!")
        curveAnimation(view: hintHaftHaftButton, animationOptions: .curveEaseOut, defaultXMovement: 240, isReset: false, completion: nil)
        hintHandler(hintType: .halfhalf)
        
        for view in answerView {
            if !view.checkCorrectAnswer() {
                incorrectAnswer.append(view)
            }
            else {
                correctAnswer = view
            }
        }
                
        for view in incorrectAnswer {
            if !view.isEnable {
                incorrectAnswer.removeAll(where: { $0 == view })
            }
        }
                
        let randomIncorrectAnswer = incorrectAnswer.randomElement()
        
        var xMovement:CGFloat = 400

        if incorrectAnswer.count == 1 {
            for each in answerView {
                if each != correctAnswer {
                    if each.isEnable {
                        curveAnimation(view: each, animationOptions: .curveEaseOut, defaultXMovement: xMovement, isReset: false, completion: {
                            each.isHidden = false
                        })
                        
                    }
                }
            }
        } else {
            for each in answerView {
                if each != randomIncorrectAnswer && each != correctAnswer {
                    if each.isEnable {
                        curveAnimation(view: each, animationOptions: .curveEaseOut, defaultXMovement: xMovement, isReset: false, completion: {
                            each.isHidden = false
                        })
                        xMovement *= -1

                        
                    }
                }
                
            }
        }
        

        
    }
    
    // MARK: - functions
    
    func curveAnimation(view: UIView, animationOptions: UIView.AnimationOptions, defaultXMovement: CGFloat, isReset: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: -0.5, delay: 0, options: animationOptions, animations: {
        view.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
      }, completion: {_ in
          completion?()
      })
    }
    
    func animateInAnswerButton(views: [UIView]) {
        let screenWidth = UIScreen.main.bounds.width
        let location = (screenWidth - view.frame.width) / 4
        
        for i in 0..<4 {
            let sec: Double = Double(i) * 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                views[i].isHidden = false
                self.curveAnimation(view: views[i], animationOptions: .curveEaseIn, defaultXMovement: location, isReset: false)
            }
        }
    }
        
    func hideButton(views: [UIView]) {
        let screenWidth = UIScreen.main.bounds.width
        for view in views {
            curveAnimation(view: view, animationOptions: .curveEaseOut, defaultXMovement: screenWidth, isReset: false)
            view.isHidden = true

        }
    }
    
    func hideHintButton() {
        curveAnimation(view: hintHaftHaftButton, animationOptions: .curveEaseOut, defaultXMovement: UIScreen.main.bounds.width + 10, isReset: false)
        curveAnimation(view: hintAnswerButton, animationOptions: .curveEaseOut, defaultXMovement: -300, isReset: false)
        
    }
    
    func animateHintButton() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.curveAnimation(view: self.hintHaftHaftButton, animationOptions: .curveEaseIn, defaultXMovement: 0, isReset: false)
            self.curveAnimation(view: self.hintAnswerButton, animationOptions: .curveEaseIn, defaultXMovement: 0, isReset: false)
        }
        
    }
    
    func setScore() {
        guard let gamePlayData = gamePlay else { return }
        
        score.text = "ពិន្ទុ \(convertEngNumToKhNum(engNum: gamePlayData.score))"
    }
    
    func scoreCounting() {
        gamePlay?.score += timeCountDown.timeRemainder(duration: 50) * 4
        print(timeCountDown.timeRemainder(duration: 50))
        setScore()
    }
    
    func hintHandler(hintType: HintType) {
        switch hintType {
        case .answer:
            gamePlay?.answerHint.enable = false
            gamePlay?.answerHint.num -= 1
            
            userdefault.set(gamePlay?.answerHint.num, forKey: Constant.userdefault.answerHint)
        case .halfhalf:
            gamePlay?.halfhalfHint.enable = false
            gamePlay?.halfhalfHint.num -= 1
            
            userdefault.set(gamePlay?.halfhalfHint.num, forKey: Constant.userdefault.halfHint)
        default:
                return
        }
    }
    
    
    func switchToAnotherScreen(game: Game){
        let controller = storyboard?.instantiateViewController(withIdentifier: "LevelViewController") as! LevelViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.game = game
        self.present(controller, animated: true)
    }
    
  
    func switchToReadingQuestionScreen() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ReadingQuestionViewController") as! ReadingQuestionViewController
        
        gamePlay?.question += 1
        controller.gamePlay = gamePlay
    
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
    
    func reloadViewController() {
        incorrectAnswer = [AnswerButton]()
        correctAnswer = AnswerButton()
        timeCountDown.setProgress(1, animated: true)
        resetLifeOfGame()
        
        for v in answerView {
            v.reset()
        }
        
        viewWillAppear(true)
        viewDidLoad()
    }

}

extension AnswerViewController: AnswerButtonDelegate {
    
    func didSelect(index: Int, status: Bool) {
        print(index)
        if gamePlay?.fail ?? 0 >= 3 {
            return
        }
        
        if !status {
            
            if gamePlay?.fail ?? 0 < 2 {
                gamePlay?.fail += 1
            } else {
                gamePlay?.fail += 1
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.lostView.animateViewIn(baseView: self.view, popUpView: self.lostView)
                }
            }
            setLifeOfGame()

            
            buttonSoudEffect = AudioHelper(audioName: "failed", loop: false)
            buttonSoudEffect.player?.volume = 100
            buttonSoudEffect.player?.play()
            
        } else {
            
            
            scoreCounting()
            
            buttonSoudEffect = AudioHelper(audioName: "correct", loop: false)
            buttonSoudEffect.player?.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                if self.gamePlay?.question ?? 0 <= 5 {
                    self.switchToReadingQuestionScreen()
                }
            }
        
        }
    }
    
    
    
}

extension AnswerViewController: SettingViewDelegate {
    func quitGame() {
        guard let gamePlayData = gamePlay else { return }
        guard let game = gameData?.getGameByKey(key: gamePlayData.gameKey) else { return }
        
        switchToAnotherScreen(game: game)
    }
    
    func dismissButton(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}

extension AnswerViewController: LostViewDelegate {
    func displayAds() {
        lostView.animateViewOut(baseView: self.view, popUpView: lostView)
        displayAds(controller: self)
    }
    
    
}

// MAKR: InterstitialAds
extension AnswerViewController {
    
    func adsLoads() {
        GADRewardedInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/6978759866",
                                       request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            
            self.rewardedInterstitialAd = ad
            self.rewardedInterstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func displayAds(controller: UIViewController) {
        
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
          return print("Ad wasn't ready.")
        }

        rewardedInterstitialAd.present(fromRootViewController: self) {
            _ = rewardedInterstitialAd.adReward
            self.watchedAd = true
            self.gamePlay?.fail -= 1
        }
    }
}


extension AnswerViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
        print("Error: ", error)
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        
        if watchedAd {
            self.reloadViewController()
        } else {
            guard let gameD = gameData else { return }
            guard let gamePlayData = gamePlay else { return }
            switchToAnotherScreen(game: gameD.getGameByKey(key: gamePlayData.gameKey)!)
        }
    }
}
