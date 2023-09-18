//
//  HintCustomCellModel.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/14/23.
//

import UIKit

struct HintCustomCellModel {
    var image: UIImage?
    let type: HintType
    let title: String
    let amount: Int
    let price: Float
    let priceBackground: UIColor
    let enable: Bool
    
    init(image: UIImage? = nil, type: HintType, title: String, amount: Int, price: Float, priceBackground: UIColor, enable: Bool) {
        self.image = image
        self.type = type
        self.title = title
        self.amount = amount
        self.price = price
        self.priceBackground = priceBackground
        self.enable = enable
    }
    
    func getImage() -> UIImage? {
        if self.image == nil {
            if self.type == .answer {
                return UIImage(named: "answerHnit")
            } else if type == .halfhalf {
                return UIImage(named: "halfHint")
            } else {
                return nil
            }
        } else {
            return self.image
        }
    }
    

}
