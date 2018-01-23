//
//  registerNowViewController.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/23/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit


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
        stackView.axis = .vertical
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.spacing = 0.50
        
        //Add the stack view to the scroll view
        scrollView.addSubview(stackView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        //Add custom views to the stack
        for item in createViews(UIColor.blue, UIColor.red, UIColor.green, UIColor.gray, UIColor.yellow) {
            stackView.addArrangedSubview(item)
        }
    
        //FIXME: Figure out why scroll view wont scroll when I remove this button
        let name = UIButton(type: UIButtonType.system)
        name.setTitle("name", for: .normal)
        ///name.addTarget(self, action: #selector(insertArrangedSubview(view: customName())), for: .touchUpInside)
        
        let address = UIButton(type: UIButtonType.system)
        address.setTitle("address", for: .normal)
        ///name.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
        stackView.addArrangedSubview(name)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    private func createViews(_ named: UIColor...) -> [UIView] {
        return named.map { name in
            let view = customName()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 200).isActive = true
            view.widthAnchor.constraint(equalToConstant: 200).isActive = true
            view.contentView.backgroundColor = name
            return view
        }
    }
    
    func insertArrangedSubview(view: UIView) {
        let view = customName()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.insertArrangedSubview(view, at: stackView.arrangedSubviews.count - 1)
    }
    
}
