//
//  DietViewController.swift
//  WelcomingWellness
//
//  Created by Serena Rupani on 5/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class DietViewController: UIViewController, UITextFieldDelegate {
    public var dietDict: [Int:Dictionary] = [
        1000:["fruits":1, "vegetables":1, "grains":3, "proteins":2, "dairy":2],
        1200:["fruits":1, "vegetables":1, "grains":4, "proteins":3, "dairy":2],
        1400:["fruits":1, "vegetables":1, "grains":5, "proteins":4, "dairy":2],
        1600:["fruits":1, "vegetables":2, "grains":5, "proteins":5, "dairy":3],
        1800:["fruits":2, "vegetables":2, "grains":6, "proteins":5, "dairy":3],
        2000:["fruits":2, "vegetables":2, "grains":6, "proteins":5, "dairy":3],
        2200:["fruits":2, "vegetables":3, "grains":7, "proteins":6, "dairy":3],
        2400:["fruits":2, "vegetables":3, "grains":8, "proteins":6, "dairy":3],
        2600:["fruits":2, "vegetables":3, "grains":9, "proteins":6, "dairy":3],
        2800:["fruits":3, "vegetables":4, "grains":10, "proteins":7, "dairy":3],
        3000:["fruits":3, "vegetables":4, "grains":10, "proteins":7, "dairy":3],
        3200:["fruits":3, "vegetables":4, "grains":10, "proteins":7, "dairy":3]]
    
    var targetCalCount = 2000
    var targetF = 0
    var targetV = 0
    var targetG = 0
    var targetP = 0
    var targetD = 0
    public var currF = 0.0
    public var currV = 0.0
    public var currG = 0.0
    public var currP = 0.0
    public var currD = 0.0
    
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
    
    }
    
    func getTargets() {
        var d = false
        for (cal, servings) in dietDict {
            if d == false {
                if targetCalCount == cal {
                    targetF = servings["fruits"]!
                    targetV = servings["vegetables"]!
                    targetG = servings["grains"]!
                    targetP = servings["proteins"]!
                    targetD = servings["dairy"]!
                    d = true
                    break
                }
            }
        }
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
        
        getTargets()
        self.currF = Double((fruitPrev+(Int(fruitCal) ?? 0)))/Double(targetF)
        self.currV = Double((vegetablePrev+(Int(vegetableCal) ?? 0)))/Double(targetV)
        self.currG = Double((grainPrev+(Int(grainCal) ?? 0)))/Double(targetG)
        self.currP = Double((proteinPrev+(Int(proteinCal) ?? 0)))/Double(targetP)
        self.currD = Double((dairyPrev+(Int(dairyCal) ?? 0)))/Double(targetD)
        
        let total = targetF+targetV+targetG+targetP+targetD
        let currsss = currF+currV+currG+currP+currD
        let dietLifestyleScore = currsss/Double(total)
        print("dietLifestyleScore: ", dietLifestyleScore)
        
        let dataToSave: [String: Any] = ["fruits": fruitPrev+(Int(fruitCal) ?? 0), "vegetables": vegetablePrev+(Int(vegetableCal) ?? 0), "grains": grainPrev+(Int(grainCal) ?? 0), "proteins": proteinPrev+(Int(proteinCal) ?? 0), "dairy": dairyPrev+(Int(dairyCal) ?? 0), "dietLifeScore": dietLifestyleScore]
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

