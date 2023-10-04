//
//  ViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 17/8/23.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {

    @IBOutlet weak var playButton: UIView!
    @IBOutlet var scoreBackground: [UIStackView]!
    @IBOutlet var score: [UILabel]!
    @IBOutlet weak var brachNha: UIImageView!
    
    private let settingView = SettingView()
    private let playButtonPressed = UITapGestureRecognizer()
    
    let databaseHelper = DatabaseHelper()

    // MARK: - Body

    override func viewDidLoad() {
        super.viewDidLoad()
        hideButton(views: scoreBackground)

        self.navigationController?.hero.isEnabled = true
        brachNha.hero.modifiers = [.translate(y:100)]
        
        ButtonEffectAnimation.shared.triggerRightAnswer(button: playButton)

        getScore()

        customizePlayButton()
        customizeScoreBoard()
        setupSettingView()

        playButtonPressed.addTarget(self, action: #selector(playButtonActive))
        playButton.addGestureRecognizer(playButtonPressed)
        
        
        DispatchQueue.main.async {
            self.animateScoreBoard(views: self.scoreBackground)
        }
        
    }
    
    
    // MARK: BUTTON
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 270)
    }
    
    @IBAction func storeButtonPressed(_ sender: UIButton) {
        self.gotoViewControllerWithoutParam(newController: StoreViewController())
    }
    
    @objc func playButtonActive() {
        print("Play available!")
        playButtonEffect()
        self.gotoViewControllerWithoutParam(newController: GameChoosingViewController())
    }
    @IBAction func swapBack(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            self.dismiss(animated: true)
        default:
            return
        }
    }
    
    
    // MARK: FUNCTION
    func getScore() {
        let userData = databaseHelper.fetchData()
        guard let answerHint = userData.hint?.answerHint?.number else { return }
        guard let halfHint = userData.hint?.halfHint?.number else { return }
        
        let scoreUD = [databaseHelper.getTotalScore(),
                       databaseHelper.getTotalStar(),
                       answerHint,
                       halfHint]
        
        var index: Int = 0
        for l in score {
            l.text = "\(convertEngNumToKhNum(engNum: scoreUD[index]))"
            index += 1
        }
    }
    
    func hideButton(views: [UIView]) {
        let screenWidth = UIScreen.main.bounds.width
        for view in views {
            curveAnimation(view: view, animationOptions: .curveEaseOut, defaultXMovement: screenWidth, isReset: false)
            view.isHidden = true

        }
    }
    
    func curveAnimation(view: UIView, animationOptions: UIView.AnimationOptions, defaultXMovement: CGFloat, isReset: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: -0.5, delay: 0, options: animationOptions, animations: {
        view.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
      }, completion: {_ in
          completion?()
      })
    }
    
    func animateScoreBoard(views: [UIView]) {
        let screenWidth = UIScreen.main.bounds.width
        let location = (screenWidth - view.frame.width)
        
        for i in 0..<views.count {
            let sec: Double = Double(i) * 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                views[i].isHidden = false
                self.curveAnimation(view: views[i], animationOptions: .curveEaseIn, defaultXMovement: location, isReset: false)
            }
        }
    }
    
    func customizeScoreBoard(){
        for view in scoreBackground {
            view.isLayoutMarginsRelativeArrangement = true
            
            view.layer.cornerRadius = view.frame.size.height / 2
            view.layer.masksToBounds = true
            
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
        }
        
    }

    
    func setupSettingView() {
        settingView.delegate = self
        settingView.setup(type: .normal)
    }
    
    func playButtonEffect() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.playButton.alpha = 1
            self.playButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                self.playButton.alpha = 1
                // Pop in the view by scaling it up to it's original size
                self.playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        })
    }
    
    func customizePlayButton (){
        playButton.layer.cornerRadius = 27
        playButton.layer.borderColor = UIColor(rgb: 0x84B604).cgColor
        playButton.layer.borderWidth = 2
        playButton.layer.masksToBounds = true
    }

}

extension MainViewController: SettingViewDelegate {
    func quitGame() {}
    
    func dismissButton(_ view: UIView)  {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}


