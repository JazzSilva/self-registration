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
import Crashlytics
import Fabric

class FirstViewController: UIViewController, UITextFieldDelegate {

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var viewModel: userViewModel! //should this be
    var disposeBag: DisposeBag! //should this be weak
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setInitialScene(view: self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        Database.shared.observeRealmErrors(in: self) { (error) in print(error ?? "no error") }
        self.hideKeyboardWhenTappedAround()
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        Database.shared.stopObservingErrors(in: self)
        for all in stackView.arrangedSubviews {all.removeFromSuperview()}
        for all in self.view.subviews {all.removeFromSuperview()}
        super.viewWillDisappear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateScrollContentSize()
    }
    
    private func setInitialScene(view: UIView) {
        viewModel = userViewModel()
        disposeBag = DisposeBag()
        
        //Set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundArtboard")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //Create Scroll View and add it as a subview to RegisterNow VC
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
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
        
        //Add the first custom view to the stack
        insertArrangedIdle(sender: self)
    }
    
    //Adjust scroll view to fit new stack view content
    public func updateScrollContentSize() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews { contentRect = contentRect.union(view.frame) }
        scrollView.contentSize = CGSize(width: contentRect.width, height: contentRect.origin.y + contentRect.height)
        if stackView.arrangedSubviews.count == 1 {
            scrollView.setContentOffset(CGPoint(x: contentRect.width, y: 0), animated: false) }
        else {
            scrollView.setContentOffset(CGPoint(x: contentRect.width, y: 0), animated: true)
        }
    }
    
    
    @objc func insertArrangedOnboarding(sender: AnyObject) {
        let view = UIPageViewController()
        
        
        
        //stackView.inse
        //animateIn(newView: view)
    }
    
    
    
    @objc func insertArrangedIdle(sender: AnyObject) {
        let view = idleXib()
        
        guard let button = view.isValid else { return }
        button.addTarget(self, action: #selector(self.insertArrangedHome(sender:)), for: .touchUpInside)
        button.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 10 ).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        
        stackView.addArrangedSubview(view)
        animateIn(newView: view)
        
    }
    
    
    //Insert Home View
    @objc func insertArrangedHome(sender: AnyObject) {
        let view = homeXib()
        
        guard let button = view.swipeButton else { return }
        button.addTarget(self, action: #selector(self.swipeCompleteNextXib(sender:)), for: .touchUpInside)
        button.addTarget(view, action: #selector(view.removeSwipeButton(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.insertArrangedSecurity(sender:)), for: .touchUpInside)
    
        view.button.addTarget(self, action: #selector(insertArrangedName(sender:)), for: .touchUpInside)
        view.button.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        view.accountExistsButton.addTarget(self, action: #selector(restartViews(sender:)), for: .touchUpInside)
        view.unableToReadSwipeButton.addTarget(self, action: #selector(restartViews(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        animateIn(newView: view)
        displayStartOver()
    }
    
    //Insert Name View
    @objc func insertArrangedName(sender: AnyObject) {
        let view = nameXib()
        
        view.firstName.rx.text.map { $0 ?? "" }.bind(to: viewModel.firstName).disposed(by: disposeBag)
        view.middleName.rx.text.map { $0 ?? ""}.bind(to: viewModel.middleName).disposed(by: disposeBag)
        view.lastName.rx.text.map { $0 ?? ""}.bind(to: viewModel.lastName).disposed(by: disposeBag)
        
        viewModel.isNameViewValid.bind(to: view.isValid.rx.isEnabled).disposed(by: disposeBag)
        view.isValid.addTarget(view, action: #selector(view.doneSelecting(sender:)), for: .touchUpInside)
        view.isValid.addTarget(self, action: #selector(nameCompleteBindBirthday(sender:)), for: .touchUpInside)
        view.isValid.addTarget(self, action: #selector(insertArrangedAddress(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)

        viewModel.isNameViewValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setUI(bool: isValid)
        }).disposed(by: disposeBag)
        
        viewModel.firstNameValid.subscribe(onNext: { [unowned view] isValid in view.firstName.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.middleNameValid.subscribe(onNext: { [unowned view] isValid in view.middleName.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.lastNameValid.subscribe(onNext: { [unowned view] isValid in view.lastName.updateUI(bool: isValid)}).disposed(by: disposeBag)
        
        view.topLabel.textColor = constants.colors.blueText
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        
    }
    
    //Insert Address View
    @objc func insertArrangedAddress(sender: AnyObject) {
        let view = addressXib()
        view.address1.rx.text.map { $0 ?? "" }.bind(to: viewModel.address1).disposed(by: disposeBag)
        view.city.rx.text.map { $0 ?? ""}.bind(to: viewModel.city).disposed(by: disposeBag)
        view.state.rx.text.map { $0 ?? ""}.bind(to: viewModel.state).disposed(by: disposeBag)
        view.zipCode.rx.text.map { $0 ?? ""}.bind(to: viewModel.zip).disposed(by: disposeBag)
        
        _ = viewModel.isAddressViewValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedSecurity(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isAddressViewValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setUI(bool: isValid)
        }).disposed(by: disposeBag)
        
        viewModel.address1Valid.subscribe(onNext: { [unowned view] isValid in view.address1.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.cityValid.subscribe(onNext: { [unowned view] isValid in view.city.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.stateValid.subscribe(onNext: { [unowned view] isValid in view.state.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.zipValid.subscribe(onNext: { [unowned view] isValid in view.zipCode.updateUI(bool: isValid)}).disposed(by: disposeBag)
        
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        view.topLabel.textColor = constants.colors.blueText
        animateIn(newView: view)
    }
    
    //Insert Security View
    @objc func insertArrangedSecurity(sender: AnyObject) {
        let view = securityXib()
        view.mothersMaidenName.rx.text.map { $0 ?? "" }.bind(to: viewModel.mothersMaidenName).disposed(by: disposeBag)
        view.holds.rx.text.map { $0 ?? "" }.bind(to: viewModel.holds).disposed(by: disposeBag)
        view.pin.rx.text.map { $0 ?? "" }.bind(to: viewModel.pin).disposed(by: disposeBag)
        
        _ = viewModel.isSecurityViewValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedContact(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isSecurityViewValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setUI(bool: isValid)
        }).disposed(by: disposeBag)
        
        viewModel.mothersMaidenNameValid.subscribe(onNext: { [unowned view] isValid in view.mothersMaidenName.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.holdsValid.subscribe(onNext: { [unowned view] isValid in view.holds.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.pinValid.subscribe(onNext: { [unowned view] isValid in view.pin.updateUI(bool: isValid)}).disposed(by: disposeBag)
        
        view.topLabel.textColor = constants.colors.blueText
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        animateIn(newView: view)
    }
    
    //Insert Contact View
    @objc func insertArrangedContact(sender: AnyObject) {
        let view = contactXib()
        view.phone.rx.text.map { $0 ?? ""}.bind(to: viewModel.phone).disposed(by: disposeBag)
        view.email.rx.text.map { $0 ?? ""}.bind(to: viewModel.email).disposed(by: disposeBag)
        
        _ = viewModel.isContactViewValid.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(insertArrangedSubmit(sender:)), for: .touchUpInside)
        view.isValid.addTarget(view, action: #selector(view.removeButton(sender:)), for: .touchUpInside)
        
        viewModel.isContactViewValid.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setUI(bool: isValid)
        }).disposed(by: disposeBag)
        
        viewModel.phoneValid.subscribe(onNext: { [unowned view] isValid in view.phone.updateUI(bool: isValid)}).disposed(by: disposeBag)
        viewModel.emailValid.subscribe(onNext: { [unowned view] isValid in view.email.updateUI(bool: isValid)}).disposed(by: disposeBag)
        
        view.topLabel.textColor = constants.colors.blueText
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        animateIn(newView: view)
    }
    
    //Insert Submit 
    @objc func insertArrangedSubmit(sender: AnyObject) {
        let view = submitXib()
        
        _ = viewModel.isFormComplete.bind(to: view.isValid.rx.isEnabled)
        view.isValid.addTarget(self, action: #selector(submitData(sender:)), for: .touchUpInside)

        viewModel.isFormComplete.subscribe(onNext: { [unowned view] isValid in
            guard let button = view.isValid else { return }
            button.setUI(bool: isValid)
        }).disposed(by: disposeBag)
        
        view.topLabel.textColor = constants.colors.blueText
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        animateIn(newView: view)
    }
    
    //Insert Finished
    @objc func insertArrangedFinished(sender: AnyObject) {
        let view = finishedXib()
        
        self.view.subviews.last?.removeFromSuperview()
        
        if viewModel.userProfile.value == "A" {
            view.popUpAdult(sender: self)
        }
        else if viewModel.isChildUser.value {
            view.popUpChild(sender: self)
        }
        else {
            view.popUpDigital(sender: self)
        }
        
        view.isValid.addTarget(self, action: #selector(restartViews(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(setConstraints(inputXib: view))
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = false
        animateIn(newView: view)
    }
    
    @objc func submitData(sender: AnyObject) {
        submitSignature(view: self.stackView.arrangedSubviews.last! as! submitXib)
    }

    @objc func restartViews(sender: AnyObject) {
        animateOut(view: stackView)
    }
    
    @objc func swipeCompleteNextXib(sender: AnyObject) {
        bindSwipe(inputXib: self.stackView.arrangedSubviews.last! as! homeXib)
        displayStartOver()
    }
    
    @objc func nameCompleteBindBirthday(sender: AnyObject) {
        bindBirthday(inputXib: self.stackView.arrangedSubviews.last! as! nameXib)
    }

    private func submitSignature(view: submitXib) {
        if let signatureData = view.signatureView?.signature  {
            let data = UIImagePNGRepresentation(signatureData)!
            viewModel.signature.value = data.base64EncodedString()
            viewModel.createUser(sender:self)
            insertArrangedFinished(sender: self)
        }
        else {
            view.instructions.textColor = constants.colors.redInvalid
            return
        }
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
            for all in self.stackView.arrangedSubviews {
                self.stackView.removeArrangedSubview(all)
                all.removeFromSuperview()
            }
            for all in self.view.subviews {
                view.willRemoveSubview(all)
                all.removeFromSuperview()
            }
            self.setInitialScene(view: self.view)
        })
    }
    
    private func setConstraints(inputXib: UIView) -> UIView {
        inputXib.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 40 ).isActive = true
        inputXib.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        inputXib.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        inputXib.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        return inputXib
    }
    
    private func bindSwipe(inputXib: homeXib) {
        viewModel.firstName.value = inputXib.firstSwipe.text!
        viewModel.lastName.value = inputXib.lastSwipe.text!
        viewModel.address1.value = inputXib.addressSwipe.text!
        viewModel.city.value = inputXib.citySwipe.text!
        viewModel.state.value = inputXib.stateSwipe.text!
        viewModel.zip.value = inputXib.zipSwipe.text!
        viewModel.birthday.value = inputXib.dobSwipe.text!
        viewModel.libraryCardObject = inputXib.newLibraryCard
        /*viewModel.libraryCardNumber.value = inputXib.licenseSwipe.text!
        viewModel.licenseNumber.value = inputXib.licenseSwipe.text!
         */
        viewModel.isChildUser.value = isDLChild(viewModel.birthday.value)
        viewModel.verified.value = true
        if viewModel.isChildUser.value {
            viewModel.userProfile.value = constants.accountType.childInState }
        else {
            viewModel.userProfile.value = constants.accountType.adultInState
        }
    }
    
    private func bindBirthday(inputXib: nameXib) {
        viewModel.birthday.value = dateStringFormatted(date: inputXib.birthday.value)
        viewModel.isChildUser.value = isChild(inputXib.birthday.value)
    }
    
    private func displayStartOver() {
        let button = startOverButton()
        button.enableSettings()
        button.addTarget(self, action: #selector(restartViews(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.center = CGPoint(x: 100, y: 665)
    }

}

