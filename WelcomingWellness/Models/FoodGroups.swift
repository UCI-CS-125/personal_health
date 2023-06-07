//
//  FoodGroups.swift
//  WelcomingWellness
//
//  Created by Ulia on 6/6/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct FoodGroup: Identifiable {
    var id: String = UUID().uuidString
    var fruitsPrev: Int
    var vegetablesPrev: Int
    var grainsPrev: Int
    var proteinsPrev: Int
    var dairyPrev: Int
}
