//
//  OnOffButtonModel.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/31/23.
//

import UIKit

struct OnOffButton {
    let name: String
    let activeIcon: UIImage
    let disActiveIcon: UIImage
    
    
    init(name: String, activeIcon: UIImage, disActiveIcon: UIImage) {
        self.name = name
        self.activeIcon = activeIcon
        self.disActiveIcon = disActiveIcon
    }
}
