//
//  ViewAnimateHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 8/31/23.
//

import UIKit

class ViewAnimateHelper {
    static let shared = ViewAnimateHelper()

    var baseView = UIView()
    var popUpView = UIView()
    
    private init() {}
        
    func animateViewIn(_ baseView: UIView, popUpView: UIView, width: Float, height: Float, tapBackground: Bool = true) {

        let backgroundView = UIView()
        backgroundView.tag = 1
        
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = true
        baseView.addSubview(backgroundView)

        if tapBackground {
            let tapGasture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
            backgroundView.addGestureRecognizer(tapGasture)
        }
        
        self.baseView = baseView
        self.popUpView = popUpView

        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0)
        ])
        
        popUpView.alpha = 0
        baseView.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
                        
        UIView.animate(withDuration: 0.3) {
            popUpView.alpha = 1
        }
        
        NSLayoutConstraint.activate([
            popUpView.widthAnchor.constraint(equalToConstant: CGFloat(width)),
            popUpView.heightAnchor.constraint(equalToConstant: CGFloat(height)),
            popUpView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0),
            popUpView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0)
        ])
    }
    
    func animateViewOut(_ baseView: UIView, popUpView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            popUpView.alpha = 0
            baseView.viewWithTag(1)?.alpha = 0
        }) { _ in
            popUpView.removeFromSuperview()
            baseView.viewWithTag(1)?.removeFromSuperview()
        }
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        animateViewOut(self.baseView, popUpView: self.popUpView)
        
     }
}
