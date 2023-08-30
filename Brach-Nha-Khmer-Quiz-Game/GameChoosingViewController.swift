//
//  GameChoosingViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/18/23.
//

import Foundation
import UIKit

class GameChoosingViewController: UIViewController {
    
    @IBOutlet var gameBackgroundView: [UIView]!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet var gameButtonView: [UIView]!

    @IBOutlet weak var playerModeSagementControl: ChoosePlayerModeCustomSagement!
    
    
    var active: PlayMode = .singlePlayerMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeGameButton()

        
    }

    
    // MARK: - Function
    private func customizeGameButton() {
        let colors = [0xCBF5D6, 0xCBEDF5, 0xF5CAEF]
        var index = 0
        for b in gameBackgroundView {
            
            b.addBorder(to: .bottom, color: UIColor(rgb: colors[index]), thickness: 3.0)
            index += 1
        }
    }

    

    
    
    @IBAction func riddleButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[0], sclaEffect: 0.9)
        print("Khmer Riddle")
        switchToAnotherScreen()
    }
    
    @IBAction func khmerProverButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[1], sclaEffect: 0.9)
        print("Khmer Proverb")
        switchToAnotherScreen()
    }
    @IBAction func generalKnowlage(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[2], sclaEffect: 0.9)
        print("Khmer General Knowlate")
        switchToAnotherScreen()
        
    }
    
    
    
    func moveIt(_ imageView: UIImageView,_ speed:CGFloat) {
        let speeds = speed
        let imageSpeed = speeds / view.frame.size.width
        let averageSpeed = (view.frame.size.width - imageView.frame.origin.x) * imageSpeed
        UIView.animate(withDuration: TimeInterval(averageSpeed), delay: 0.0, options: .curveLinear, animations: {
            imageView.frame.origin.x = self.view.frame.size.width
        }, completion: { (_) in
            imageView.frame.origin.x = -imageView.frame.size.width
            self.moveIt(imageView,speeds)
        })
    }
    
    func switchToAnotherScreen(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "LevelViewController") as! LevelViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
}
