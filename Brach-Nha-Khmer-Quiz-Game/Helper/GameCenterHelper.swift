//
//  GameCenterHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/2/23.
//


import UIKit
import GameKit
import FirebaseAuth

class AuthenticateHelper : NSObject, GKGameCenterControllerDelegate {
    
    static let shareInstance = AuthenticateHelper()
    
    /// dismiss when game centre view did finished
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    /// auth the player
    func authPlayer (){
        //        let localPlayer = GKLocalPlayer.local
        //        let topViewController = UIApplication.getTopViewController()
        //        localPlayer.authenticateHandler = { (view, error) in
        //            if view != nil{
        //                topViewController!.present(view!, animated: true)
        //            }
        //            else {
        //                print(GKLocalPlayer.local.isAuthenticated)
        //                self.authenticateWithFirebase()
        //            }
        //        }
        
        
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { (vc, error) in
            if let view = vc {
                UIApplication.getTopViewController()?.present(view, animated: true)
                
            } else if localPlayer.isAuthenticated {
                
                print(GKLocalPlayer.local.isAuthenticated)
                self.authenticateWithFirebase()
                
            } else {
                print("Error: ", error?.localizedDescription ?? "Error")
                self.setupErrorAlert(error: error!)
            }
        }
        
        
        
    }
    
    func authenticateWithFirebase() {
        
        // Get Firebase credentials from the player's Game Center credentials
        GameCenterAuthProvider.getCredential() { (credential, error) in
            if let error = error {
                self.setupErrorAlert(error: error)
                
                return
            }
            // The credential can be used to sign in, or re-auth, or link or unlink.
            Auth.auth().signIn(with:credential!) { (user, error) in
                if let error = error {
                    return
                }
                if let user = user {
                    self.setupAlert(id: user.user.uid, name: user.user.displayName ?? "")
                }
            }
        }
    }
    
    
    
    func setupAlert(id: String, name: String) {
        let alert = UIAlertController(title: "Sign in", message: "Hello: \(name) \n You are sign in successfully, and you ID: \(id)", preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Okay", style: .cancel) { sender in
            
        }
        
        alert.addAction(alertButton)
        UIApplication.getTopViewController()?.present(alert, animated: true)
    }
    
    func setupErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Error: \(error.localizedDescription).", preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Okay", style: .cancel) { sender in
            
        }
        
        alert.addAction(alertButton)
        UIApplication.getTopViewController()?.present(alert, animated: true)
    }
    
}


// MARK: UIApplication extensions

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

