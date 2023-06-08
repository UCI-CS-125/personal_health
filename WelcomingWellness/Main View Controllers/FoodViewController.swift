//
//  FoodViewController.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 6/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FoodViewController: UIViewController {
    var dietType: String = "No Preference"
    @IBOutlet weak var DietRestrictions: UIButton!
    
    @IBOutlet weak var GlutenSwitch: UISwitch!
    
    @IBOutlet weak var PeanutAllergy: UISwitch!
    
    @IBOutlet weak var DairySwitch: UISwitch!
    
    @IBOutlet weak var TreeNuts: UISwitch!
    
    @IBOutlet weak var Seasme: UISwitch!
    @IBOutlet weak var Shellfish: UISwitch!
    @IBOutlet weak var Fish: UISwitch!
    @IBOutlet weak var Wheat: UISwitch!
    @IBOutlet weak var Eggs: UISwitch!
    var glutenSwitchState:Bool {
        return GlutenSwitch.isOn
    }
    var peanutSwitchState:Bool {
        return PeanutAllergy.isOn
    }
    var dairySwitchState:Bool {
        return DairySwitch.isOn
    }
    var treeNutsSwitchState:Bool {
        return TreeNuts.isOn
    }
    var seasmeSwitch:Bool {
        return Seasme.isOn
    }
    var shellfishSwitchState:Bool {
        return Shellfish.isOn
    }
    var fishSwitchState:Bool {
        return Fish.isOn
    }
    var wheatState:Bool {
        return Wheat.isOn
    }
    var eggState:Bool {
        return Eggs.isOn
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // This view controller itself will provide the delegate methods and row data for the table view.
        let optionsClosure = { (action: UIAction) in
          print(action.title)
            self.dietType = action.title
        }
        DietRestrictions.menu = UIMenu(children: [
          UIAction(title: "No Preference", state: .on, handler: optionsClosure),
          UIAction(title: "Vegeterian", handler: optionsClosure),
          UIAction(title: "Vegan", handler: optionsClosure)
        ])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            do{
                let ref = db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid).collection("diet").document("restrictions")
                    ref.setData([
                        "Allegries":[
                        "Gluten Allergy":self.glutenSwitchState,
                        "Peanut Allergy":self.peanutSwitchState,
                        "TreeNut Allergy":self.treeNutsSwitchState,
                        "Seasme Allergy":self.seasmeSwitch,
                        "Shellfish Allergy":self.shellfishSwitchState,
                        "Fish Allergy":self.fishSwitchState,
                        "Wheat Allergy":self.wheatState,
                        "Eggs Allergy":self.eggState],
                        "DietType": self.dietType
                        
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
        } else {
          assertionFailure("No valid User")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

}
