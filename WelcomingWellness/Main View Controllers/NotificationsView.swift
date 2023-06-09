//
//  NotificationsView.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 6/9/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftUI
import UIKit

struct NotificationsView: View {
    var body: some View {
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
                    if success {
                        print("You're all set to receive notifications!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Start Receiving My Exercise Notifications!") {
                let contentMorning = UNMutableNotificationContent()
                contentMorning.title = "Welcoming Wellness"
                contentMorning.subtitle = "Remember to take a walk today!"
                contentMorning.sound = UNNotificationSound.default
                
                let contentAfternoon = UNMutableNotificationContent()
                contentAfternoon.title = "Welcoming Wellness"
                contentAfternoon.subtitle = "Hit the gym! You'll feel great!"
                contentAfternoon.sound = UNNotificationSound.default
                
                let contentEvening = UNMutableNotificationContent()
                contentEvening.title = "Welcoming Wellness"
                contentEvening.subtitle = "Get your step count up!"
                contentEvening.sound = UNNotificationSound.default
                
                
                var dateInfoMorning = DateComponents()
                dateInfoMorning.day = 9
                dateInfoMorning.month = 6
                dateInfoMorning.year = 2023
                dateInfoMorning.hour = 9
                dateInfoMorning.minute = 00
                
                var dateInfoAfternoon = DateComponents()
                dateInfoAfternoon.day = 9
                dateInfoAfternoon.month = 6
                dateInfoAfternoon.year = 2023
                dateInfoAfternoon.hour = 12
                dateInfoAfternoon.minute = 00
                
                var dateInfoEvening = DateComponents()
                dateInfoEvening.day = 9
                dateInfoEvening.month = 6
                dateInfoEvening.year = 2023
                dateInfoEvening.hour = 18
                dateInfoEvening.minute = 00
                
                //tester trigger for demo
                let trigger5sec = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let triggerMorning = UNCalendarNotificationTrigger(dateMatching: dateInfoMorning, repeats: true)
                let triggerAfternoon = UNCalendarNotificationTrigger(dateMatching: dateInfoAfternoon, repeats: true)
                let triggerEvening = UNCalendarNotificationTrigger(dateMatching: dateInfoEvening, repeats: true)

                let requestMorning = UNNotificationRequest(identifier: UUID().uuidString, content: contentMorning, trigger: triggerMorning)
                let requestAfternoon = UNNotificationRequest(identifier: UUID().uuidString, content: contentAfternoon, trigger: triggerAfternoon)
                let requestEvening = UNNotificationRequest(identifier: UUID().uuidString, content: contentEvening, trigger: triggerEvening)
                
                //tester for demo
                let request5sec = UNNotificationRequest(identifier: UUID().uuidString, content: contentEvening, trigger: trigger5sec)

                // add our notification request
                UNUserNotificationCenter.current().add(request5sec)
                UNUserNotificationCenter.current().add(requestMorning)
                UNUserNotificationCenter.current().add(requestAfternoon)
                UNUserNotificationCenter.current().add(requestEvening)
                
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
