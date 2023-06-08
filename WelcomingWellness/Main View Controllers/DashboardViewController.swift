//
//  DashboardViewController.swift
//  WelcomingWellness
//
//  Created by Serena Rupani on 5/3/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import FirebaseFirestore


class DashboardViewController: UIViewController {
    
    func getDate() -> String!{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy"
        let res = dateFormatter.string(from: date)
        print(res)
        return res
    }

    @IBOutlet weak var animatedCountingLabel: UILabel!
    
    
    var LifestyleView: LifestyleScoreView!
    var LifestyleViewDuration: TimeInterval = 2
    var setScore: Double = 0.50
    
    var docRef: DocumentReference!
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        docRef = Firestore.firestore().document("lifeStyleData/" + (getDate()))
        docRef.addSnapshotListener { [self] (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = docSnapshot.data()
            let dietScore = myData!["diet"] as? Double ?? 0.0
            let exerciseScore = myData!["exercise"] as? Double ?? 0.0
            let sum_score = dietScore + exerciseScore
            let curr_score = sum_score / 2
            self.animatedCountingLabel.text = String(Int(curr_score*100))
            self.setScore = curr_score
            LifestyleView = LifestyleScoreView(frame: .zero)
            LifestyleView.frame = CGRect(x: 200, y: 250, width: view.frame.size.width, height: view.frame.size.height )
            LifestyleView.Animation(duration: LifestyleViewDuration, toValue: self.setScore)
            view.addSubview(LifestyleView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
