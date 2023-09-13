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
    
    
    var active: PlayMode = .singlePlayerMode
    
    
    let settingView = SettingView()
    
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
            switchToAnotherScreen(game: data)
        }
    }
    
    @IBAction func khmerProverButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[1], sclaEffect: 0.9)
        print("Khmer Proverb")
        
        if let data = gameData?.Proverb {
            switchToAnotherScreen(game: data)
        }
    }
    @IBAction func generalKnowlage(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: gameButtonView[2], sclaEffect: 0.9)
        print("Khmer General Knowlate")
        if let data = gameData?.GeneralKnowlage {
            switchToAnotherScreen(game: data)
        }
        
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
//        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 326)
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 270)
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
    

    
    func switchToAnotherScreen(game: Game){
        let controller = storyboard?.instantiateViewController(withIdentifier: "LevelViewController") as! LevelViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        controller.game = game
        self.present(controller, animated: true)
    }
}

extension GameChoosingViewController: SettingViewDelegate {
    func quitGame() {}
    
    func dismissButton(_ view: UIView) {
        ViewAnimateHelper.shared.animateViewOut(self.view, popUpView: view)
    }
}

