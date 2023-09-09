//
//  HintTellAnswerButton.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 6/9/23.
//

import UIKit

protocol HintAnswerButtonDelegate: NSObjectProtocol {
    func didSelect()
}

class HintTellAnswerButton: UIView {
        
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var strokeView: UIView!
    
    weak var delegate: HintAnswerButtonDelegate?
    
    var type: HintType = .answer
    var num: Int = 0
    var enable: Bool = true
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        ButtonEffectAnimation.shared.popEffect(button: self)
        
        if let touch = touches.first {
            let currentTouch = touch.location(in: self)
            
            delegate?.didSelect()
            
        }
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: HintTellAnswerButton.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: HintTellAnswerButton.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        setupBackgroundAnswerHint()
    }
    
    
    
    func setupBackgroundAnswerHint(){
        backgroundView.roundCorners(corners: [.bottomRight, .topRight], radius: 15)
        
        
    }
    
    func setupData (data: HintButton){
        self.type = data.type
        self.num = data.num
        self.enable = data.enable
    }
    
        
        
        
}

