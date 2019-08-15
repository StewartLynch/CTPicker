//
//  CTPicker.swift
//  CTPicker
//
//  Created by Stewart Lynch on 8/14/19.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
public class CTPicker {
        /// Presents a picker of items
        /// from the list of items provided.
        ///
        /// - Parameters:
        ///     - vC: The calling viewController, normally 'self'.
        ///     - textField:  The UITextfield that is being edited, normally just 'textField'
        ///     - items: An array of strings representing the choices for this type.
        ///     - navBarBarTintColor: Optional color of the navigation bar background.
        ///     - navBarTintColor: Optional tintcolor for the navigation bar buttons.
        ///     - navBartitleTextColor: Optional color for the navigation bar title.
        ///     - actionTintColor: Optional color for the Alert action buttons.
        ///     - isAddEnabled: False by default.  If True, allows for adding items to items array.

        ///
        /// ```
        /// SAMPLE CALLS
        ///
        /// Sample calls for a sample CTPickerType.wine with an array of strings in wineryArray
        /// ```
        /// // default -  not changing any colors as all are optional, winery array is read only
        ///  CTPicker.presentCTPicker( on: self, textField: textField, items: wineryArray)
        /// // All navBar Colors changed and winery array can be added to
        ///  CTPicker.presentCTPicker(on: self, textField: textField, items: wineryArray, navBarBarTintColor: .blue, navBarTintColor: .white, navBartitleTextColor: .cyan, actionTintColor: .green, isAddEnabled: true)
        /// // Changing only tint color of the picker navBar.  Winery Array is read only
        ///  CTPicker.presentCTPicker(on: self, textField: textField, items: wineryArray, navBarTintColor: .red)
        ///
       
        /// ```
        
        static public func presentCTPicker(on vC:UIViewController, textField:UITextField, items:[String], navBarBarTintColor:UIColor? = nil, navBarTintColor:UIColor? = nil, navBartitleTextColor:UIColor? = nil, actionTintColor:UIColor? = nil, isAddEnabled:Bool = false ) {
            let presentingVc = CTPickerParentViewController()
            presentingVc.containerVC = CTPickerChildViewController()
            presentingVc.items = items
            presentingVc.selectedTextField = textField
            presentingVc.isAddEnabled = isAddEnabled
            presentingVc.navBarTintColor = navBarTintColor
            presentingVc.navBarBarTintColor = navBarBarTintColor
            presentingVc.navBartitleTextColor = navBartitleTextColor
            presentingVc.actionTintColor = actionTintColor
            if let vC = vC as? CTPickerDelegate {
                presentingVc.delegate = vC
            }
            presentingVc.providesPresentationContextTransitionStyle = true
            presentingVc.definesPresentationContext = true
            presentingVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            presentingVc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vC.present(presentingVc, animated: true, completion: nil)
        }
        
    }

