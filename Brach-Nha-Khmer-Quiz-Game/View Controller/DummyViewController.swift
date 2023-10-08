//
//  DummyViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 26/9/23.
//

import UIKit
import Hero
import FirebaseAuth

class DummyViewController: UIViewController {


    @IBOutlet weak var brachNha: UIImageView!
    
    let db = DatabaseHelper()
    let auth = GoogleAuthenticationHelper()

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        auth.reAuthenticate()
        auth.delegate = self

    }
    

}

extension DummyViewController: GoogleAuthenticationHelperDelegate {
    func signInSuccess(user: User) { }
        
    func reAuthenticate(user: User?, error: Error?) {
        
        if user != nil {
            guard let user = user else { return }
            
            FirestoreHelper.shared.fetchData(userID: user.uid) {error in 
                self.gotoViewControllerWithoutParam(newController: MainViewController())
            }

        } else {
            if db.isEmpty() {
                self.gotoViewControllerWithoutParam(newController: LoginViewController())
            } else {
                self.gotoViewControllerWithoutParam(newController: MainViewController())
            }
        }
    }
    
    
}
