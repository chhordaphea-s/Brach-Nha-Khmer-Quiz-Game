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
    
    private let databaseHelper = DatabaseHelper()
    
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
        
        buttonSoudEffect = AudioHelper(audioName: "collectHint")
    
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

    func setup(data: Hint) {
        self.hintType = data.hinType
        self.number = data.number
        
        let hint = databaseHelper.fetchData().hint
        
        if hintType == .answer {
            let n = (hint?.answerHint?.number ?? 0) + number
            hintImage.image = UIImage(named: "answerHnit")
        } else {
            let n = (hint?.halfHint?.number ?? 0) + number
            hintImage.image = UIImage(named: "halfHint")
        }
        
        databaseHelper.updateHint(hintType: self.hintType, number: self.number)
        message.text = "អ្នកទទួលបានជំនួយ \(hintType.rawValue) ចំនួន \(number)"

    }
}
