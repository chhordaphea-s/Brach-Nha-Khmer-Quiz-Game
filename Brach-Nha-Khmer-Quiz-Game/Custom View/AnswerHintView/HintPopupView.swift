//
//  HintPopupView.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/7/23.
//

import UIKit

protocol HintPopupViewDelegate: NSObjectProtocol {
    func dismissHintView(_ view: UIView)
}

class HintPopupView: UIView {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var hintImage: UIImageView!
    
    weak var delegate: HintPopupViewDelegate?
    
    var hintType: HintType = .answer
    var number = 0
    
    // BODY
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    @IBAction func getPressedButton(_ sender: UIButton) {
        ButtonEffectAnimation.shared.popEffect(button: sender)
    
        delegate?.dismissHintView(self)
        
        print("You get \(self.number) help more")
        
    }
    
    
    // MARK: FUNCTION
    
    private func commonInit() {
        let bundle = Bundle.init(for: HintPopupView.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: HintPopupView.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    func setup(data: HintView) {
        self.hintType = data.hinType
        self.number = data.number
        
        
        if hintType == .answer {
            let n = answerHint + number
            print(n)
            userdefault.set(n, forKey: Constant.userdefault.answerHint)

            hintImage.image = UIImage(named: "answerHnit")
        } else {
            let n = halfHint + number
            print(n)

            userdefault.set(n, forKey: Constant.userdefault.halfHint)

            hintImage.image = UIImage(named: "halfHint")
        }
        
        message.text = "អ្នកទទួលបានជំនួយ \(hintType.rawValue) ចំនួន \(number)"

    }

    
}
