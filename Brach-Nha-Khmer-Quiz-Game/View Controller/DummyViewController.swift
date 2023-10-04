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
    
    let db = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.loadData()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.gotoViewControllerWithoutParam(newController: MainViewController())
        }
    }

}
