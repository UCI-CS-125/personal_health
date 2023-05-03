//
//  ExerciseViewController.swift
//  SmoothWalker
//
//  Created by Jason on 5/2/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var ProfileImageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarItem.title
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {

            super.viewWillAppear(true)

//            ProfileImageView.image = #imageLiteral(resourceName: "checkmark.jpeg")
//
//            self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
//
//            self.ProfileImageView.clipsToBounds = true
//
//            self.ProfileImageView.layer.borderColor = UIColor.white.cgColor
//
//            self.ProfileImageView.layer.borderWidth = 5

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
