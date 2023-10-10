//
//  AnswerViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 4/9/23.
//

import UIKit
import GoogleMobileAds
import Hero
import UIImageViewAlignedSwift

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageViewAligned!
    @IBOutlet weak var score: UILabel!
    @IBOutlet var lifePlaying: [UIImageView]!
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var timeCountDown: UIProgressView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var hintAnswerButton: HintTellAnswerButton!
    @IBOutlet weak var hintHaftHaftButton: HintHalfHalfButton!
    @IBOutlet var answerView: [AnswerButton]!
    
    
    private let lostView = LostView()
    private let settingView = SettingView()
    private let rewardAds = RewardedInterstitialAd()
    
    var gamePlay: GamePlay? = nil

    private let timer = TimerHelper()
    private var watchedAd = false
    private var choosedCorrectAnswer = false
    private let databaseHelper = DatabaseHelper()
    
    private var incorrectAnswer = [AnswerButton]()
    private var correctAnswer = AnswerButton()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideButton(views: answerView)
        hideHintButton()
        backgroundImage.animateBackgroundImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        question.hero.modifiers = [.translate(y:100), .scale(0.6)]
        
        setupGameData()
        setupSettingView()
        setupAnswerIntoButton()
        setupHintGesture()
        setupHint()
        setupTimer()
        
        rewardAds.adsLoads(controller: self)
        rewardAds.delegate = self
        
        lostView.delegate = self
       
        DispatchQueue.main.async {
            self.animateInAnswerButton(views: self.answerView)
            self.animateHintButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.reset()
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 348)
        ButtonEffectAnimation.shared.popEffect(button: sender)
    }
    // set animation to hint
    
    @objc func ActivateHintAnswerButton() {
        if choosedCorrectAnswer { return }

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
        if choosedCorrectAnswer { return }

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
    
    
    func setupHint() {
        guard let gamePlayData = gamePlay else { return }
        hintAnswerButton.roundCorners(corners: [.bottomRight, .topRight], radius: 15)
        hintHaftHaftButton.roundCorners(corners: [.bottomLeft, .topLeft], radius: 15)
        
        hintAnswerButton.setupData(data: HintButton(type: gamePlayData.answerHint.type,
                                                    num: gamePlayData.answerHint.num,
                                                    enable: gamePlayData.answerHint.enable))
        
        hintHaftHaftButton.setupData(data: HintButton(type: gamePlayData.halfhalfHint.type,
                                                      num: gamePlayData.halfhalfHint.num,
                                                      enable: gamePlayData.halfhalfHint.enable))
    }
    
    func setupHintGesture() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(ActivateHintAnswerButton))
        let click = UITapGestureRecognizer(target: self, action: #selector(ActivateHintHalfHalfButton))
        hintAnswerButton.addGestureRecognizer(tab)
        hintHaftHaftButton.addGestureRecognizer(click)
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
    
    func getQuestion(level: Level, numOfQuestion: Int) -> String {
        return level.questions[numOfQuestion-1].question
    }
    
    func setupGameData() {
        guard let gamePlayData = gamePlay else { return }
        
        score.text = "ពិន្ទុ \(convertEngNumToKhNum(engNum: gamePlayData.score))"
        setLifeOfGame()
        questionNum.text = "សំណួរទី\(convertEngNumToKhNum(engNum: gamePlayData.question))"
        question.text = getQuestion(level: gamePlayData.level, numOfQuestion: gamePlayData.question)
        
    }

    func setupTimer() {
        timer.setupTimer(duration: gamePlay?.answerTime ?? 0)
        timer.delegate = self
        timer.startCountDown()

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
        guard let gamePlayData = gamePlay else { return }
        gamePlay?.score += Int(timer.getTimerRemainder()) * gamePlayData.multiplyer

        setScore()
    }
    
    func hintHandler(hintType: HintType) {
        switch hintType {
        case .answer:
            gamePlay?.answerHint.enable = false
            gamePlay?.answerHint.num -= 1
            
        case .halfhalf:
            gamePlay?.halfhalfHint.enable = false
            gamePlay?.halfhalfHint.num -= 1

        }
        
        databaseHelper.updateHint(hintType: hintType, number: -1)

    }
    

  
    func switchToReadingQuestionScreen() {
        gamePlay?.question += 1
        guard let gamePlay = gamePlay else { return }
        self.gotoReadingQuestionViewController(data: gamePlay)
    }
    
    func reloadViewController() {
        watchedAd = false
        timer.reset()
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
    func switchToWinOrLoseScreen(){
        guard let gamePlayData = gamePlay else {return}
        
        gamePlay?.timings = Int(NSDate().timeIntervalSince(gamePlayData.startPlayTime))
        self.gotoWinOrLoseViewController(data: gamePlay)
    }

}

extension AnswerViewController: AnswerButtonDelegate {
    
    func didSelect(index: Int, status: Bool) {
//        guard let gamePlayData = gamePlay else {return}
        
        if choosedCorrectAnswer { return }
        
        print(index)
        if gamePlay?.fail ?? 0 >= 3 {
            return
        }
        
        
        if !status {
            performButtonVibrate(vibrateType: .error)
            if gamePlay?.fail ?? 0 < 2 {
                gamePlay?.fail += 1
            } else {
                timer.pause()

                gamePlay?.fail += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.lostView.animateViewIn(baseView: self.view, popUpView: self.lostView)
                }
            }
            setLifeOfGame()

            buttonSoudEffect = AudioHelper(audioName: "failed", loop: false)
            
        } else {
            choosedCorrectAnswer = true
            performButtonVibrate(vibrateType: .success)
            timer.pause()
            scoreCounting()
            
            buttonSoudEffect = AudioHelper(audioName: "correct", loop: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.gamePlay?.question ?? 0 < 5 {
                    self.switchToReadingQuestionScreen()
                }
                else {
                    self.gamePlay?.question += 1
                    self.switchToWinOrLoseScreen()
                }
            }
        
        }
    }
    
    func setupAlert() {
        let alert = UIAlertController(title: "ផ្ទាំងពានិជ្ជកម្ម", message: "សូមអធ្យាស្រ័យ! យើការផ្សាយពានិជ្ជកម្មរបស់យើងមានបញ្ហាបច្ចេកទេស។", preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "យល់ព្រម", style: .cancel) { sender in
            self.switchToWinOrLoseScreen()
        }
        
        alert.addAction(alertButton)
        self.present(alert, animated: true)
    }
    
    
}


