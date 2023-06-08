//
//  SleepViewModel.swift
//  WelcomingWellness
//
//  Created by Lee Chu on 6/7/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import FirebaseFirestore

class sleepViewModel: ObservableObject {
    
    @Published var hours = [Hours]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("sampleData").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No such documents exist.")
                return
            }
            
            self.hours = documents.map { (queryDocumentSnapshot) -> Hours in
                let data = queryDocumentSnapshot.data()
                let datey = data["date"] as? String ?? ""
                let hoursSlept = data["hours"] as? String ?? ""
                return Hours(datey: datey, hoursSlept: hoursSlept)
                
            }
            
        }
        
    }
    
    
    
}

