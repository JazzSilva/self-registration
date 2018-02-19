//
//  contactXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/30/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class contactXib: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var phone: shakingTextField!
    @IBOutlet weak var email: shakingTextField!
    
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
        Bundle.main.loadNibNamed("contactView", owner: self, options: nil)
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
    
    @IBAction func phoneEnd(_ sender: Any) {
        var text = phone.text
        var copy = text
        while text?.contains("-") == true {
            text!.remove(at: copy!.index(of: "-")!)
            copy = text!
        }
        if text?.contains("(") == true {
            text!.remove(at: copy!.index(of: "(")!)
            copy = text!
        }
        if text?.contains(")") == true {
            text!.remove(at: copy!.index(of: ")")!)
            copy = text!
        }
        phone.text = text
        self.phone.didEndEditing()
    }
    
    @IBAction func emailEnd(_ sender: Any) {
        self.email.didEndEditing()
    }
    
}
