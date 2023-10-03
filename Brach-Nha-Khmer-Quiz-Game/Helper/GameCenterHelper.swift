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
        let localPlayer = GKLocalPlayer.local
        let topViewController = UIApplication.getTopViewController()
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil{
                topViewController!.present(view!, animated: true)
            }
            else {
                print(GKLocalPlayer.local.isAuthenticated)
                self.authenticateWithFirebase()
            }
        }

    }
    
    func authenticateWithFirebase() {
        GameCenterAuthProvider.getCredential() { (credential, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            // The credential can be used to sign in, or re-auth, or link or unlink.
            if let credential = credential {
                Auth.auth().signIn(with:credential) { (user, error) in
                    if let error = error {
                        return
                    }
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                      let playerName = user.displayName

                      // The user's ID, unique to the Firebase project.
                      // Do NOT use this value to authenticate with your backend server,
                      // if you have one. Use getToken(with:) instead.
                      let uid = user.uid
                    }
                }
            }
        }
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

