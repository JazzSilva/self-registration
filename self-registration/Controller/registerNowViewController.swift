//
//  registerNowViewController.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/23/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class registerNowVC: UIViewController {
    
    var scrollView: UIScrollView!
    var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Scroll View and add it as a subview to RegisterNow VC
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        
        //Create Stack View and add contraints
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.spacing = 0.20
        
        //Add the stack view to the scroll view
        scrollView.addSubview(stackView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        //Add custom views to the stack
        for item in createViews(UIColor.blue) {
            stackView.addArrangedSubview(item)
        }
    
        //Buttons to add another Xib Screen
        let name = UIButton(type: UIButtonType.system)
        name.setTitle("name", for: .normal)
        name.addTarget(self, action: #selector(insertArrangedName(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(name)
        
        let address = UIButton(type: UIButtonType.system)
        address.setTitle("address", for: .normal)
        address.addTarget(self, action: #selector(insertArrangedAddress(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(address)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollContentSize()
    }
    
    //create views mapped to a specific color
    private func createViews(_ named: UIColor...) -> [UIView] {
        return named.map { name in
            let view = customName()
            view.heightAnchor.constraint(equalToConstant: 600).isActive = true
            view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
            view.contentView.backgroundColor = name
            return view
        }
    }
    
    //adjust scroll view to fit new stack view content
    private func updateScrollContentSize() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews { contentRect = contentRect.union(view.frame) }
        scrollView.contentSize = CGSize(width: contentRect.width, height: contentRect.origin.y + contentRect.height)
        scrollView.setContentOffset(CGPoint(x: contentRect.width, y: 0), animated: true)
    }
    
    //insert address view
    @objc func insertArrangedAddress(sender: AnyObject) {
        let view = addressView()
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    @objc func insertArrangedName(sender: AnyObject) {
        let view = customName()
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    //ViewModel Test with RX Swift
    var viewModel = userViewModel()

}
