//
//  AnswerButton.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 5/9/23.
//

import UIKit

protocol AnswerButtonDelegate: NSObjectProtocol{
    func didSelect(index: Int, status: Bool)
}

class AnswerButton: UIView {

    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerBackgroundColor: UIView!
    @IBOutlet weak var rightAndwrong: UIImageView!
    
    weak var delegate: AnswerButtonDelegate?
    
    var title = ""
    var index : Int = 0
    var correctAnswer : String = ""
    var isEnable : Bool = true
    
    
    // MARK: - body
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
            _ = touch.location(in: self)
            
            var statusAnswer = false
            if answerLabel.text == correctAnswer {
                handleCorrectAnswer()
                statusAnswer = true
            }
            else {
                handleIncorrectAnswer()
                statusAnswer = false
            }
            
            
            if isEnable == true{
                delegate?.didSelect(index: index, status: statusAnswer)
                isEnable = false
            }
            
        }
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: AnswerButton.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: AnswerButton.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        addShadowIntoImage(view: rightAndwrong)
    }
    
    func setup(data: AnswerView) {
        answerLabel.text = data.title
        self.title = data.title
        self.index = data.index
        self.correctAnswer = data.correctAnswer
        
        
    }
    
    func checkCorrectAnswer() -> Bool {
        if answerLabel.text == correctAnswer {
           return true
        }
        else {
            return false
        }
    }
    
   
    
    func handleCorrectAnswer() {
        print("true")
        
        answerBackgroundColor.backgroundColor = UIColor(rgb: 0x8EBD12)
        answerLabel.textColor = .white
    
        rightAndwrong.image = UIImage(named: "Right")
        rightAndwrong.isHidden = false
    }
    
    func handleIncorrectAnswer() {
        print("false")
        
        answerBackgroundColor.backgroundColor = UIColor(rgb: 0xEE671B)
        answerLabel.textColor = .white
        
        rightAndwrong.isHidden = false
    }
    
    private func addShadowIntoImage(view: UIView){
        view.clipsToBounds = false
        let shadowPath0 = UIBezierPath(roundedRect: view.bounds, cornerRadius: 0)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 4
        layer0.shadowOffset = CGSize(width: 0, height: 4)
        layer0.bounds = view.bounds
        layer0.position = view.center
        view.layer.addSublayer(layer0)
    }
    
    func reset() {
        title = ""
        index = 0
        correctAnswer = ""
        isEnable = true
        
        rightAndwrong.isHidden = true
        answerBackgroundColor.backgroundColor = UIColor.white
        answerLabel.textColor = Constant.color.getTextColor()
    }
    
}
