//
//  +UILabel+Aligment.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

extension UIButton { //MARK: Анимация UIButton
    
    func animate(button: UIButton) { //MARK: Fade out
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
        })
    }
    
    func pulsate() { //MARK: Пульсация
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.9
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.8
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
}
