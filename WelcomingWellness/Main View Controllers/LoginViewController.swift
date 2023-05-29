//
//  FirebaseAuth.swift
//  WelcomingWellness
//
//  Created by Jason Wong on 5/28/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI
import FirebaseAuth

import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import FirebaseEmailAuthUI
import GoogleSignIn

typealias FIRUser = FirebaseAuth.User
class LoginViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    
    
    @IBAction func loginButton(_ sender: Any) {
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }

        // 2
        authUI.delegate = self
        
        
        
        let providers: [FUIAuthProvider] = [
          FUIEmailAuth(),
          FUIGoogleAuth(authUI: FUIAuth.defaultAuthUI()!),
        ]
        authUI.providers = providers

        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { _, user in
          if user == nil {
            self.navigationController?.popToRootViewController(animated: true)
//              print("no user")
          } else {
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//              print("there is a user", user as Any)
            self.performSegue(withIdentifier: "GrantPermission", sender: nil)
          }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
//            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }

        print("handle user signup / login")
        
    }
    
//    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//        if let error = error {
//            assertionFailure("Error signing in: \(error.localizedDescription)")
//            return
//        }
//
//        print("handle user signup / login")
//    }
}

