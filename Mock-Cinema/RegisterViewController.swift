//
//  RegisterViewController.swift
//  Mock-Cinema
//
//  Created by Cntt35 on 6/3/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAccept(_ sender: Any) {
        
        if (txtEmail.text?.isEmpty)! || (txtPassword.text?.isEmpty)! || (txtConfirmPassword.text?.isEmpty)! {
            //
            displayMyAlertMessage(userMessage: "Please fill out all required fields")
        } else {
            // check email format
            if !validateEmail(enteredEmail: txtEmail.text!) {
                displayMyAlertMessage(userMessage: "Wrong email format")
            } else {
                
                guard let email = txtEmail.text, let password = txtPassword.text, let name = txtName.text, let confirmPassword = txtConfirmPassword.text, let phone = txtPhone.text else {
                    print("form is not value")
                    return
                }
                
                if password == confirmPassword && password.characters.count > 5 {
                    
                    //Register user with Firebase
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
                        // Error
                        if error != nil {
                            self.displayMyAlertMessage(userMessage: "\(String(describing: error))")
                            return
                        } else {
                            
                            guard let uid = user?.uid else {
                                return
                            }
                            
                            //successful
                            let ref = Database.database().reference(fromURL: "https://emaillogin-c6cc0.firebaseio.com/")
                            let userReference = ref.child("users").child(uid)
                            let values = ["name": name, "email": email, "phone": phone]
                            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if err != nil {
                                    self.displayMyAlertMessage(userMessage: "\(String(describing: error))")
                                    return
                                } else {
                                    // Display alert message
                                    let myAlert = UIAlertController(title: "Alert", message: "Register successfull!!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                                        self.dismiss(animated: true, completion: nil)
                                        //Go to Login
                                        self.performSegue(withIdentifier: "goLogin", sender: self)
                                    }
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                    //self.dismiss(animated: true, completion: nil)
                                }
                            })
                            
                        }
                    })
                } else if password != confirmPassword {
                    //Error -> show message
                    displayMyAlertMessage(userMessage: "Confirm password does not match")
                } else if password.characters.count < 6 {
                    displayMyAlertMessage(userMessage: "Password must be minimum 6 characters")
                }
                
            }
        }
        
    }
    
    // Function Alert message
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //Check email format
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
