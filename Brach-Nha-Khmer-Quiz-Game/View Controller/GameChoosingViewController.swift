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
        ViewAnimateHelper.shared.animateViewIn(self.view, popUpView: settingView, width: 320, height: 348)
    }
    
    @IBAction func storeButtonPressed(_ sender: UIButton) {
        storeButtonFunction()
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
    
    func storeButtonFunction() {
        if let currentUser = GoogleAuthenticationHelper().getCurrentUser() {
            self.gotoViewControllerWithoutParam(newController: StoreViewController())
            
        } else {
            self.gotoViewControllerWithoutParam(newController: LoginViewController())
        }
    }
    
    func setupSettingView() {
        settingView.delegate = self
        settingView.setup(type: .normal)
    }

}

extension GameChoosingViewController: SettingViewDelegate {
    func quitGame() {}
    
    func dismissButton(_ view: UIView) {
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

