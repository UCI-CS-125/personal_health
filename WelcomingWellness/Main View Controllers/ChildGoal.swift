//
//  ChildGoal.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 5/19/23.
//  Copyright © 2023 Apple. All rights reserved.
//


import UIKit
import HealthKit
import SwiftUI

class ChildGoal: UIViewController {
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIHostingController(rootView: ExerciseGoals())
        let swiftuiView = vc.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        
        // 2
        // Add the view controller to the destination view controller.
        addChild(vc)
        view.addSubview(swiftuiView)
        
        // 3
        // Create and activate the constraints for the swiftui's view.
        NSLayoutConstraint.activate([
            swiftuiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftuiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // 4
        // Notify the child view controller that the move is complete.
        vc.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
