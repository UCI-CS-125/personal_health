//
//  GoalsViewController.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 6/1/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

import UIKit
import HealthKit

class GoalsViewController: UIViewController{

    @IBOutlet weak var targetWeightTextField: UITextField!
    
    @IBOutlet weak var currentEnergyLevelTextField: UITextField!
    @IBOutlet weak var targetEnergyLevelTextField: UITextField!
    
    @IBOutlet weak var targetCalories: UITextField!
    @IBOutlet weak var targetHoursOfSleep: UITextField!
    var targetWeight:Double = 0.0
    var currentEnergyLevel:Double = 0.0
    var targetEnergyLevel:Double = 0.0
    var targetSleepLevel:Double = 0.0
    var targetCalorieLevel:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()

        
    }
    func convertTextToDouble(){
        let theText = targetWeightTextField.text ?? ""
        self.targetWeight = Double(theText) ?? 0.0
        
        let theEnergyLevel = targetEnergyLevelTextField.text ?? ""
        self.targetEnergyLevel = Double(theEnergyLevel) ?? 0.0
        
        let currentEnergyLevel = currentEnergyLevelTextField.text ?? ""
        self.currentEnergyLevel = Double(currentEnergyLevel) ?? 0.0

        let targetSleep = targetHoursOfSleep.text ?? ""
        self.targetSleepLevel = Double(targetSleep) ?? 0.0
        
        let targetCalorie = targetCalories.text ?? ""
        self.targetSleepLevel = Double(targetCalorie) ?? 0.0
        
    }

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}