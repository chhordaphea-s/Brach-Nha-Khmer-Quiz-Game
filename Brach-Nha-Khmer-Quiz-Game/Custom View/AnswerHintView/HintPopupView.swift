//
//  AnswerHintPopUpView.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/7/23.
//

import UIKit

class hintPopupView: UIView {
    
    // BODY
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
        let bundle = Bundle.init(for: hintPopupView.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: hintPopupView.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    func setup() {
        
    }
    
    @IBAction func getPressedButton(_ sender: UIButton) {
        ButtonEffectAnimation.shared.popEffect(button: sender)
    }
    
}
