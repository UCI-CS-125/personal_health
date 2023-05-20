
//
//  SleepViewController.swift
//  SmoothWalker
//
//  Created by Ben Landry on 5/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import SwiftUI
import Charts
class SleepViewController: UIViewController {
    @available(iOS 16.0, *)
    struct Viewsy: View {
        let currentWeek: [HoursSlept] = [
            HoursSlept(day: "20220716", hours: 6),
            HoursSlept(day: "20220717", hours: 6),
            HoursSlept(day: "20220718", hours: 7),
            HoursSlept(day: "20220719", hours: 4),
            HoursSlept(day: "20220720", hours: 5),
            HoursSlept(day: "20220721", hours: 5),
            HoursSlept(day: "20220722", hours: 8),
            HoursSlept(day: "20220723", hours: 9)
        ]

        var body: some View {
            VStack {
                GroupBox ( "Hours of Sleep") {
                    Chart(currentWeek) {
                        BarMark(
                            x: .value("Week Day", $0.theDate, unit: .day),
                            y: .value("Hours of Sleep", $0.hours)
                        )
                    }
                }
                .frame(height: 500)

                Spacer()
            }
            .padding()
        }
    }



    @available(iOS 16.0, *)
    struct HomePreviews: PreviewProvider{
        static var previews: some View{
            Viewsy()
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarItem.title
    }

}
