//
//  DietViewController.swift
//  SmoothWalker
//
//  Created by Serena Rupani on 5/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

//https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/suggested-servings-from-each-food-group


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class DietViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fruit: UITextField!
    
    @IBOutlet weak var vegetable: UITextField!
    
    @IBOutlet weak var grain: UITextField!
    
    @IBOutlet weak var protein: UITextField!
    
    @IBOutlet weak var dairy: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var docRef: DocumentReference!
    
    public var fruitPrev: Int = 0
    public var vegetablePrev: Int = 0
    public var grainPrev: Int = 0
    public var proteinPrev: Int = 0
    public var dairyPrev: Int = 0
    
    var val: String = ""
//    var foods = [FoodGroup]()

    let db = Firestore.firestore()
    
    func fetchData() {
        print("func fetchData()")
        docRef.addSnapshotListener { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            self.fruitPrev = myData!["fruits"] as? Int ?? 0
            self.vegetablePrev = myData!["vegetables"] as? Int ?? 0
            self.grainPrev = myData!["grains"] as? Int ?? 0
            self.proteinPrev = myData!["proteins"] as? Int ?? 0
            self.dairyPrev = myData!["dairy"] as? Int ?? 0
//            print("fruitPrev 1: ", self.fruitPrev)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fruit.delegate = self
        vegetable.delegate = self
        grain.delegate = self
        protein.delegate = self
        dairy.delegate = self
        
        fruit.text = "0"
        vegetable.text = "0"
        grain.text = "0"
        protein.text = "0"
        dairy.text = "0"
        
//        docRef = Firestore.firestore().document("dietData/" + (dateFormatter.string(from: date)))

    }
    

    @IBAction func buttonClicked(_ sender: Any) {
        print("Button tapped")
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy"
        print(dateFormatter.string(from: date))

        docRef = Firestore.firestore().document("dietData/" + (dateFormatter.string(from: date)))
        
        fetchData()
        
        let dietDoc = db.collection("dietData").document(dateFormatter.string(from: date))
        
        dietDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
                self.db.collection("dietData").document(dateFormatter.string(from: date)).setData([:]) { err in
                        if let err = err {
                            print("Error writing doc: \(err)")
                        } else {
                            print("Doc successfully created")
                        }
                    }
            }
        }
        
        guard let fruitCal = fruit.text, !fruitCal.isEmpty else {return}
        guard let vegetableCal = vegetable.text, !vegetableCal.isEmpty else {return}
        guard let grainCal = grain.text, !grainCal.isEmpty else {return}
        guard let proteinCal = protein.text, !proteinCal.isEmpty else {return}
        guard let dairyCal = dairy.text, !dairyCal.isEmpty else {return}
        
        let dataToSave: [String: Int] = ["fruits": fruitPrev+(Int(fruitCal) ?? 0), "vegetables": vegetablePrev+(Int(vegetableCal) ?? 0), "grains": grainPrev+(Int(grainCal) ?? 0), "proteins": proteinPrev+(Int(proteinCal) ?? 0), "dairy": dairyPrev+(Int(dairyCal) ?? 0)]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("errror: \(error.localizedDescription)")
            } else {
                print("Diet Data has been saved")
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
      }

}

