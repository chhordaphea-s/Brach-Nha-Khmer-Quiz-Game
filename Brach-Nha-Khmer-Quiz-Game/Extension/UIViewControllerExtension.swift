//
//  UIViewControllerExtension.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/29/23.
//

import UIKit

extension UIViewController {
    
    func gotoViewControllerWithoutParam(newController: UIViewController) {

        var controller = UIViewController()
        
        switch newController {
            
        case is GameChoosingViewController:
            controller = storyboard?.instantiateViewController(withIdentifier: "\(GameChoosingViewController.self)") as! GameChoosingViewController
            
        case is MainViewController:
            controller = storyboard?.instantiateViewController(withIdentifier: "\(MainViewController.self)") as! MainViewController
            
        case is StoreViewController:
            controller = storyboard?.instantiateViewController(withIdentifier: "\(StoreViewController.self)") as! StoreViewController
            
        default:
            return
        }
        
        presentToAnotherController(newController: controller)
    }
    
    func gotoAnswerViewController(data: GamePlay) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(AnswerViewController.self)") as! AnswerViewController
        controller.gamePlay = data
        presentToAnotherController(newController: controller)
    }
        
    func gotoLevelViewController(data: Game) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(LevelViewController.self)") as! LevelViewController
        controller.game = data
        presentToAnotherController(newController: controller)
    }
    
    func gotoReadingQuestionViewController(data: GamePlay) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(ReadingQuestionViewController.self)") as! ReadingQuestionViewController
        controller.gamePlay = data
        presentToAnotherController(newController: controller)
    }
    
    func gotoWinOrLoseViewController(data: GamePlay?) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(WinOrLoseViewController.self)") as! WinOrLoseViewController
        controller.gamePlay = data
        presentToAnotherController(newController: controller)
    }
    
    
    
    private func presentToAnotherController(newController: UIViewController) {

        newController.modalPresentationStyle = .fullScreen
        newController.modalTransitionStyle = .crossDissolve
        self.present(newController, animated: true)
    }
    
}





