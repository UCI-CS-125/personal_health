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
import FirebaseFirestore

typealias FIRUser = FirebaseAuth.User
class LoginViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    var newUser:Bool = false

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

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
        print("inside authUI")
        if let error = error {
            print(error.localizedDescription)
//            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        handle = Auth.auth().addStateDidChangeListener { _, user in
          if user == nil {
            self.navigationController?.popToRootViewController(animated: true)
              
//              print("no user")
          } else {
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//              print("there is a user", user as Any)
              var ref: DocumentReference? = nil
              do{
                  ref = self.db.collection("users").document(try ProfileDataStore.getNameEmailPhotoUrlUID().uid)

                  
              } catch let error {
                  assertionFailure(error.localizedDescription)
                }
              
              ref?.getDocument { (document, error) in
                  if let document = document, document.exists {
                      self.newUser = false
                      print("existing user")

                  } else {
                      self.newUser = true
                      print("New User")
                      ref!.setData([
                        "name": user?.displayName ?? "[Display Name]",
                      ])
                      { err in
                          if let err = err {
                              print("Error writing document: \(err)")
                          } else {
                              print("Document successfully written!")
                          }
                      }
                  }
                  
                  print(self.newUser)
                  if self.newUser == false{
                      print("Segue Existing User")
                      self.performSegue(withIdentifier: "ExistingUser", sender: nil)
                  }else{
                      print("Segue New User")
                      self.performSegue(withIdentifier: "NewUser", sender: nil)

                  }
                  
              }

              
          }
        }
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

