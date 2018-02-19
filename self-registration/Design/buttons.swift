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
