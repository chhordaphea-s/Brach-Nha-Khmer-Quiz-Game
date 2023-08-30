//
//  ViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 17/8/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var playButton: UIView!
    @IBOutlet var scoreBackground: [UIStackView]!
    
    // MARK: - Body
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizePlayButton()
        customizeScoreBoard()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playButtonActive))
        playButton.addGestureRecognizer(tap)
    }
    
    @objc func playButtonActive() {
        print("Play available!")
        
        playButtonEffect()
        switchToAnotherScreen()
        
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
        self.present(controller, animated: true, completion: nil)
    }

    
    
   

}

