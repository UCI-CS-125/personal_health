//
//  UserHealthProfile.swift
//  SmoothWalker
//
//  Created by Jason Wong on 5/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import HealthKit

class UserHealthProfile {
  
  var age: Int?
  var biologicalSex: HKBiologicalSex?
  var bloodType: HKBloodType?
  var heightInMeters: Double?
  var weightInKilograms: Double?
  
  var bodyMassIndex: Double? {
    
    guard let weightInKilograms = weightInKilograms,
      let heightInMeters = heightInMeters,
      heightInMeters > 0 else {
        return nil
    }
    
    return (weightInKilograms/(heightInMeters*heightInMeters))
  }
}
