//
//  HintHalfHalfButton.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 6/9/23.
//

import UIKit

protocol HintHalfHalfButtonDelegate: NSObjectProtocol {
    func didSelect()
}

class HintHalfHalfButton: UIView {

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var strokeView: UIView!
    
    
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
    
    private func commonInit() {
        let bundle = Bundle.init(for: HintHalfHalfButton.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: HintHalfHalfButton.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        setupBackground()
    }
    
    
    
    func setupBackground(){
        backgroundView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 15)
        
        
    }
    
    func setupData (data: HintButton){
        self.type = data.type
        self.num = data.num
        self.enable = data.enable
        
        if !enable || num <= 0 {
            self.isHidden = true
        }
    }
    
}
