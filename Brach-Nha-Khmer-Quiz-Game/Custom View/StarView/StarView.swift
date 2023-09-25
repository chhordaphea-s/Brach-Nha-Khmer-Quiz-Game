//
//  StarView.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 25/9/23.
//

import UIKit
import Lottie

class StarView: UIView {
    
    @IBOutlet weak var grayStar: UIImageView!
    @IBOutlet weak var yellowStar: LottieAnimationView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    // MARK: FUNCTION
    
    private func commonInit() {
        let bundle = Bundle.init(for: StarView.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: StarView.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        grayStar.backgroundColor = .clear

    }
    
    func activateStar(status: Bool) {
        
        if status {
            UIView.animate(withDuration: 0.2) {
                ButtonEffectAnimation.shared.popOutAnimation(view: self.grayStar, sclaEffect: 1.4)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.grayStar.isHidden = true

            }
            yellowStar.isHidden = false
            
            yellowStar.contentMode = .scaleAspectFit
            yellowStar.loopMode = .playOnce
            yellowStar.animationSpeed = 1
            yellowStar.play()
            yellowStar.backgroundColor = .clear
        }
        
    }
    
}
