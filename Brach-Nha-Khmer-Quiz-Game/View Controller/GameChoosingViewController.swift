//
//  GameChoosingViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/18/23.
//

import Foundation
import UIKit

class GameChoosingViewController: UIViewController {
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet var gameButtonView: [UIView]!
    @IBOutlet weak var playerModeSagementControl: ChoosePlayerModeCustomSagement!
    
    
    private var active: PlayMode = .singlePlayerMode
    
    
    private let settingView = SettingView()
    
    // MARK: - BODY

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeGameButton()
        setupSettingView()
        
    }
    
    // MARK: BUTTON

    @IBAction func riddleButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[0], sclaEffect: 0.9)
        print("Khmer Riddle")
        
        if let data = gameData?.Riddle {
            self.gotoLevelViewController(data: data)
        }
    }
    
    @IBAction func khmerProverButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[1], sclaEffect: 0.9)
        print("Khmer Proverb")
        
        if let data = gameData?.Proverb {
            self.gotoLevelViewController(data: data)
        }
    }
    @IBAction func generalKnowlage(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[2], sclaEffect: 0.9)
        print("Khmer General Knowlate")
        if let data = gameData?.GeneralKnowledge {
            self.gotoLevelViewController(data: data)
        }
        
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
//        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 326)
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 270)
    }
    
    @IBAction func storeButtonPressed(_ sender: UIButton) {
        self.gotoViewControllerWithoutParam(newController: StoreViewController())
    }
    
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            self.gotoViewControllerWithoutParam(newController: MainViewController())
        default:
            return
        }
    }
    
    // MARK: - Function
    private func customizeGameButton() {
        let colors = [0xCBF5D6, 0xCBEDF5, 0xF5CAEF]
        var index = 0
        for b in gameButtonView {
            
            b.addBorder(to: .bottom, color: UIColor(rgb: colors[index]), thickness: 3.0)
            index += 1
        }
    }

    
    func setupSettingView() {
        settingView.delegate = self
        settingView.setup(type: .normal)
//        settingView.setup(type: .playing)
    }

}

extension GameChoosingViewController: SettingViewDelegate {
    func quitGame() {}
    
    func dismissButton(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}

