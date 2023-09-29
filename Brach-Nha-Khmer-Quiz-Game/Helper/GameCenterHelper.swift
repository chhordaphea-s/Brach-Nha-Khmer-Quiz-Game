//
//  GameCenterHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/27/23.
//

import Foundation
import GameKit

class GameCenterHelper: NSObject, GKGameCenterControllerDelegate {
    
    static let shared = GameCenterHelper()
    
    private override init() {
        super.init()
    }
    
    // Authenticate the player with Game Center
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { viewController, error in
            if let error = error {
                print("Game Center authentication failed with error: \(error.localizedDescription)")
            } else if let vc = viewController {
                // Present the Game Center login view controller
                UIApplication.shared.topViewController?.present(vc, animated: true, completion: nil)
            } else if localPlayer.isAuthenticated {
                print("Player authenticated with Game Center")
            } else {
                print("Player is not authenticated with Game Center")
            }
        }
    }
    
    // Report an achievement to Game Center
    func reportAchievement(_ identifier: String, percentComplete: Double) {
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement]) { error in
            if let error = error {
                print("Failed to report achievement: \(error.localizedDescription)")
            } else {
                print("Achievement reported successfully")
            }
        }
    }
    
    // Show Game Center leaderboard
    func showLeaderboard(leaderboardID: String) {
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = .leaderboards
        gcViewController.leaderboardIdentifier = leaderboardID
        
        UIApplication.shared.topViewController?.present(gcViewController, animated: true, completion: nil)
    }
    
    // Dismiss Game Center view controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    var topViewController: UIViewController? {
        return UIApplication.shared.windows.first?.rootViewController?.topViewController
    }
}

extension UIViewController {
    var topViewController: UIViewController? {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topViewController
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topViewController
        }
        return self
    }
}
