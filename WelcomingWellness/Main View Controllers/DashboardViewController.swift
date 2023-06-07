//
//  DashboardViewController.swift
//  SmoothWalker
//
//  Created by Serena Rupani on 5/3/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DashboardViewController: UIViewController {
    
    public var dietDict: [Int:Dictionary] = [
        1000:["fruits":1, "vegetables":1, "grains":3, "proteins":2, "dairy":2],
        1200:["fruits":1, "vegetables":1.5, "grains":4, "proteins":3, "dairy":2.5],
        1400:["fruits":1.5, "vegetables":1.5, "grains":5, "proteins":4, "dairy":2.5],
        1600:["fruits":1.5, "vegetables":2, "grains":5, "proteins":5, "dairy":3],
        1800:["fruits":1.5, "vegetables":2.5, "grains":6, "proteins":5, "dairy":3],
        2000:["fruits":2, "vegetables":2.5, "grains":6, "proteins":5.5, "dairy":3],
        2200:["fruits":2, "vegetables":3, "grains":7, "proteins":6, "dairy":3],
        2400:["fruits":2, "vegetables":3, "grains":8, "proteins":6.5, "dairy":3],
        2600:["fruits":2, "vegetables":3.5, "grains":9, "proteins":6.5, "dairy":3],
        2800:["fruits":2.5, "vegetables":3.5, "grains":10, "proteins":7, "dairy":3],
        3000:["fruits":2.5, "vegetables":4, "grains":10, "proteins":7, "dairy":3],
        3200:["fruits":2.5, "vegetables":4, "grains":10, "proteins":7, "dairy":3]]
    
    
    let db = Firestore.firestore()

    @IBOutlet weak var animatedCountingLabel: UILabel!
    
    
    var LifestyleView: LifestyleScoreView!
    var LifestyleViewDuration: TimeInterval = 2
    var setScore: Double = 0.50
    var currDiet: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy"
        print(dateFormatter.string(from: date))
//        print("targ Cal: ", GoalsViewController.targetCalorieLevel)
        
//        let dietData = db.collection("dietData").document(dateFormatter.string(from: date))
//        dietArray.getDocument { [self] (document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
////                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
////                print("Document data: \(dataDescription)")
//                if let data = data {
//                    currDiet = data["fruits"] as! Array<Int>
//                    print("currDiet 1: ", currDiet)
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//        fetchData()
//        print("currDiet 2: ", currDiet)
        animatedCountingLabel.text = "50"
        setUpLifestyleScoreView()
    }
    
//    func fetchData() {
//      db.collection("dietData").addSnapshotListener { (querySnapshot, error) in
//        guard let documents = querySnapshot?.documents else {
//          print("No documents")
//          return
//        }
//
//        self.books = documents.compactMap { queryDocumentSnapshot -> Book? in
//          return try? queryDocumentSnapshot.data(as: Book.self)
//        }
//      }
//    }
    
    func setUpLifestyleScoreView() {
        LifestyleView = LifestyleScoreView(frame: .zero)
        LifestyleView.frame = CGRect(x: 200, y: 250, width: view.frame.size.width, height: view.frame.size.height )
        LifestyleView.Animation(duration: LifestyleViewDuration, toValue: setScore)
        view.addSubview(LifestyleView)
    }

}
