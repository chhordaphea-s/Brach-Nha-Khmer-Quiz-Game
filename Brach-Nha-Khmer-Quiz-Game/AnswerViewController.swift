//
//  AnswerViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 4/9/23.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var ScoreCounting: UILabel!
    @IBOutlet var lifePlaying: [UIImageView]!
    @IBOutlet weak var QuestionNum: UILabel!
    @IBOutlet weak var timeCountDown: UIProgressView!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var hintAnswerButton: HintTellAnswerButton!
    @IBOutlet weak var hintHaftHaftButton: HintHalfHalfButton!
    @IBOutlet var answerView: [AnswerButton]!
    
    let sampleAnswer = [
        AnswerView(index: 0,title: "បារី", correctAnswer: "បារី"),
        AnswerView(index: 1, title: "ស្រា", correctAnswer: "បារី"),
        AnswerView(index: 2, title: "កណ្ឆារ", correctAnswer: "បារី"),
        AnswerView(index: 3, title: "កាហ្វេ", correctAnswer: "បារី")
    ]
    
    var isAnimated : Bool = false
    let durationOfAnimationInSecond = -5.0
    var failureNumOfGame : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnswerIntoButton()
        setProgressTime()
        hintAnswerButton.delegate = self
        
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
        for life in 0..<failureNumOfGame {
            lifePlaying[life].isHidden = true
            
        }
    }
    
    func setProgressTime() {
        timeCountDown.setAnimatedProgress(progress: 0, duration: 50){
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
    
    func useHintAnswerForButton() {
        
    }
    
    
    
    
    // set animation to hint
    
    @objc func ActivateHintAnswerButton() {
        print("Hint Answer Used!")
        curveAnimation(view: hintAnswerButton, animationOptions: .curveEaseOut, defaultXMovement: -240, isReset: isAnimated)
        isAnimated.toggle()
        
        
    }
    
    @objc func ActivateHintHalfHalfButton() {
        print("Hint HalfHalf Used!")
        curveAnimation(view: hintHaftHaftButton, animationOptions: .curveEaseOut, defaultXMovement: 240, isReset: isAnimated)
        isAnimated.toggle()
    }
    
    
    func curveAnimation(view: UIView, animationOptions: UIView.AnimationOptions, defaultXMovement: CGFloat, isReset: Bool) {
      UIView.animate(withDuration: durationOfAnimationInSecond, delay: 0, options: animationOptions, animations: {
        view.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
      }, completion: nil)
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
            failureNumOfGame += 1
            setLifeOfGame()
        }
    }
    
}

extension AnswerViewController: HintAnswerButtonDelegate {
    func didSelect() {
        answerView[0].ha
    }
}
