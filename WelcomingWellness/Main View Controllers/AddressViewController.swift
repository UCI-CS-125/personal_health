//
//  AddressViewController.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 6/1/23.
//  Copyright © 2023 Apple. All rights reserved.
//


import Foundation

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

public struct Address : Codable{
    var StreetAddress: String
    var City: String
    var State: String
    var ZipCode: String
    
    enum CodingKeys: String, CodingKey {
        case StreetAddress
        case City
        case State
        case ZipCode
    }
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}


class AddressViewController: UIViewController, UITextFieldDelegate {

    // MARK: - View Life Cycle
    
    
    
    @IBOutlet weak var StreetAddressOne: UITextField!
    
    @IBOutlet weak var CityOne: UITextField!
    
    @IBOutlet weak var StateOne: UITextField!
    
    @IBOutlet weak var ZipcodeOne: UITextField!
    
    @IBOutlet weak var StreetAddressTwo: UITextField!
    
    @IBOutlet weak var CityTwo: UITextField!
    
    @IBOutlet weak var StateTwo: UITextField!
    
    @IBOutlet weak var ZipcodeTwo: UITextField!
    
    
    @IBAction func done(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func getAddressData() -> (addressOne: Address, addressTwo: Address){
        let homeAddress = Address(StreetAddress: StreetAddressOne.text ?? "", City: CityOne.text ?? "", State: StateOne.text ?? "", ZipCode: ZipcodeOne.text ?? "")
        let workAddress = Address(StreetAddress: StreetAddressTwo.text ?? "", City: CityTwo.text ?? "", State: StateTwo.text ?? "", ZipCode: ZipcodeTwo.text ?? "")
        return (homeAddress, workAddress)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            if(segue.identifier == "NextAddress"){

                let addressOne = self.getAddressData().addressOne
                let addressTwo = self.getAddressData().addressTwo
                do {
                    let ref = db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid)
                    ref.updateData([
                        "Home Address": addressOne.dictionary
                    ])
                    { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    ref.updateData([
                        "Work Address": addressTwo.dictionary
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
                
            } else if (segue.identifier == "ToGoals"){
                let addressOne = self.getAddressData().addressOne
                let addressTwo = self.getAddressData().addressTwo
                do {
                    let ref = db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid)
                    ref.updateData([
                        "Favorite Address": addressOne.dictionary
                    ])
                    { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    ref.updateData([
                        "Second Favorite Address": addressTwo.dictionary
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
            }
        } else {
          assertionFailure("No valid User")
        }

    }

}
