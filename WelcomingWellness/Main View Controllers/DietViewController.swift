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
    
    @IBOutlet weak var fruit: UITextField!
    
    @IBOutlet weak var vegetable: UITextField!
    
    @IBOutlet weak var grain: UITextField!
    
    @IBOutlet weak var protein: UITextField!
    
    @IBOutlet weak var dairy: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var docRef: DocumentReference!

    let db = Firestore.firestore()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fruit.delegate = self
        vegetable.delegate = self
        grain.delegate = self
        protein.delegate = self
        dairy.delegate = self
        
        docRef = Firestore.firestore().document("dietData/meals")

    }
    

    @IBAction func buttonClicked(_ sender: Any) {
        print("Button tapped")
        
        // Get previously stored array from firebase
        let dietArray = db.collection("dietData").document("meals")
        
        guard let fruitCal = fruit.text, !fruitCal.isEmpty else {return}
        guard let vegetableCal = vegetable.text, !vegetableCal.isEmpty else {return}
        guard let grainCal = grain.text, !grainCal.isEmpty else {return}
        guard let proteinCal = protein.text, !proteinCal.isEmpty else {return}
        guard let dairyCal = dairy.text, !dairyCal.isEmpty else {return}
        
        dietArray.updateData([
            "fruits": FieldValue.arrayUnion([Int(fruitCal) ?? 0]), "vegetables": FieldValue.arrayUnion([Int(vegetableCal) ?? 0]), "grains": FieldValue.arrayUnion([Int(grainCal) ?? 0]), "proteins": FieldValue.arrayUnion([Int(proteinCal) ?? 0]), "dairy": FieldValue.arrayUnion([Int(dairyCal) ?? 0])
        ])

//        let dataToSave: [String: Array] = ["fruits": fruitsArr, "vegetables": vegetablesArr, "grains": grainsArr, "proteins": proteinArr, "dairy": dairyArr]
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("errror: \(error.localizedDescription)")
//            } else {
//                print("Diet Data has been saved")
//            }
//        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
      }

}

