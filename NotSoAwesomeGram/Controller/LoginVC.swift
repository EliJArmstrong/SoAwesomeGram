//
//  ViewController.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 2/24/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class LoginVC: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func onSginIn(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            } else{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func onSginUp(_ sender: Any) {
        
        let user = PFUser()
        user.username = usernameField.text ?? ""
        user.password = passwordField.text ?? ""
        user.image    = Utilities.imageToPFFileObject(image: UIImage(named: "image_placeholder")!, imageName: "userImage")
    
        user.signUpInBackground { (success, error) in
            if success{
                print("logged in. Hey!!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else{
                print("Error: \(error?.localizedDescription ?? "error")")
            }
        }
    }
}

