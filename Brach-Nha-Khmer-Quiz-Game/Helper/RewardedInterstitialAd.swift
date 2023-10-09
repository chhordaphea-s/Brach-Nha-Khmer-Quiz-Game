//
//  RewardedInterstitialAd.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/27/23.
//

import UIKit
import GoogleMobileAds

protocol RewardedInterstitialAdDelegate: NSObjectProtocol {
    func adLoaded(status: Bool)
    func adError(error: Error)
    func dismissScreen()
    
}

class RewardedInterstitialAd: NSObject, GADFullScreenContentDelegate {
        
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    weak var delegate: RewardedInterstitialAdDelegate?
        
    func adsLoads(controller: UIViewController) {
        GADRewardedInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/6978759866",
                                       request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            print("Ads loaded successfully")
            self.rewardedInterstitialAd = ad
            self.rewardedInterstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func displayAds(controller: UIViewController) {
        
        if !Reachability.isConnectedToNetwork() {
            setupAlert(controller: controller)
            return
        }

        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            delegate?.adLoaded(status: false)
            return
        }
        
        rewardedInterstitialAd.present(fromRootViewController: controller) {
            _ = rewardedInterstitialAd.adReward
            self.delegate?.adLoaded(status: true)
        }
    }
    
    
    func setupAlert(controller: UIViewController) {
        let alert = UIAlertController(title: "ការតភ្ជាប់", message: "ឧបករណ៍របស់អ្នកមិនបានតភ្ជាប់ជាមួយបណ្ដាញទេ", preferredStyle: .alert)
        let button = UIAlertAction(title: "ទទួលបាន", style: .cancel)
        alert.addAction(button)
        controller.present(alert, animated: true)
    }
    
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        print("Error: ", error)
        
        delegate?.adError(error: error)
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        delegate?.dismissScreen()
    }
    
    
    
}
