//
//  submitXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/30/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

class submitXib: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("submitView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
