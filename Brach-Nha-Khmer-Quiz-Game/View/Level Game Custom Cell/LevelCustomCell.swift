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
    
    

    
    func levelGradientColor(color1: CGColor, color2: CGColor){

        let gradient = CAGradientLayer()

        gradient.frame = levelBackgroundColor.bounds
        gradient.colors = [color1, color2]

        levelBackgroundColor.layer.insertSublayer(gradient, at: 0)
    }
    
    func cellConfiguration(data: LevelViewModel) {
        levelLabel.text = convertEngNumToKhNum(engNum: data.levelNum)
        levelLabel.textColor = UIColor(cgColor: data.color1)
        
        if data.enable {
            levelGradientColor(color1: data.color1, color2: data.color2)
            
            for i in 0..<data.star {
                stars[i].tintColor = UIColor(named: "YellowStarColor")
            }
        } else {
            levelBackgroundColor.backgroundColor = .systemGray2
        }
        

    }

}
