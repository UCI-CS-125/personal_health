//
//  ProfileViewController.swift
//  WelcomingWellness
//
//  Created by Jason on 5/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import HealthKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UITableViewController {
    
  private enum ProfileSection: Int {
      case ageSexBloodType
      case weightHeightBMI
//      case goals
//      case readHealthKitData
//      case saveBMI
      case signout
      
  }
  
  private enum ProfileDataError: Error {
    
    case missingBodyMassIndex
    
    var localizedDescription: String {
      switch self {
      case .missingBodyMassIndex:
        return "Unable to calculate body mass index with available profile data."
      }
    }
  }
  
    @IBOutlet weak var NameLabel: UILabel!
    
  @IBOutlet private var ageLabel:UILabel!
  @IBOutlet private var bloodTypeLabel:UILabel!
  @IBOutlet private var biologicalSexLabel:UILabel!
  @IBOutlet private var weightLabel:UILabel!
  @IBOutlet private var heightLabel:UILabel!
  @IBOutlet private var bodyMassIndexLabel:UILabel!
  
    let db = Firestore.firestore()

  private let userHealthProfile = UserHealthProfile()
  private func updateHealthInfo() {
    loadAndDisplayAgeSexAndBloodType()
    loadAndDisplayMostRecentWeight()
    loadAndDisplayMostRecentHeight()
      
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        loadName()
        updateHealthInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        syncHealthWithFirestore()
     }
    private func syncHealthWithFirestore(){
        print("Labels")
        print(heightLabel.text)
        let user = Auth.auth().currentUser
        if user != nil {
            do {
                let ref = self.db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid)
                ref.updateData([
                    "age": self.userHealthProfile.age ??  -1,
                    "sex" : self.convertHKBiologicalSexToString(),
                    "bloodType":  convertHKBloodTypeToString(),
                    "height" : heightLabel.text,//janky
                    "weight": weightLabel.text, //janky
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
            assertionFailure("No user is logged in")
        }

        
    }
  
    private func loadName(){
        do{
            NameLabel.text = try ProfileDataStore.getNameEmailPhotoUrlUID().name

        }catch let error {
            self.displayAlert(for: error)
          }
//        firstNameLabel.text = ProfileDataStore().firstName
//        lastNameLabel.text = ProfileDataStore().lastName

    }
    
    
  private func loadAndDisplayAgeSexAndBloodType() {
    
    do {
      let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
      userHealthProfile.age = userAgeSexAndBloodType.age
      userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
      userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
      updateLabels()
    } catch let error {
      self.displayAlert(for: error)
    }
  }
  
    private func convertHKBiologicalSexToString() -> String{
        if let biologicalSex = userHealthProfile.biologicalSex {
            
            switch biologicalSex{
            case .female:
                return "female"
            case .notSet:
                return "not set"
            case .male:
                return "male"
            case .other:
                return "other"
            @unknown default:
                return "other"
            }
        }
        return "other"
    }
    
    private func convertHKBloodTypeToString() -> String{

        if let bloodType = userHealthProfile.bloodType {
            switch bloodType{
            case.aNegative:
               return "A-"
            case .notSet:
                return "notSet"
            case .aPositive:
                return "A+"

            case .bPositive:
                return "B+"

            case .bNegative:
                return "B-"

            case .abPositive:
                return "AB+"

            case .abNegative:
                return "AB-"

            case .oPositive:
                return "O+"
            case .oNegative:
                return "O-"

            @unknown default:
                return "not set"

            }
        }
        return "not set"
    }
    
  private func updateLabels() {
    
    if let age = userHealthProfile.age {
      ageLabel.text = "\(age)"
    }

      biologicalSexLabel.text = convertHKBiologicalSexToString()
      bloodTypeLabel.text = convertHKBloodTypeToString()
    
    if let weight = userHealthProfile.weightInKilograms {
      let weightFormatter = MassFormatter()
      weightFormatter.isForPersonMassUse = true
      weightLabel.text = weightFormatter.string(fromKilograms: weight)
    }
    
    if let height = userHealthProfile.heightInMeters {
      let heightFormatter = LengthFormatter()
      heightFormatter.isForPersonHeightUse = true
      heightLabel.text = heightFormatter.string(fromMeters: height)
    }
   
    if let bodyMassIndex = userHealthProfile.bodyMassIndex {
      bodyMassIndexLabel.text = String(format: "%.02f", bodyMassIndex)
    }
  }
  
  private func loadAndDisplayMostRecentHeight() {
    
    //1. Use HealthKit to create the Height Sample Type
    guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
      print("Height Sample Type is no longer available in HealthKit")
      return
    }
    
    ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
      
      guard let sample = sample else {
      
        if let error = error {
          self.displayAlert(for: error)
        }
        
        return
      }
      
      //2. Convert the height sample to meters, save to the profile model,
      //   and update the user interface.
      let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
      self.userHealthProfile.heightInMeters = heightInMeters
      self.updateLabels()
    }
  }
  
  private func loadAndDisplayMostRecentWeight() {

    guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
      print("Body Mass Sample Type is no longer available in HealthKit")
      return
    }
    
    ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
      
      guard let sample = sample else {
        
        if let error = error {
          self.displayAlert(for: error)
        }
        return
      }
      
      let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
      self.userHealthProfile.weightInKilograms = weightInKilograms
      self.updateLabels()
    }
  }
  
  private func saveBodyMassIndexToHealthKit() {
    
    guard let bodyMassIndex = userHealthProfile.bodyMassIndex else {
      displayAlert(for: ProfileDataError.missingBodyMassIndex)
      return
    }
    
    ProfileDataStore.saveBodyMassIndexSample(bodyMassIndex: bodyMassIndex,
                                             date: Date())
  }
  
  private func displayAlert(for error: Error) {
    
    let alert = UIAlertController(title: nil,
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "O.K.",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
    
    private func signUserOut() {
        print("Signing Out Button")
        do {
          try Auth.auth().signOut()
            
        } catch let error {
          print("Auth sign out failed: \(error)")
        }
      
    }
  
  //MARK:  UITableView Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let section = ProfileSection(rawValue: indexPath.section) else {
      fatalError("A ProfileSection should map to the index path's section")
    }
//    print("this is called", indexPath)
      print(section)
    switch section {

    case .signout:
        print("button pressed")
        signUserOut()
    default: break
    }
  }
}

