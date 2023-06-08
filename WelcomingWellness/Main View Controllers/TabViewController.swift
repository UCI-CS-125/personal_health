//
//  TabViewController.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 5/11/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore



class TabViewController: UITabBarController {

            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        print("hello tab")
        


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
