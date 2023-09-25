//
//  LostView.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/13/23.
//

import UIKit

protocol LostViewDelegate: NSObjectProtocol {
    func displayAds()
}

class LostView: UIView {

    @IBOutlet weak var playAdsViewButton: UIView!
    @IBOutlet weak var leaveGameViewButton: UIView!
    
    weak var delegate: LostViewDelegate?

    
    // MARK: BODY
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: BUTTON
    @IBAction func playAdsButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: playAdsViewButton)
        print("Play Ads")
        
        delegate?.displayAds()
        
    }
    
    
    @IBAction func LeaveGameButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: leaveGameViewButton)
        print("Leave game")
    }
    


    // MARK: FUNCTION
    
    private func commonInit() {
        let bundle = Bundle.init(for: LostView.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: LostView.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
            }
}

extension LostView {
    func animateViewIn(baseView: UIView, popUpView: UIView) {
        ViewAnimateHelper.shared.animateViewIn(baseView, popUpView: popUpView, width: 282, height: 396, tapBackground: false)
    }
    
    func animateViewOut(baseView: UIView, popUpView: UIView) {
        ViewAnimateHelper.shared.animateViewOut(baseView, popUpView: popUpView)
    }
}
