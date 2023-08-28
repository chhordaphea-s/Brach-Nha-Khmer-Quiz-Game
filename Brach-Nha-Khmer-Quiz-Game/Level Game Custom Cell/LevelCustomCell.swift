//
//  LevelCustomCell.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Daphea on 26/8/23.
//

import UIKit

class LevelCustomCell: UICollectionViewCell {

    
    @IBOutlet weak var levelBackgroundColor: UIView!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func levelGradientColor(){

        let gradient = CAGradientLayer()

        gradient.frame = levelBackgroundColor.bounds
        gradient.colors = [UIColor(rgb: 0x2FD65D).cgColor, UIColor(rgb: 0x379C73).cgColor]

        levelBackgroundColor.layer.insertSublayer(gradient, at: 0)
    }
    
    func cellConfiguration(data:LevelViewModel) {
        levelLabel.text = String(data.levelNum)
        
        for i in 0..<data.star {
            stars[i].tintColor = UIColor(named: "YellowStarColor")
        }
    }

}
