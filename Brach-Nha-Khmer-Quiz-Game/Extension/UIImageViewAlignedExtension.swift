//
//  UIImageViewAlignedExtension.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 10/9/23.
//

import UIKit
import UIImageViewAlignedSwift

extension UIImageViewAligned {
    func animateBackgroundImage () {
        UIView.animate(withDuration: 70.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {

            self.alignLeft = false
            self.alignRight = true

        })
    }
}

