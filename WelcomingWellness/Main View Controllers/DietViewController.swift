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
import CoreML

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
    
//    var targetCalCount = 2000
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
       
   var docRef2: DocumentReference!
   
   public var fruitPrev: Int = 0
   public var vegetablePrev: Int = 0
   public var grainPrev: Int = 0
   public var proteinPrev: Int = 0
   public var dairyPrev: Int = 0
   
   var val: String = ""
   
   let db = Firestore.firestore()
   
   func getCurrentDay () -> String!{
       let date = Date()
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MM_dd_yyyy"
       let result = dateFormatter.string(from: date)
       return result
   }
   
   
   func fetchData() {
       print("func fetchData()")
       docRef = Firestore.firestore().document("dietData/" + (getCurrentDay()))
       docRef2 = Firestore.firestore().document("lifeStyleData/" + (getCurrentDay()))
       docRef.addSnapshotListener { (docSnapshot, error) in
           guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
           let myData = docSnapshot.data()
           self.fruitPrev = myData!["fruits"] as? Int ?? 0
           self.vegetablePrev = myData!["vegetables"] as? Int ?? 0
           self.grainPrev = myData!["grains"] as? Int ?? 0
           self.proteinPrev = myData!["proteins"] as? Int ?? 0
           self.dairyPrev = myData!["dairy"] as? Int ?? 0
       }
       if Auth.auth().currentUser != nil {
           do {
               let ref = db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid).collection("goals").document("Physical Goals")
               
               ref.addSnapshotListener { (docSnapshot, error) in
                   guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
                   let myData = docSnapshot.data()
                   let calorieTarget = Double(myData?["Target Calorie Level"] as? Int ?? 0)
                   self.processCalorieTarget(calorieTarget)
               }
               
           } catch let error {
               assertionFailure(error.localizedDescription)
           }
       } else {
           assertionFailure("No valid User")
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
       
       let tap = UITapGestureRecognizer(target: self, action: #selector(SleepViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)
   }
   
   @objc override func dismissKeyboard() {
       view.endEditing(true)
   }
   
   public var calorieTarget = 0.0
   

   func processCalorieTarget(_ calorieTarget: Double) {
       docRef = Firestore.firestore().document("dietData/" + (getCurrentDay()))
       docRef2 = Firestore.firestore().document("lifeStyleData/" + (getCurrentDay()))
       self.calorieTarget = calorieTarget
       print("in processCalorieTarget", self.calorieTarget)
       
       
       let dietDoc = db.collection("dietData").document(getCurrentDay())
       let lifeStyleDoc = db.collection("lifeStyleData").document(getCurrentDay ())
       
       dietDoc.getDocument { (document, error) in
           if let document = document, document.exists {
               let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
               //                print("Document data: \(dataDescription)")
           } else {
               print("Document does not exist")
               self.db.collection("dietData").document(self.getCurrentDay()).setData([:]) { err in
                   if let err = err {
                       print("Error writing doc: \(err)")
                   } else {
                       print("Doc successfully created")
                   }
               }
           }
       }
       
       lifeStyleDoc.getDocument { (document, error) in
           if let document = document, document.exists {
               let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
               //                print("Document data: \(dataDescription)")
           } else {
               print("Document does not exist")
               self.db.collection("lifeStyleData").document(self.getCurrentDay()).setData(["diet":0]) { err in
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
       
       var d = false
       for (cal, servings) in dietDict {
           if d == false {
               if Int(self.calorieTarget) == cal {
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
       
       
       self.currF = Double((fruitPrev+(Int(fruitCal) ?? 0)))/Double(targetF)
       self.currV = Double((vegetablePrev+(Int(vegetableCal) ?? 0)))/Double(targetV)
       self.currG = Double((grainPrev+(Int(grainCal) ?? 0)))/Double(targetG)
       self.currP = Double((proteinPrev+(Int(proteinCal) ?? 0)))/Double(targetP)
       self.currD = Double((dairyPrev+(Int(dairyCal) ?? 0)))/Double(targetD)
       
       //let total = targetF+targetV+targetG+targetP+targetD
       let currsss = currF+currV+currG+currP+currD
       var dietLifestyleScore = currsss/5.00
       
       if dietLifestyleScore > 1 {
           dietLifestyleScore = 1.00
       }
       print("dietLifestyleScore: ", dietLifestyleScore)
       
       let dataToSave: [String: Any] = ["fruits": fruitPrev+(Int(fruitCal) ?? 0), "vegetables": vegetablePrev+(Int(vegetableCal) ?? 0), "grains": grainPrev+(Int(grainCal) ?? 0), "proteins": proteinPrev+(Int(proteinCal) ?? 0), "dairy": dairyPrev+(Int(dairyCal) ?? 0), "dietLifeScore": dietLifestyleScore]
       docRef.setData(dataToSave) { (error) in
           if let error = error {
               print("errror: \(error.localizedDescription)")
           } else {
               print("Diet Data has been saved")
           }
       }
       
       docRef2.updateData(["diet": dietLifestyleScore])
       getRecommendation(calorieTarget)
   }
   
    func getRecommendation(_ calorieTarget: Double) {
        do {
            let config = MLModelConfiguration()
            let model = try DietRec(configuration: config)
            let target_calories = self.calcuate_target_cal(gender: "Female", weight: Double.random(in: 95 ..< 140), height: Double.random(in: 5 ..< 7), age: Int.random(in: 18 ..< 30), activity: "Moderate exercise (3-5 days/wk)")
            let r = Int.random(in: 1 ..< 1000)
            let s = "(" + String(r) + " g)"
            let x = String(Int.random(in: 1 ..< 2000)) + " cal"
            print("servings: ", s)
            print("calories: ", x)
            var prediction = try model.prediction(input: DietRecInput(Serving: s , Calories: x))
            while (prediction.Food == "Artichoke") {
                let r = Int.random(in: 1 ..< 1000)
                let s = "(" + String(r) + " g)"
                let x = String(Int.random(in: 1 ..< 2000)) + " cal"
                print("servings: ", s)
                print("calories: ", x)
                prediction = try model.prediction(input: DietRecInput(Serving: s , Calories: x))
            }
            print("this is the prediction: ", prediction.Food)
            
            docRef = Firestore.firestore().document("recommendationsData/" + (getCurrentDay()))
            let recsDoc = self.db.collection("recommendationsData").document(getCurrentDay())
            recsDoc.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self.docRef.updateData(["food rec": prediction.Food])
                } else {
                    print("Document does not exist")
                    self.db.collection("recommendationsData").document(self.getCurrentDay()).setData(["food rec": prediction.Food]) { err in
                            if let err = err {
                                print("Error writing doc: \(err)")
                            } else {
                                print("Doc successfully created")
                            }
                        }
                }
            }
            
            
        } catch {
            print("Error in prediction")
        }
    }
    
    func calcuate_target_cal(gender:String, weight:Double, height:Double, age:Int, activity: String) -> Double{

        func calculate_bmr() -> Double{
            var bmr = 0.0
            if (gender == "Male"){
                bmr = 10 * weight
                bmr = bmr + 6.25 * height - 5
                bmr = bmr * Double(age) + 5
            }else{
                bmr = 10 * weight
                bmr = bmr + 6.25 * height - 5
                bmr = bmr * Double(age) - 161
                
//                bmr = 10 * weight + 6.25 * height - 5 * age - 161
            }
            return bmr
        }


        func calories_calculator() -> Double{
            let activities = [
                "Little/no exercise",
                "Light exercise",
                "Moderate exercise (3-5 days/wk)",
                "Very active (6-7 days/wk)",
                "Extra active (very active & physical job)",
            ]
            let weights = [1.2, 1.375, 1.55, 1.725, 1.9]
            let weight = weights[activities.firstIndex(of: activity) ?? 3]
            let maintain_calories = calculate_bmr() * weight
            return maintain_calories
        }
        return calories_calculator()
    }
    
   @IBAction func buttonClicked(_ sender: Any) {
       print("Button tapped")
       fetchData()
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
}
