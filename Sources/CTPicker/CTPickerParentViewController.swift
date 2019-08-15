//
//  ACParentViewController.swift
//  AutoCompletModal
//
//  Created by Stewart Lynch on 8/2/19.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
public protocol CTPickerDelegate:AnyObject {
    func setField(value:String, selectedTextField:UITextField, new:Bool)
}

@available(iOS 12.0, *)
public class CTPickerParentViewController: UIViewController {
    var containerVC: UIViewController!
    
    // Optional Colors for Navbar and alert button if required
    var navBarBarTintColor:UIColor?
    var navBarTintColor:UIColor?
    var navBartitleTextColor:UIColor?
    var actionTintColor:UIColor?
    var isAddEnabled:Bool!
    var selectedTextField:UITextField!
    var items:[String] = []
    var searchTitle:String = ""
    weak var delegate:CTPickerDelegate?
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0, green: 0, blue:0, alpha: 0.4)
        showContainer()
    }
    
    fileprivate func showContainer() {
        var vw:UIView!
        guard let childVC = containerVC as? CTPickerChildViewController else { return }
        let navVC = UINavigationController(rootViewController: childVC)
        childVC.delegate = self
        childVC.items = items
        childVC.currentItem = selectedTextField.text
        childVC.isAddEnabled = isAddEnabled
        childVC.navBarTintColor = navBarTintColor
        childVC.navBarBarTintColor = navBarBarTintColor
        childVC.navBartitleTextColor = navBartitleTextColor
        childVC.actionTintColor = actionTintColor
        childVC.searchTitle = searchTitle
        addChild(navVC)
        navVC.view.frame = .zero
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        
        navVC.view.translatesAutoresizingMaskIntoConstraints = false
        vw = navVC.view
        vw?.layer.cornerRadius = 10
        vw?.clipsToBounds = true
        vw?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let widthConstraint = vw?.widthAnchor.constraint(equalToConstant: 500)
        widthConstraint?.priority = UILayoutPriority(rawValue: 750)
        widthConstraint?.isActive = true
        vw?.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        vw?.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        vw?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        vw?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    deinit {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

@available(iOS 12.0, *)
extension CTPickerParentViewController: CTPickerChildDelegate {
    public func setValue(value: String, new: Bool) {
        dismiss(animated:true)
        delegate?.setField(value: value, selectedTextField: selectedTextField, new: new)
    }
    
    public func cancel() {
          dismiss(animated:true)
    }
    
}
