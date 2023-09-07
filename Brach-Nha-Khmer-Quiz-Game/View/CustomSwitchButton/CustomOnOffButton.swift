//
//  CustomOnOffButton.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/31/23.
//

import UIKit

protocol CustomOnOffButtonDelegate: NSObjectProtocol {
    func didSelected(_ button: UIView, status: Bool, index: Int)
}


class CustomOnOffButton: UIView {

    // MARK: PROPERTIES
    @IBOutlet weak var button: UIButton!
    
    
    var isActive: Bool = true
    var buttonData: OnOffButton?
    var index: Int?
    
    weak var delegate: CustomOnOffButtonDelegate?
    
    
    // MARK: BODY
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: CustomOnOffButton.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: CustomOnOffButton.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    
    // MARK: BOTTON
    @IBAction func buttonPressed(_ sender: UIButton) {
        isActive = !isActive

        changeButtonIconHadler()
        delegate?.didSelected(self, status: isActive, index: self.index ?? 0)
    }
    
    
    // MARK: FUCNTION
    func changeButtonIconHadler() {
        let icon: UIImage? = isActive ? buttonData?.activeIcon : buttonData?.disActiveIcon
        button.setImage(icon, for: .normal)
    }
    
    func setupButton(data: OnOffButton, status: Bool, index: Int) {
        self.buttonData = data
        self.isActive = status
        self.index = index
        changeButtonIconHadler()
    }
    
}
