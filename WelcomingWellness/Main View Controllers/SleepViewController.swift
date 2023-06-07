
//
//  SleepViewController.swift
//  SmoothWalker
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

class SleepViewController: UIViewController {
    
    
    @IBOutlet weak var hoursSleptTextField: UITextField!
    
    var docRef : DocumentReference!
    
    @IBAction func saver(_ sender: UIButton) {
        guard let hoursText =  hoursSleptTextField.text, !hoursText.isEmpty else {return}
        let dataToSave: [String: Any] = ["hours" : hoursText]
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("OH NO! Error occurred. Here it is: \(error.localizedDescription)")
//            } else {
//                print("Woohoo! Sleep hours have been stored!")
//            }
//        }
        Firestore.firestore().collection("sampleData").document("hoursSleptDoc").setData(dataToSave)
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
//        docRef = Firestore.firestore().collection("sampleData").document("hoursSleptDoc")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