// MARK: - Delegate

extension AnswerViewController: SettingViewDelegate {
    func logout() {
        self.gotoViewControllerWithoutParam(newController: LoginViewController())
    }
    
    func quitGame() {

        let alert = UIAlertController(title: "ចាកចេញ", message: "តើអ្នក់ចង់បោះបង់មែនទេ?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "មិនយល់ព្រម", style: .cancel)
        let action = UIAlertAction(title: "យល់ព្រម", style: .destructive) { _ in
            guard let gamePlayData = self.gamePlay else { return }
            guard let game = gameData?.getGameByKey(key: gamePlayData.gameKey) else { return }
            
            self.gotoLevelViewController(data: game)

        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func dismissButton(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}

extension AnswerViewController: LostViewDelegate {
    func gotoFinishScreen() {
        switchToWinOrLoseScreen()
    }
    
    func displayAds() {
        lostView.animateViewOut(baseView: self.view, popUpView: lostView)
        rewardAds.displayAds(controller: self)
    }
    
    
}

// MAKR: InterstitialAds
extension AnswerViewController: RewardedInterstitialAdDelegate {
    func errorConnection() {
        switchToWinOrLoseScreen()
    }
    
    func adLoaded(status: Bool) {
        if status {
            watchedAd = true
        } else {
            setupAlert()
        }
    }
    
    func adError(error: Error) {
        setupAlert()
    }
    
    func dismissScreen() {
        if watchedAd {
            self.gamePlay?.fail -= 1
            reloadViewController()
        } else {
            gotoFinishScreen()
        }
    }
    
    
}

extension AnswerViewController: TimerHelperDelegate {
    func loadTimer(timer: Timer, progress: Float) {
        timeCountDown.setProgress(progress, animated: true)
    }
    
    func didLoadTimer(timer: Timer) {
        if self.gamePlay?.fail ?? 0 < 2 {
            self.gamePlay?.fail += 1

            buttonSoudEffect = AudioHelper(audioName: "failed")

            self.reloadViewController()
        } else {
            self.gamePlay?.fail += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                self.lostView.animateViewIn(baseView: self.view, popUpView: self.lostView)
            }
        }
    }
    
    
}
