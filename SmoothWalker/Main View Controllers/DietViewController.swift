//
//  DietViewController.swift
//  SmoothWalker
//
//  Created by Serena Rupani on 5/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class DietViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var breakfast: UITextField!
    
    @IBOutlet weak var lunch: UITextField!
    
    @IBOutlet weak var dinner: UITextField!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakfast.delegate = self
        lunch.delegate = self
        dinner.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
      }

}

