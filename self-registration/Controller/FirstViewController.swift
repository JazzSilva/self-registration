//
//  FirstViewController.swift
//  self-registration
//
//  Created by Jasmin Silva on 12/19/17.
//  Copyright © 2017 Makina. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstViewController: UIViewController {

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var viewModel = userViewModel()
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel = userViewModel()
        disposeBag = DisposeBag()
        setInitialScene(view: self.view)
    }
    
    private func setInitialScene(view: UIView) {
        //Create Scroll View and add it as a subview to RegisterNow VC
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
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
        
        //Add custom view to the stack
        insertArrangedName(sender: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateScrollContentSize()
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
        let view = addressXib()
        //Bind address text fields to the view model
        view.address1.rx.text.map { $0 ?? "" }.bind(to: viewModel.address1).disposed(by: disposeBag)
        view.city.rx.text.map { $0 ?? ""}.bind(to: viewModel.city).disposed(by: disposeBag)
        view.state.rx.text.map { $0 ?? ""}.bind(to: viewModel.state).disposed(by: disposeBag)
        view.zipCode.rx.text.map { $0 ?? ""}.bind(to: viewModel.zip).disposed(by: disposeBag)
        
        _ = viewModel.isAddressValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedSecurity(sender:)), for: .touchUpInside)
        
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    @objc func insertArrangedName(sender: AnyObject) {
        let view = nameXib()

        view.firstName.rx.text.map { $0 ?? "" }.bind(to: viewModel.firstName).disposed(by: disposeBag)
        view.middleName.rx.text.map { $0 ?? ""}.bind(to: viewModel.middleName).disposed(by: disposeBag)
        view.lastName.rx.text.map { $0 ?? ""}.bind(to: viewModel.lastName).disposed(by: disposeBag)

        _ = viewModel.isNameValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedAddress(sender:)), for: .touchUpInside)
        
        //Set the text of the button to change when enabled or disables
        viewModel.isNameValid.subscribe(onNext: { [unowned self] isValid in
            view.isValid.setTitle(isValid ? "Enabled" : "Not Enabled", for: .normal)
            print(self.viewModel.firstName.value, self.viewModel.middleName.value, self.viewModel.lastName , self.viewModel.address1.value , self.viewModel.state.value)
        }).disposed(by: disposeBag)
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        view.leftAnchor.constraint(equalTo: stackView.leftAnchor)
        stackView.addArrangedSubview(view)
    }
    
    
    @objc func insertArrangedSecurity(sender: AnyObject) {
        let view = securityXib()
        
        view.mothersMaidenName.rx.text.map { $0 ?? "" }.bind(to: viewModel.mothersMaidenName).disposed(by: disposeBag)
        view.holds.rx.text.map { $0 ?? "" }.bind(to: viewModel.holds).disposed(by: disposeBag)
        view.pin.rx.text.map { $0 ?? "" }.bind(to: viewModel.pin).disposed(by: disposeBag)
        
        _ = viewModel.isSecurityValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedContact(sender:)), for: .touchUpInside)
        
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    @objc func insertArrangedContact(sender: AnyObject) {
        let view = contactXib()
        
        view.phone.rx.text.map { $0 ?? ""}.bind(to: viewModel.phone).disposed(by: disposeBag)
        view.email.rx.text.map { $0 ?? ""}.bind(to: viewModel.email).disposed(by: disposeBag)
        
        _ = viewModel.isContactValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedSubmit(sender:)), for: .touchUpInside)
        
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    @objc func insertArrangedSubmit(sender: AnyObject) {
        let view = submitXib()
        
        _ = viewModel.isFormComplete.bind(to: view.submitButton.rx.isEnabled)
        
        view.heightAnchor.constraint(equalToConstant: 600).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        stackView.addArrangedSubview(view)
    }

}

