//
//  addressXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/23/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class addressXib: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var city: shakingTextField!
    @IBOutlet weak var address1: shakingTextField!
    @IBOutlet weak var state: shakingTextField!
    @IBOutlet weak var zipCode: shakingTextField!
    
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
        Bundle.main.loadNibNamed("addressView", owner: self, options: nil)
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
    
    @IBAction func AddressEnd(_ sender: Any) {
        self.address1.didEndEditing()
    }
    
    @IBAction func CityEnd(_ sender: Any) {
        self.city.didEndEditing()
    }
    
    @IBAction func StateEnd(_ sender: Any) {
        self.state.didEndEditing()
    }
    
    @IBAction func ZipEnd(_ sender: Any) {
        self.zipCode.didEndEditing()
    }
    
}
