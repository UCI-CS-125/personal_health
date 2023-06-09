//  SleepViewController.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 5/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import CoreML
import UIKit
import SwiftUI
import Charts
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Foundation



struct Hours: Identifiable {
    var id: String = UUID().uuidString
    var datey: String
    var hoursSlept: String
}

class SleepViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    public var hoursHelp: Int = 0
    public var wakeupHour: Int = 0
    public var wakeupMin: Int = 0
    
    func getCurrentDay () -> String!{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd_MM_yyyy"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    func getCurrentDay2 () -> String!{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    public var sleepTarget = 0.0
        
    func fetchData() {
        print("func fetchData()")
        
        if Auth.auth().currentUser != nil {
            do {
                let ref = db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid).collection("goals").document("Physical Goals")
                
                ref.addSnapshotListener { (docSnapshot, error) in
                    guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
                    let myData = docSnapshot.data()
                    let sleepTarget = Double(myData?["Target Sleep Level"] as? Int ?? 0)
                    self.processSleepTarget(sleepTarget)
                }
                
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        } else {
            assertionFailure("No valid User")
        }
    }

    func processSleepTarget(_ sleepTarget: Double) {
        self.sleepTarget = sleepTarget
        print("in processSleepTarget", self.sleepTarget)
        
        docRef2 = Firestore.firestore().document("lifeStyleData/" + (getCurrentDay2()))
        
        let lifeStyleDoc = self.db.collection("lifeStyleData").document(getCurrentDay2())
        
        var sleep_score = Double(self.hoursHelp) / 8.00
        
        if sleep_score > 1{
            sleep_score = 1.00
        }
        
        print("sleep_score: ", sleep_score)
        
        lifeStyleDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
                self.db.collection("lifeStyleData").document(self.getCurrentDay2()).setData(["sleep": sleep_score]) { err in
                        if let err = err {
                            print("Error writing doc: \(err)")
                        } else {
                            print("Doc successfully created")
                        }
                    }
            }
        }
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hoursSleptTextField: UITextField!
    @IBOutlet weak var wakeupHourTextField: UITextField!
    @IBOutlet weak var wakeupMinuteTextField: UITextField!
    
    var docRef : DocumentReference!
    var docRef2 : DocumentReference!
    
    @IBAction func saver(_ sender: UIButton) {
        guard let dateText =  dateTextField.text, !dateText.isEmpty else {return}
        guard let hoursText =  hoursSleptTextField.text, !hoursText.isEmpty else {return}
        guard let wakeupHourText = wakeupHourTextField.text, !wakeupHourText.isEmpty else {return}
        guard let wakeupMinText = wakeupMinuteTextField.text, !wakeupMinText.isEmpty else {return}
        let dataToSave: [String: Any] = ["date": dateText, "hours" : (hoursText), "wakeup hour" : wakeupHourText, "wakeup minute" : wakeupMinText]
        
        self.hoursHelp = Int(hoursText) ?? 0
        self.wakeupHour = Int(wakeupHourText) ?? 0
        self.wakeupMin = Int(wakeupMinText) ?? 0
        
        fetchData()

        Firestore.firestore().collection("sampleData").document(getCurrentDay()).setData(dataToSave)
        { err in
            if let err = err {
                print("OH NO! Error occurred. Here it is: \(err.localizedDescription)")
            } else {
                print("Woohoo! Sleep hours have been stored!")
            }
        }
        
        getRecommendation()
    }
    
    func getRecommendation() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepRec(configuration: config)
            let hour = self.wakeupHour * 60 * 60
            let min = self.wakeupMin * 60
            let prediction = try model.prediction(wake: Double(hour + min), estimatedSleep: Double(self.hoursHelp), coffee: 0.0)
            var sleepTime = Double(hour + min) - prediction.actualSleep
            let number = Int.random(in: 86200 ..< 86600)
//            print("Number: \(number)")
            sleepTime = Double(number) - sleepTime
            let mini = (sleepTime/60)
            let houry = Int(mini/60)
            let pred = String(houry) + ":" + String(Int(mini-(Double(houry*60)))) + " PM"
            print("prediction: ", sleepTime, "; ", "pred: ", pred)
            docRef = Firestore.firestore().document("recommendationsData/" + (getCurrentDay2()))
            let recsDoc = self.db.collection("recommendationsData").document(getCurrentDay2())
            recsDoc.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self.docRef.updateData(["sleepRec": pred])
                } else {
                    print("Document does not exist")
                    self.db.collection("recommendationsData").document(self.getCurrentDay2()).setData(["sleepRec": pred]) { err in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarItem.title
        let tap = UITapGestureRecognizer(target: self, action: #selector(SleepViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
//        docRef = Firestore.firestore().collection("sampleData").document("hoursSleptDoc")
        
    }
    
    @IBSegueAction func showSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SleepContentView())
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    enum Segues {
        static let toSleepContentView = "toSleepContentView"
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Segues.toSleepContentView {
//            let destVC = segue.destination as! SleepContentView
//            let viewController = SleepContentView()
//            destVC.present(viewController, animated: false)
//
//        }
//    }
}

