//
//  DummyViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 26/9/23.
//

import UIKit
import Hero

class DummyViewController: UIViewController {

    @IBOutlet weak var brachNha: UIImageView!
    
//    private let gameCentehelper = GameCenterHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.switchToHomeScreen()
        }
    }
    
    func switchToHomeScreen(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        
        self.present(controller, animated: true)
    }
    


}
