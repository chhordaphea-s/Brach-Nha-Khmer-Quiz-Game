//
//  GameCenterHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/2/23.
//


import UIKit
import GameKit

class GameCentreHelper : NSObject, GKGameCenterControllerDelegate {
    
    static let shareInstance = GameCentreHelper()
    let user = GKLocalPlayer.local
    
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
                topViewController!.present(view!, animated: true, completion: nil)
            }
            else {
                print(GKLocalPlayer.local.isAuthenticated)
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

