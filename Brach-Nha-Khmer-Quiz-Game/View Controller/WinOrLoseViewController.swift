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
    
    var gamePlay: GamePlay? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findTotalTiming()
        setupTotalScore()
        displayMessages()
        setupHighestScore()

    }
    
    
    @IBAction func replayTapGesture(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: replayButton)
    }
    
    @IBAction func nextGameTapGesture(_ sender: Any) {
        ButtonEffectAnimation.shared.popEffect(button: nextGameButton)
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
    
    
    
    

   

}
