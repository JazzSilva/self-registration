//
//  idleXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 6/12/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Lottie

class idleXib: UIView {
    
    @IBOutlet var contentView: UIView!

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
        Bundle.main.loadNibNamed("idleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.clipsToBounds = false
        contentView.frame = .init(x: 0, y: 0, width: 800, height: 500)
        contentView.shadowColor = .black
        contentView.shadowOpacity = 0.80
        contentView.shadowOffset = CGPoint(x: 0, y: 0)
        contentView.shadowRadius = 15
        isValid.layer.cornerRadius = 4
    }
    
    @objc func removeButton(sender: AnyObject) {
        self.isValid.removeFromSuperview()
    }
    
}
