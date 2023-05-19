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
    
    
    var circularProgressBarView: CircularProgressView!
    var circularViewDuration: TimeInterval = 2
    var circularViewProgress: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedCountingLabel.text = "50"
        setUpCircularProgressBarView()
    }
    
    func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressView(frame: .zero)
        // align to the center of the screen
        //circularProgressBarView.center = view.center
        circularProgressBarView.frame = CGRect(x: 200, y: 250, width: view.frame.size.width, height: view.frame.size.height )
        // call the animation with circularViewDuration
        circularProgressBarView.progressAnimation(duration: circularViewDuration, toValue: circularViewProgress)
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }

}
