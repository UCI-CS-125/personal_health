//
//  ExerciseViewController.swift
//  SmoothWalker
//
//  Created by Jason on 5/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import HealthKit

class ProfileViewController: UITableViewController {
    
  private enum ProfileSection: Int {
    case ageSexBloodType
    case weightHeightBMI
    case readHealthKitData
    case saveBMI
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
  
  @IBOutlet private var ageLabel:UILabel!
  @IBOutlet private var bloodTypeLabel:UILabel!
  @IBOutlet private var biologicalSexLabel:UILabel!
  @IBOutlet private var weightLabel:UILabel!
  @IBOutlet private var heightLabel:UILabel!
  @IBOutlet private var bodyMassIndexLabel:UILabel!
  
    
  private let userHealthProfile = UserHealthProfile()
  
  private func updateHealthInfo() {
    loadAndDisplayAgeSexAndBloodType()
    loadAndDisplayMostRecentWeight()
    loadAndDisplayMostRecentHeight()
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        updateHealthInfo()
        
    }
  

    
  private func loadAndDisplayAgeSexAndBloodType() {
    
    do {
        print("before loading")
      let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
        print("after function")
      userHealthProfile.age = userAgeSexAndBloodType.age
      userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
      userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
      updateLabels()
        print("In load and display")
        print(userHealthProfile)
    } catch let error {
      self.displayAlert(for: error)
    }
  }
  
  private func updateLabels() {
    
    if let age = userHealthProfile.age {
      ageLabel.text = "\(age)"
    }

    if let biologicalSex = userHealthProfile.biologicalSex {
        switch biologicalSex{
        case .female:
            biologicalSexLabel.text = "female"
        case .notSet:
            biologicalSexLabel.text = "no set"
        case .male:
            biologicalSexLabel.text = "male"
        case .other:
            biologicalSexLabel.text = "other"
        @unknown default:
            biologicalSexLabel.text = "other"
        }
//      biologicalSexLabel.text = biologicalSex.stringRepresentation
    }

    if let bloodType = userHealthProfile.bloodType {
        switch bloodType{
        case.aNegative:
            bloodTypeLabel.text = "A-"
        case .notSet:
            bloodTypeLabel.text = "notSet"
        case .aPositive:
            bloodTypeLabel.text = "A+"

        case .bPositive:
            bloodTypeLabel.text = "B+"

        case .bNegative:
            bloodTypeLabel.text = "B-"

        case .abPositive:
            bloodTypeLabel.text = "AB+"

        case .abNegative:
            bloodTypeLabel.text = "AB-"

        case .oPositive:
            bloodTypeLabel.text = "O+"
        case .oNegative:
            bloodTypeLabel.text = "O-"

        @unknown default:
            bloodTypeLabel.text = "not set"

        }
//      bloodTypeLabel.text = bloodType.stringRepresentation
    }
    
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
  
  //MARK:  UITableView Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let section = ProfileSection(rawValue: indexPath.section) else {
      fatalError("A ProfileSection should map to the index path's section")
    }
//    print("this is called", indexPath)
    switch section {
    case .saveBMI:
      saveBodyMassIndexToHealthKit()
    case .readHealthKitData:
      updateHealthInfo()
    default: break
    }
  }
}

