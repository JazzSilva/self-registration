//
//  testFields.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/9/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import RxSwift

@IBDesignable

class shakingTextField: UITextField {
    
    func updateUI(bool: Bool) {
        self.textColor = bool ? constants.colors.greenValid : constants.colors.redInvalid
    }
    
    func act(bool: Bool) {
        bool ? self.updateView() : self.shake()
    }
    
    func updateImage(bool: Bool) {
        if bool == false {
            self.hideImage()
        }
        else {
            return
        }
    }
    
    func didEndEditing() {
        if self.leftViewMode == .never && self.text != "" {
            self.act(bool: self.textColor == constants.colors.greenValid ? true : false)
        }
        else {
           self.updateImage(bool: self.textColor == constants.colors.greenValid ? true : false)
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x-4, y:self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x+4, y:self.center.y))
        self.layer.add(animation, forKey: "position")
        self.hideImage()
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            hideImage()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            let animationView = LOTAnimationView(name: "correctCheck")
            animationView.frame = CGRect(x: -70, y: -70, width: 140, height: 140)
            animationView.contentMode = .scaleAspectFill
            
            //show image unless user is typing
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            view.addSubview(animationView)
            animationView.play()
            leftView = view
            
        }
        else {
            leftViewMode = .never
            //image is nil
        }
    }
    
    func hideImage() {
        leftViewMode = .never
    }
    
}


