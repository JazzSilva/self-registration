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

@IBDesignable

class shakingTextField: UITextField {
    
    func shake () {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x-4, y:self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x+4, y:self.center.y))
        
        self.layer.add(animation, forKey: "position")
        
        //Hide green checkmark if field shakes
        self.hideImage()
        
        //Change text color to red if there is an error
        self.textColor = greyHexDisabled
    }
    
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            //default function from inspector
            hideImage()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            let animationView = LOTAnimationView(name: "data")
            animationView.frame = CGRect(x: -16, y: -24, width: 70, height: 70)
            animationView.contentMode = .scaleAspectFill
            
            //show image unless user is typing
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 6, y: 0, width: 24, height: 20))
            imageView.image = image
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 20))
            view.addSubview(animationView)
            animationView.play()
            leftView = view
            
            //Change text color back to black
            self.textColor = UIColor.black
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

