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
import FirebaseAuth
import FirebaseFirestore

class GoalsViewController: UIViewController{

    @IBOutlet weak var targetWeightTextField: UITextField!
    
    @IBOutlet weak var currentEnergyLevelTextField: UITextField!
    @IBOutlet weak var targetEnergyLevelTextField: UITextField!
    
    @IBOutlet weak var targetCalories: UITextField!
    @IBOutlet weak var targetHoursOfSleep: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var targetWeight:Double = 0.0
    var currentEnergyLevel:Double = 0.0
    var targetEnergyLevel:Double = 0.0
    var targetSleepLevel:Double = 0.0
    public var targetCalorieLevel:Double = 0.0
    
//    var usergoals = [UserGoals]
    
//    func getTargetCalorieLevel() {
//        return targetCalorieLevel
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func convertTextToDouble(_ sender: Any){
        let theText = targetWeightTextField.text ?? ""
        self.targetWeight = Double(theText) ?? 0.0
        
        let theEnergyLevel = targetEnergyLevelTextField.text ?? ""
        self.targetEnergyLevel = Double(theEnergyLevel) ?? 0.0
        
        let currentEnergyLevel = currentEnergyLevelTextField.text ?? ""
        self.currentEnergyLevel = Double(currentEnergyLevel) ?? 0.0

        let targetSleep = targetHoursOfSleep.text ?? ""
        self.targetSleepLevel = Double(targetSleep) ?? 0.0
        
        let targetCalorie = targetCalories.text ?? ""
        self.targetCalorieLevel = Double(targetCalorie) ?? 0.0
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            do{
                let ref = db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid).collection("goals").document("Physical Goals")
                    ref.setData([
                        "Target Weight":self.targetWeight,
                        "Target Energy Level":self.targetEnergyLevel,
                        "Current Energy Level": self.currentEnergyLevel,
                        "Target Sleep Level": self.targetSleepLevel,
                        "Target Calorie Level": self.targetSleepLevel

                    ])
                    { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }

                    
                }catch let error {
                    assertionFailure(error.localizedDescription)
                  }
        } else {
          assertionFailure("No valid User")
        }

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
