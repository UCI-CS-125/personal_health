//
//  DietViewController.swift
//  SmoothWalker
//
//  Created by Serena Rupani on 5/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DietViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var breakfast: UITextField!
    
    @IBOutlet weak var lunch: UITextField!
    
    @IBOutlet weak var dinner: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var docRef: DocumentReference!
    
    @IBAction func saveTapped(_sender: UIButton!) {
        guard let breakfastText = breakfast.text, !breakfastText.isEmpty else {return}
        guard let lunchText = lunch.text, !lunchText.isEmpty else {return}
        guard let dinnerText = dinner.text, !dinnerText.isEmpty else {return}
        let dataToSave: [String: Any] = ["breakfast": breakfastText, "lunch": lunchText, "dinner": dinnerText]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("errror: \(error.localizedDescription)")
            } else {
                print("Diet Data has been saved")
            }
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakfast.delegate = self
        lunch.delegate = self
        dinner.delegate = self
        
        docRef = Firestore.firestore().document("dietData/meals")

    }
    

    @IBAction func buttonClicked(_ sender: Any) {
        print("Button tapped")
        guard let breakfastText = breakfast.text, !breakfastText.isEmpty else {return}
        guard let lunchText = lunch.text, !lunchText.isEmpty else {return}
        guard let dinnerText = dinner.text, !dinnerText.isEmpty else {return}
        let dataToSave: [String: Any] = ["breakfast": breakfastText, "lunch": lunchText, "dinner": dinnerText]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("errror: \(error.localizedDescription)")
            } else {
                print("Diet Data has been saved")
            }
        }
    }
    
//    func buttonAction(sender: UIButton!) {
//      print("Button tapped")
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
      }

}

