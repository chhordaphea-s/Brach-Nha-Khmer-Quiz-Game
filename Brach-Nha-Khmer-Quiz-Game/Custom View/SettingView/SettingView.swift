//
//  SettingView.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/31/23.
//

import UIKit

protocol SettingViewDelegate: NSObjectProtocol {
    func dismissButton(_ view: UIView)
    func quitGame()
}

enum SettingViewType {
    case normal, playing
}

class SettingView: UIView {

    @IBOutlet var onOffButtons: [CustomOnOffButton]!
    @IBOutlet weak var quitGameButton: UIView!
    
    weak var delegate: SettingViewDelegate?
    
    var settingButtonState: SettingViewType = .normal
            
    // MARK: BODY
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: Button
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.dismissButton(self)
    }
    
    @IBAction func quitGameButtonPressed(_ sender: UITapGestureRecognizer) {
        ButtonEffectAnimation.shared.popEffect(button: quitGameButton)
        print("Quit Game ")
        delegate?.quitGame()
    }
    
    // MARK: FUNCTION
    
    private func commonInit() {
        let bundle = Bundle.init(for: SettingView.self)
        if let viewToAdd = bundle.loadNibNamed(String(describing: SettingView.self),owner: self, options: nil),
            let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    
    func setup(type: SettingViewType) {
        self.settingButtonState = type

        setupButton()
        
        quitGameButton.isHidden = settingButtonState == .normal ? true : false
    }
    
    func setupButton() {
        let data = [
            OnOffButton(name: "Music", activeIcon: Constant.icon.music.getActive(), disActiveIcon: Constant.icon.music.getDisActive()),
            OnOffButton(name: "Sound", activeIcon: Constant.icon.sound.getActive(), disActiveIcon: Constant.icon.sound.getDisActive()),
            OnOffButton(name: "Vibrate", activeIcon: Constant.icon.virate.getActive(), disActiveIcon: Constant.icon.virate.getDisActive())
        ]
        let dataStatus = [
            userdefault.bool(forKey: Constant.userdefault.musicBackground),
            userdefault.bool(forKey: Constant.userdefault.soundEffect),
            userdefault.bool(forKey: Constant.userdefault.vibrate)
        ]
        var index = 0
        
        for button in onOffButtons {
            button.setupButton(data: data[index], status: dataStatus[index], index: index)
            button.delegate = self
            index += 1
        }
    }
    
    
    func musicBackgroundHaneler(status: Bool) {
        if status {
            backgroundMusic.play()
        } else {
            backgroundMusic.pause()
        }
        userdefault.set(status, forKey: Constant.userdefault.musicBackground)
    }
    
    func soundEffecctHandler(status: Bool) {
        userdefault.set(status, forKey: Constant.userdefault.soundEffect)
    }
    
    func vibrateHandler(status: Bool) {
        userdefault.set(status, forKey: Constant.userdefault.vibrate)
    }
    
    

}

extension SettingView: CustomOnOffButtonDelegate {
    
    func didSelected(_ button: UIView, status: Bool, index: Int) {
        switch index {
        case 0:
            musicBackgroundHaneler(status: status)
        case 1:
            soundEffecctHandler(status: status)
        case 2:
            vibrateHandler(status: status)
        default:
            print("Music")
        }
    }

}
