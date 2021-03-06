//
//  nameView.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/23/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class nameXib: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var firstName: shakingTextField!
    @IBOutlet weak var middleName: shakingTextField!
    @IBOutlet weak var lastName: shakingTextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var isValid: nextButton!

    let birthday = Variable<String>("")
    
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
        contentView.shadowOpacity = 0.80
        contentView.shadowOffset = CGPoint(x: 2, y: 2)
        contentView.shadowRadius = 14
    }
    
    @objc func removeButton(sender: AnyObject) {
        self.isValid.removeFromSuperview()
    }
    
    
    @IBAction func FirstEnd(_ sender: Any) {
        self.firstName.didEndEditing()
    }
    
    @IBAction func middleEnd(_ sender: Any) {
        if self.middleName.text?.count == 0 {
            self.middleName.hideImage()
        } else {
            self.middleName.didEndEditing()
        }
    }
    
    @IBAction func lastEnd(_ sender: Any) {
        self.lastName.didEndEditing()
    }
    
    @objc func doneSelecting(sender: AnyObject) {
        birthday.value = getBirthdayToString(date: datePicker.date as NSDate)
    }
    
    
}
