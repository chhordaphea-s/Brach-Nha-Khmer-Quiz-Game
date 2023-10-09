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
        if !Reachability.isConnectedToNetwork() {
            setupAlert(self)
        } else {
            auth.signIn(baseVeiw: self)

        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "ចុះឈ្មោះ", message: "ទិន្នន័យរបស់អ្នកនឹងត្រូវបានរក្សាទុកនៅក្នុងទូរស័ព្ទរបស់អ្នក", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "មិនយល់ព្រម", style: .cancel)
        let action = UIAlertAction(title: "យល់ព្រម", style: .destructive) { _ in
            self.db.loadData()
            self.gotoViewControllerWithoutParam(newController: MainViewController())
        }
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func setupAlert(_ controller: UIViewController) {
        let alert = UIAlertController(title: "ការតភ្ជាប់", message: "ឧបករណ៍របស់អ្នកមិនបានតភ្ជាប់ជាមួយបណ្ដាញទេ", preferredStyle: .alert)
        let button = UIAlertAction(title: "ទទួលបាន", style: .cancel)
        alert.addAction(button)
        controller.present(alert, animated: true)
    }

    
}

extension LoginViewController: GoogleAuthenticationHelperDelegate {
    func reAuthenticate(user: User?, error: Error?) { }
    
    func signInSuccess(user: User) {
        FirestoreHelper.shared.fetchData(userID: user.uid) { (error) in
            if error != nil {
                print("error: ", error?.localizedDescription)
                return
            }
            self.gotoViewControllerWithoutParam(newController: MainViewController())

        }
    }

}
