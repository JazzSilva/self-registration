//
//  nameView.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/23/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class nameXib: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var isValid: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("nameView", owner: self, options: nil)
        addSubview(contentView)
        contentView.clipsToBounds = false
        contentView.frame = .init(x: 0, y: 0, width: 800, height: 500)
        contentView.shadowColor = .black
        contentView.shadowOpacity = 0.20
        contentView.shadowOffset = CGPoint(x: 0, y: 0)
        contentView.shadowRadius = 14
    }
    
    @objc func removeButton(sender: AnyObject) {
        self.isValid.removeFromSuperview()
    }
    
}
