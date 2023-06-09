//
//  ExerciseViewController.swift
//  WelcomingWellness
//
//  Created by Ulia on 5/1/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import SwiftUI

class ExerciseViewController: UIViewController {

//    @IBOutlet weak var titleLabel: UILabel!
    
    enum Segues {
        static let toExerciseFirstChild = "ToExerciseFirstChildVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarItem.title
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toExerciseFirstChild {
            let destVC = segue.destination as! MobilityChartDataViewController
//            let destVC = segue.destination as! MobilityChartDataViewController
            let viewController = MobilityChartDataViewController()
//            let viewController = ExerciseFirstChildVC()
            destVC.present(viewController, animated: false)
//            destVC.view.addSubview(viewController.view)
//            destVC.view.backgroundColor = .blue
        }
    }
    
    @IBSegueAction func notifsSegue(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: NotificationsView())
    }

}
