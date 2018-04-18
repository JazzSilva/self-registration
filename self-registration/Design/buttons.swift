//
//  nextButton.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/11/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class nextButton: UIButton {
    
    func setUI(bool: Bool) {
        bool ? enableSettings() : disableSettings()
    }
    
    func enableSettings() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = greenHexEnabled
        self.layer.cornerRadius = 4
        self.clipsToBounds = false
        self.shadowColor = UIColor.gray
        self.shadowOpacity = 7
        self.shadowOffset = CGPoint(x: 0, y: 0)
        self.shadowRadius = 3
    }
    
    func disableSettings() {
        self.setTitleColor(UIColor.white, for: .disabled)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
    }
    
    func neutral() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = greenHexEnabled
        self.layer.cornerRadius = 4
    }
    
}


class startOverButton: UIButton {
    
    func enableSettings() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = startOverBlue
        self.layer.cornerRadius = 4
        self.setTitle("Start Over", for: .normal)
        self.titleLabel?.font = UIFont(name: "Futura-Medium", size: 17.0)
        self.frame = CGRect(x: 150, y: -150, width: 100, height: 33)
        self.clipsToBounds = false
        self.shadowColor = UIColor.gray
        self.shadowOpacity = 15
        self.shadowOffset = CGPoint(x: 0, y: 0)
        self.shadowRadius = 4
    }
    
}
