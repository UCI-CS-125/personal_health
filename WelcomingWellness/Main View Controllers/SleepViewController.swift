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
    
    
    func getCurrentDay () -> String!{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hoursSleptTextField: UITextField!
    
    var docRef : DocumentReference!
    
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

