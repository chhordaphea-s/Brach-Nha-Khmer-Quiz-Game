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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.gotoViewControllerWithoutParam(newController: MainViewController())
        }
    }

}
