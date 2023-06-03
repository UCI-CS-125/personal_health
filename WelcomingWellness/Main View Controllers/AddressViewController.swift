//
//  AddressViewController.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 6/1/23.
//  Copyright © 2023 Apple. All rights reserved.
//


import Foundation

import UIKit
import HealthKit

class AddressViewController: UIViewController, UITextFieldDelegate {

    // MARK: - View Life Cycle
    
    @IBAction func done(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }

}
