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
        ///     - ctStrings: optional localized text strings.
        ///     - navBarBarTintColor: Optional color of the navigation bar background.
        ///     - navBarTintColor: Optional tintcolor for the navigation bar buttons.
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
        ///  CTPicker.presentCTPicker(on: self, textField: textField, items: wineryArray, navBarBarTintColor: .blue, navBarTintColor: .white, actionTintColor: .green, isAddEnabled: true)
        /// // Changing only tint color of the picker navBar.  Winery Array is read only
        ///  CTPicker.presentCTPicker(on: self, textField: textField, items: wineryArray, navBarTintColor: .red)
        ///
       
        /// ```
    
    public struct CTStrings {
        var pickText:String = "Tap on a line to select."
        var addText:String = "Tap '+' to add a new entry."
        var addAlertTitle:String = "Add new item"
        var addBtnTitle:String = "Add"
        var cancelBtnTitle:String = "Cancel"
    }
        
    static public func presentCTPicker(on vC:UIViewController, textField:UITextField, items:[String],ctStrings:CTPicker.CTStrings? = nil, navBarBarTintColor:UIColor? = nil, navBarTintColor:UIColor? = nil, actionTintColor:UIColor? = nil, isAddEnabled:Bool = false ) {
            let presentingVc = CTPickerParentViewController()
            presentingVc.containerVC = CTPickerChildViewController()
            presentingVc.items = items
            presentingVc.ctStrings = ctStrings
            presentingVc.selectedTextField = textField
            presentingVc.isAddEnabled = isAddEnabled
            presentingVc.navBarBarTintColor = navBarBarTintColor
            presentingVc.navBarTintColor = navBarTintColor
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

