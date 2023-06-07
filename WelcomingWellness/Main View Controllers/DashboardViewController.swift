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
        
        let dietArray = db.collection("dietData").document(dateFormatter.string(from: date))
        dietArray.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                if let data = data {
                    currDiet = data["fruits"] as! Array<Int>
                    print("currDiet 1: ", currDiet)
                }
            } else {
                print("Document does not exist")
            }
        }
//        fetchData()
        print("currDiet 2: ", currDiet)
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
