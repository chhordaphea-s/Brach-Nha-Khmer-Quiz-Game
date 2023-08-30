//
//  GameChoosing.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/18/23.
//

import Foundation
import UIKit

class GameChoosingViewController: UIViewController {
    

    @IBOutlet weak var GameBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackgroundView(parent: GameBackground)
    }
    
    private func customBackgroundView(parent: UIView) {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 360, height: 102.48)

        var shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 17.82)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0.184, green: 0.533, blue: 0.847, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 13.27
        layer0.shadowOffset = CGSize(width: 0, height: 4.42)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        let shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)

        let layer1 = CAGradientLayer()
        layer1.colors = [
          UIColor(red: 0.184, green: 0.725, blue: 0.847, alpha: 1).cgColor,
          UIColor(red: 0.184, green: 0.535, blue: 0.847, alpha: 1).cgColor
        ]
        layer1.locations = [0, 1]
        layer1.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer1.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer1.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width, dy: -0.5*shapes.bounds.size.height)
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)

        shapes.layer.cornerRadius = 17.82

//        let parent = self.viewr!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 360).isActive = true
        view.heightAnchor.constraint(equalToConstant: 102.48).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 19.78).isActive = true
    }
}
