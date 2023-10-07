//
//  LoginViewController.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/5/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    let auth = GoogleAuthenticationHelper()
    let db = DatabaseHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth.delegate = self
        
    }

    @IBAction func signInButtonPressGesture(_ sender: UITapGestureRecognizer) {
        auth.signIn(baseVeiw: self)
    }
    
    
    
    
}

extension LoginViewController: GoogleAuthenticationHelperDelegate {
    func reAuthenticate(user: User?, error: Error?) { }
    
    func signInSuccess(user: User) {
        FirestoreHelper.shared.fetchData(userID: user.uid) { (error) in
            FirestoreHelper.shared.startSync()
            self.gotoViewControllerWithoutParam(newController: MainViewController())

        }
    }

}
