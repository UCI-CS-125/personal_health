//
//  ViewSleep.swift
//  SmoothWalker
//
//  Created by Ben Landry on 5/3/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct HoursSlept: Identifiable {
    let id = UUID()
    let theDate: Date
    let hours: Int
    
    init(day: String, hours: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        self.theDate = formatter.date(from: day) ?? Date.distantPast
        self.hours = hours
    }
    
    var weekdayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return  dateFormatter.string(from: theDate)
    }
}
