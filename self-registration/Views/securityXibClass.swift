//
//  securityXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/30/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class securityXib: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var pin: shakingTextField!
    @IBOutlet weak var mothersMaidenName: shakingTextField!
    @IBOutlet weak var holds: shakingTextField!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var isValid: nextButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("securityView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = .init(x: 0, y: 0, width: 800, height: 500)
        contentView.clipsToBounds = false
        contentView.shadowColor = .black
        contentView.shadowOpacity = 0.20
        contentView.shadowOffset = CGPoint(x: 0, y: 0)
        contentView.shadowRadius = 14
    }
    
    @objc func removeButton(sender: AnyObject) {
        self.isValid.removeFromSuperview()
    }
    
    @IBAction func pinEnd(_ sender: Any) {
        self.pin.didEndEditing()
    }
    
    @IBAction func mothersMaidenNameEnd(_ sender: Any) {
        self.mothersMaidenName.didEndEditing()
    }
    
    @IBAction func holdsEnd(_ sender: Any) {
        if self.holds.text?.count == 0 {
            self.holds.hideImage()
        } else {
        self.holds.didEndEditing()
        }
    }
    
}
