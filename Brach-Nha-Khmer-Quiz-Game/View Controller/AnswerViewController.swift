//
//  AnswerViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 4/9/23.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var scoreCounting: UILabel!
    @IBOutlet var lifePlaying: [UIImageView]!
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var timeCountDown: UIProgressView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var hintAnswerButton: HintTellAnswerButton!
    @IBOutlet weak var hintHaftHaftButton: HintHalfHalfButton!
    @IBOutlet var answerView: [AnswerButton]!
    
    var gamePlay: GamePlay? = nil
    
    let sampleAnswer = [
        AnswerView(index: 0,title: "បារី", correctAnswer: "បារី"),
        AnswerView(index: 1, title: "ស្រា", correctAnswer: "បារី"),
        AnswerView(index: 2, title: "កណ្ឆារ", correctAnswer: "បារី"),
        AnswerView(index: 3, title: "កាហ្វេ", correctAnswer: "បារី")
    ]
    
    let durationOfAnimationInSecond = -5.0
    var incorrectAnswer = [AnswerButton]()
    var correctAnswer = AnswerButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameData()
        setupAnswerIntoButton()
        setProgressTime()
        
        hintAnswerButton.roundCorners(corners: [.bottomRight, .topRight], radius: 15)
        hintHaftHaftButton.roundCorners(corners: [.bottomLeft, .topLeft], radius: 15)
        
   
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(ActivateHintAnswerButton))
        let click = UITapGestureRecognizer(target: self, action: #selector(ActivateHintHalfHalfButton))
        hintAnswerButton.addGestureRecognizer(tab)
        hintHaftHaftButton.addGestureRecognizer(click)
        

//            curveAnimation(view: hintAnswerButton, animationOptions: .curveEaseIn, defaultXMovement: 240, isReset: isAnimated)
//            curveAnimation(view: hintHaftHaftButton, animationOptions: .curveEaseIn, defaultXMovement: 240, isReset: isAnimated)

    }
    
    func setLifeOfGame() {
        for life in 0..<(gamePlay?.fail ?? 0) {
            lifePlaying[life].isHidden = true
            
        }
    }
    
    func getQuestion(level: Level, numOfQuestion: Int) -> String{
        return level.questions[numOfQuestion-1].question
    }
    
    func setupGameData() {
        guard let gamePlayData = gamePlay else { return }
        
        scoreCounting.text = "ពិន្ទុ \(gamePlayData.score)"
        setLifeOfGame()
        questionNum.text = "សំណួរទី\(convertEngNumToKhNum(engNum: gamePlayData.question))"
        question.text = getQuestion(level: gamePlayData.level, numOfQuestion: gamePlayData.question)
        
    }

    
    
    func setProgressTime() {
        timeCountDown.setAnimatedProgress(progress: 0, duration: 45){
            print("Done")
        }
    }
    
    func setupAnswerIntoButton(){
        var index = 0
        for view in answerView {
            view.setup(data: sampleAnswer[index])
            view.delegate = self
            index += 1
        }
    }
    
    
    
    // set animation to hint
    
    @objc func ActivateHintAnswerButton() {
        print("Hint Answer Used!")
        curveAnimation(view: hintAnswerButton, animationOptions: .curveEaseOut, defaultXMovement: -240, isReset: false, completion: nil)
        
        for view in answerView {
            if view.checkCorrectAnswer() {
                ButtonEffectAnimation.shared.triggerRightAnswer(button: view)
            }
        }
    }
    
    @objc func ActivateHintHalfHalfButton() {
        print("Hint HalfHalf Used!")
        curveAnimation(view: hintHaftHaftButton, animationOptions: .curveEaseOut, defaultXMovement: 240, isReset: false, completion: nil)
        
        
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
    
//    func getIncorrectAnswer(data: [AnswerButton]) -> AnswerButton {
//        var btnThatClicables = data
//
//
//        return randomIncorrectAnswer ?? AnswerButton()
//    }
    
    func curveAnimation(view: UIView, animationOptions: UIView.AnimationOptions, defaultXMovement: CGFloat, isReset: Bool, completion: (() -> Void)? = nil) {
      UIView.animate(withDuration: durationOfAnimationInSecond, delay: 0, options: animationOptions, animations: {
        view.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
      }, completion: {_ in
          completion?()
      })
    }
    
    func transitionAnimation(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
      UIView.transition(with: view, duration: durationOfAnimationInSecond, options: animationOptions, animations: {
        view.backgroundColor = UIColor.init(named: isReset ? "darkGreen" :  "darkRed")
      }, completion: nil)
    }
    
    

    

}

extension AnswerViewController: AnswerButtonDelegate {
    func didSelect(index: Int, status: Bool) {
        print(index)
        
        if status==false {
            gamePlay?.fail += 1
            setLifeOfGame()
        }
    }
    
}

