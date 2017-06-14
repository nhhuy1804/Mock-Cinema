//
//  ChangePasswordViewController.swift
//  Mock-Cinema
//
//  Created by Cntt35 on 6/7/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOK(_ sender: Any) {
        if (txtNewPassword.text?.isEmpty)! || (txtConfirmPassword.text?.isEmpty)! {
            self.displayMyAlertMessage(userMessage: "Please fill out all required fields")
        } else if (txtNewPassword.text?.characters.count)! < 6 {
            displayMyAlertMessage(userMessage: "New password must be minimum 6 characters")
        } else if txtNewPassword.text != txtConfirmPassword.text {
            //Error -> show message
            displayMyAlertMessage(userMessage: "Confirm password does not match")
        } else {
            if let user = Auth.auth().currentUser, let newPassword = txtNewPassword.text {
                user.updatePassword(to: newPassword, completion: { (error) in
                    if error != nil {
                        self.displayMyAlertMessage(userMessage: "\(String(describing: error))")
                    } else {
                        // Display alert message
                        let myAlert = UIAlertController(title: "Alert", message: "Change password successfull!!", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                            self.dismiss(animated: true, completion: nil)
                            //Go to User Profile
                            let src = self.storyboard?.instantiateViewController(withIdentifier: "userProfile") as! UserProfileViewController
                            self.present(src, animated: true)
                        }
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Function Alert message
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

