//
//  ViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 17/8/23.
//

import UIKit
import GoogleMobileAds
import UIImageViewAlignedSwift

class MainViewController: UIViewController {

    @IBOutlet weak var playButton: UIView!
    @IBOutlet var scoreBackground: [UIStackView]!
    @IBOutlet var score: [UILabel]!
    @IBOutlet weak var brachNha: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageViewAligned!
    
    private let settingView = SettingView()
    private let hintView = HintPopupView()
    private let playButtonPressed = UITapGestureRecognizer()
    
    private let databaseHelper = DatabaseHelper()    
    private var firstOpen = true
    // MARK: - Body

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideButton(views: scoreBackground)
        getScore()
        backgroundImage.animateBackgroundImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.animateScoreBoard(views: self.scoreBackground)
            self.giveHint()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.isEnabled = true
        brachNha.hero.modifiers = [.translate(y:100)]
        
        ButtonEffectAnimation.shared.triggerRightAnswer(button: playButton)

        customizePlayButton()
        customizeScoreBoard()
        setupSettingView()

        playButtonPressed.addTarget(self, action: #selector(playButtonActive))
        playButton.addGestureRecognizer(playButtonPressed)
                
    }
    
    
    // MARK: BUTTON
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 348)
    }
    
    @IBAction func storeButtonPressed(_ sender: UIButton) {
        storeButtonFunction()
    }
    
    @objc func playButtonActive() {
        print("Play available!")
        playButtonEffect()
        self.gotoViewControllerWithoutParam(newController: GameChoosingViewController())
    }
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            storeButtonFunction()
        default:
            return
        }
    }
    
    func storeButtonFunction() {
        if GoogleAuthenticationHelper().getCurrentUser() != nil {
            self.gotoViewControllerWithoutParam(newController: StoreViewController())
            
        } else {
            self.gotoViewControllerWithoutParam(newController: LoginViewController())
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
    
    func giveHint() {
        if databaseHelper.getFirstDate() == nil {
            hintView.delegate = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.increaseHint(hint: .answer)
            }
            
            databaseHelper.setFirstDate(date: Date())
        } else {
            firstOpen = false
        }
    }
    
    func increaseHint(hint: HintType) {
        hintView.setup(data: Hint(hinType: hint, number: 3))
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: hintView, width: 314, height: 276, tapBackground: false)
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
    
    func logout() {
        
        if let currentUser = GoogleAuthenticationHelper().getCurrentUser() {
            let alert = UIAlertController(title: "ចាកចេញ", message: "តើអ្នកប្រាកដជាចង់ចាកចេញពីគណនីនេះមែនទេ?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "មិនយល់ព្រម", style: .cancel)
            let action = UIAlertAction(title: "យល់ព្រម", style: .destructive) { _ in
                GoogleAuthenticationHelper().signOut() {
                    self.gotoViewControllerWithoutParam(newController: LoginViewController())
                }

            }
            
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        } else {
            self.gotoViewControllerWithoutParam(newController: LoginViewController())
        }
    }
}


extension MainViewController: HintPopupViewDelegate {
    func dismissHintView(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
        getScore()
        
        if firstOpen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.increaseHint(hint: .halfhalf)
                self.firstOpen = false
            }
        }
    }
    
    
}
