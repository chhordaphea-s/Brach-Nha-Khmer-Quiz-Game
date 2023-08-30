//
//  ChoosePlayerModeCustomSagement.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/27/23.
//

import UIKit
import BetterSegmentedControl

class ChoosePlayerModeCustomSagement: UIView {

    @IBOutlet weak var sagementControl: BetterSegmentedControl!
    
    var modeSelected: PlayMode = .singlePlayerMode

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupSagement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: ChoosePlayerModeCustomSagement.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: ChoosePlayerModeCustomSagement.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        setupSagement()
    }
    
    @IBAction func playModeChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0:
            modeSelected = .singlePlayerMode
        case 1:
            modeSelected = .multiPlyerMode
        default:
            modeSelected = .singlePlayerMode
        }
        selectOptionHandler()

    }
    
    
    func setupSagement() {
        sagementControl.segments = LabelSegment.segments(withTitles: ["លេងម្នាក់ឯង", "លេងជាមួយគ្នា"],
                                                         normalBackgroundColor: Constant.color.getClearColor(),
                                                         normalTextColor: Constant.color.getTextColor(),
                                                         selectedBackgroundColor: Constant.color.getPrimaryColor(),
                                                         selectedTextColor: UIColor.white)

    }
    
    func selectOptionHandler() {
        let condition = (modeSelected == .singlePlayerMode)
        sagementControl.setIndex(condition ? 0 : 1)
    }
}
