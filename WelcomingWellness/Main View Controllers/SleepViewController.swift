//  SleepViewController.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 5/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

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
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hoursSleptTextField: UITextField!
    
    var docRef : DocumentReference!
    var docRef2 : DocumentReference!
    
    @IBAction func saver(_ sender: UIButton) {
        guard let dateText =  dateTextField.text, !dateText.isEmpty else {return}
        guard let hoursText =  hoursSleptTextField.text, !hoursText.isEmpty else {return}
        let dataToSave: [String: Any] = ["date": dateText, "hours" : (hoursText)]
        
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("OH NO! Error occurred. Here it is: \(error.localizedDescription)")
//            } else {
//                print("Woohoo! Sleep hours have been stored!")
//            }
//        }
        Firestore.firestore().collection("sampleData").document(getCurrentDay()).setData(dataToSave)
        { err in
            if let err = err {
                print("OH NO! Error occurred. Here it is: \(err.localizedDescription)")
            } else {
                print("Woohoo! Sleep hours have been stored!")
            }
        }
        docRef2 = Firestore.firestore().document("lifeStyleData/" + (getCurrentDay2()))
        
        let lifeStyleDoc = self.db.collection("lifeStyleData").document(getCurrentDay2())
        
        let hours_slept = Int(hoursText) ?? 0
        var sleep_score = Double(hours_slept) / 8.00
        
        if sleep_score > 1{
            sleep_score = 1.00
        }
        
        print(sleep_score)
        
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
        
        docRef2.updateData(["sleep": sleep_score])
        
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
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
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

