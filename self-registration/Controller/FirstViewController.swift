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
    var viewModel = userViewModel() //should this be optional? weak
    var disposeBag = DisposeBag() //should this be optional? weak
    
    override func viewWillAppear(_ animated: Bool) {
        setInitialScene(view: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for all in stackView.arrangedSubviews {all.removeFromSuperview()}
        for all in self.view.subviews { all.removeFromSuperview()}
    }
    
    private func setInitialScene(view: UIView) {
        viewModel = userViewModel()
        disposeBag = DisposeBag()
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
        stackView.distribution = .fill
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.spacing = 0
        
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
        if stackView.arrangedSubviews.count == 1 {
            scrollView.setContentOffset(CGPoint(x: contentRect.width, y: 0), animated: false) }
        else {
            scrollView.setContentOffset(CGPoint(x: contentRect.width, y: 0), animated: true)
        }
    }
    
    //Insert Name View
    @objc func insertArrangedName(sender: AnyObject) {
        let view = nameXib()
        
        view.firstName.rx.text.map { $0 ?? "" }.bind(to: viewModel.firstName).disposed(by: disposeBag)
        view.middleName.rx.text.map { $0 ?? ""}.bind(to: viewModel.middleName).disposed(by: disposeBag)
        view.lastName.rx.text.map { $0 ?? ""}.bind(to: viewModel.lastName).disposed(by: disposeBag)
        
        _ = viewModel.isNameValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedAddress(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isNameValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setTitleColor(isValid ? greenHexEnabled : greyHexDisabled, for: .normal)
        }).disposed(by: disposeBag)
        
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 40 ).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        view.topLabel.textColor = blueHexTitle
        stackView.addArrangedSubview(view)
        animateIn(newView: view)
    }
    
    //Insert Address View
    @objc func insertArrangedAddress(sender: AnyObject) {
        let view = addressXib()
        //Bind address text fields to the view model
        view.address1.rx.text.map { $0 ?? "" }.bind(to: viewModel.address1).disposed(by: disposeBag)
        view.city.rx.text.map { $0 ?? ""}.bind(to: viewModel.city).disposed(by: disposeBag)
        view.state.rx.text.map { $0 ?? ""}.bind(to: viewModel.state).disposed(by: disposeBag)
        view.zipCode.rx.text.map { $0 ?? ""}.bind(to: viewModel.zip).disposed(by: disposeBag)
        
        _ = viewModel.isAddressValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedSecurity(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isAddressValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setTitleColor(isValid ? greenHexEnabled : greyHexDisabled, for: .normal)
        }).disposed(by: disposeBag)
        
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 40 ).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        view.topLabel.textColor = blueHexTitle
        stackView.addArrangedSubview(view)
        animateIn(newView: view)
    }
    
    //Insert Security View
    @objc func insertArrangedSecurity(sender: AnyObject) {
        let view = securityXib()
        
        view.mothersMaidenName.rx.text.map { $0 ?? "" }.bind(to: viewModel.mothersMaidenName).disposed(by: disposeBag)
        view.holds.rx.text.map { $0 ?? "" }.bind(to: viewModel.holds).disposed(by: disposeBag)
        view.pin.rx.text.map { $0 ?? "" }.bind(to: viewModel.pin).disposed(by: disposeBag)
        
        _ = viewModel.isSecurityValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedContact(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isSecurityValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setTitleColor(isValid ? greenHexEnabled : greyHexDisabled, for: .normal)
        }).disposed(by: disposeBag)
        
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 40 ).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        view.topLabel.textColor = blueHexTitle
        stackView.addArrangedSubview(view)
        animateIn(newView: view)
    }
    
    //Insert Contact View
    @objc func insertArrangedContact(sender: AnyObject) {
        let view = contactXib()
        
        view.phone.rx.text.map { $0 ?? ""}.bind(to: viewModel.phone).disposed(by: disposeBag)
        view.email.rx.text.map { $0 ?? ""}.bind(to: viewModel.email).disposed(by: disposeBag)
        
        _ = viewModel.isContactValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedSubmit(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isContactValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setTitleColor(isValid ? greenHexEnabled : greyHexDisabled, for: .normal)
        }).disposed(by: disposeBag)
        
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 40 ).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        view.topLabel.textColor = blueHexTitle
        stackView.addArrangedSubview(view)
        animateIn(newView: view)
    }
    
    @objc func insertArrangedSubmit(sender: AnyObject) {
        let view = submitXib()
        
        _ = viewModel.isFormComplete.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(viewModel, action: #selector(viewModel.createUser(sender:)), for: .touchUpInside)
        view.isValid.addTarget(self, action: #selector(restartViews(sender:)), for: .touchUpInside)
        
        //validate that signature is not empty
        viewModel.isFormComplete.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setTitleColor(isValid ? greenHexEnabled : greyHexDisabled, for: .normal)
        }).disposed(by: disposeBag)
        
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 40 ).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        view.topLabel.textColor = blueHexTitle
        stackView.addArrangedSubview(view)
        animateIn(newView: view)
    }

    @objc func restartViews(sender: AnyObject) {
        animateOut(view: stackView)
    }
    
    //animations
    private func animateIn(newView: UIView) {
        newView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
        newView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            newView.alpha = 1
            newView.transform = CGAffineTransform.identity } , completion: nil )
    }
    
    private func animateOut(view: UIView) {
        view.alpha = 1
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            view.alpha = 0
            //need to briefly bring up clapping hands animation
        }, completion: { finished in
            for all in self.stackView.arrangedSubviews {self.stackView.removeArrangedSubview(all)}
            for all in self.view.subviews { all.removeFromSuperview() }
            self.setInitialScene(view: self.view)
        })
    }
    
}

