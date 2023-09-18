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

    
    let settingView = SettingView()
    let playButtonPressed = UITapGestureRecognizer()
    
    private var interstitial: GADInterstitialAd?

    let lostView = LostView()

    // MARK: - Body
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScore()
        adsLoads()

        customizePlayButton()
        customizeScoreBoard()
        setupSettingView()

        playButtonPressed.addTarget(self, action: #selector(playButtonActive))
        playButton.addGestureRecognizer(playButtonPressed)
        
        lostView.delegate = self
        
    }
    
    
    // MARK: BUTTON
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 270)
    }
    
    @IBAction func storeButtonPressed(_ sender: UIButton) {
        switchToStoreViewController()
    }
    
    @objc func playButtonActive() {
        print("Play available!")
        playButtonEffect()
        switchToAnotherScreen()
        
        
    }
    @IBAction func inAppPhurcheaseButtonPressed(_ sender: UIButton) {
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: lostView, width: 282, height: 396)
    }
    
    // MARK: FUNCTION
    
    func adsLoads() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                              return
                            }
                            interstitial = ad
                          }
        )
    }
    
    func getScore() {
        let scoreUD = [totalScore, totalStar, answerHint, halfHint]
        
        var index: Int = 0
        for l in score {
            l.text = "\(scoreUD[index])"
            index += 1
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

    func customizeScoreBoard(){
        for view in scoreBackground {
            view.isLayoutMarginsRelativeArrangement = true
            
            view.layer.cornerRadius = view.frame.size.height / 2
            view.layer.masksToBounds = true
            
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
        }
        
    }
    
    func switchToAnotherScreen(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "GameChoosingViewController") as! GameChoosingViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
        
    }
    
    func switchToStoreViewController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "BuyHintViewController") as! StoreViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.backDirection = self
        self.present(controller, animated: true)
    }
  

}

extension MainViewController: SettingViewDelegate {
    func quitGame() {}
    
    func dismissButton(_ view: UIView)  {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}


extension MainViewController: LostViewDelegate {
    func displayAds() {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }
    
    
}
