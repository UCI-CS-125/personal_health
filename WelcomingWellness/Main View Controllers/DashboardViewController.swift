//
//  DashboardViewController.swift
//  SmoothWalker
//
//  Created by Serena Rupani on 5/3/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var animatedCountingLabel: UILabel!
    
    
    var LifestyleView: LifestyleScoreView!
    var LifestyleViewDuration: TimeInterval = 2
    var setScore: Double = 0.50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedCountingLabel.text = "50"
        setUpLifestyleScoreView()
    }
    
    func setUpLifestyleScoreView() {
        LifestyleView = LifestyleScoreView(frame: .zero)
        LifestyleView.frame = CGRect(x: 200, y: 250, width: view.frame.size.width, height: view.frame.size.height )
        LifestyleView.Animation(duration: LifestyleViewDuration, toValue: setScore)
        view.addSubview(LifestyleView)
    }

}
