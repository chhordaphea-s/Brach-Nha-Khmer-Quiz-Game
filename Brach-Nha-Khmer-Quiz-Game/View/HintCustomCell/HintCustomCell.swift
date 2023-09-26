//
//  HintCustomCell.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/14/23.
//

import UIKit

class HintCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var hintImage: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cellConfiguration(data: HintCustomCellModel) {
        hintImage.image = data.getImage()
//        text.text = "ជំនួយ៖ \(data.type.rawValue)"
        text.text = data.title
        
        priceBackground.backgroundColor = data.enable ? data.priceBackground : UIColor.systemGray
        price.text = data.price == 0 ? "ឥតគិតថ្លៃ" : "$ \(data.price)"
    }
    
    
}
 
