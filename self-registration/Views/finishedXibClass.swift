//
//  finishedXibClass.swift
//  self-registration
//
//  Created by Jasmin Silva on 3/12/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class finishedXib: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var isValid: nextButton!
    @IBOutlet weak var topLabel: UILabel!

    @IBOutlet var checkMark: UIView!
    @IBOutlet weak var adultResultPopUp: UIView!
    @IBOutlet weak var childrenResultPopUp: UIView!
    @IBOutlet weak var digitalResultPopUp: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("finishedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = .init(x: 0, y: 0, width: 800, height: 500)
        contentView.clipsToBounds = false
        contentView.shadowColor = .black
        contentView.shadowOpacity = 0.80
        contentView.shadowOffset = CGPoint(x: 2, y: 2)
        contentView.shadowRadius = 14
        contentView.addSubview(checkMark)
        checkMark.center.x = contentView.center.x
        checkMark.center.y = contentView.center.y
        isValid.enableSettings()
    }
    
    @objc func popUpAdult(sender: AnyObject) {
        contentView.addSubview(adultResultPopUp)
        adultResultPopUp.center.x = contentView.center.x
        adultResultPopUp.center.y = contentView.center.y
        //adultResultPopUp.addSubview(checkMark)
        //checkMark.center.x = contentView.center.x
        //checkMark.center.y = contentView.center.y
        animateCheck()
        
    }
    
    @objc func popUpChild(sender: AnyObject) {
        contentView.addSubview(childrenResultPopUp)
        childrenResultPopUp.center.x = contentView.center.x
        childrenResultPopUp.center.y = contentView.center.y
        //childrenResultPopUp.addSubview(checkMark)
        //checkMark.center.x = contentView.center.x
        //checkMark.center.y = contentView.center.y
        animateCheck()
    }
    
    @objc func popUpDigital(sender: AnyObject) {
        contentView.addSubview(digitalResultPopUp)
        digitalResultPopUp.center.x = contentView.center.x
        digitalResultPopUp.center.y = contentView.center.y
        //digitalResultPopUp.addSubview(checkMark)
        //checkMark.center.x = contentView.center.x
        //checkMark.center.y = contentView.center.y
        animateCheck()
    }
    
    private func animateCheck() {
        let animationView = LOTAnimationView(name: "done")
        animationView.frame = CGRect(x:0, y:0, width: 90, height: 90)
        animationView.contentMode = .scaleAspectFill
        checkMark.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = false
    }
    
}
