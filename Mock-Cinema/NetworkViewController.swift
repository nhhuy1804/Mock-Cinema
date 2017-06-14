//
//  NetworkViewController.swift
//  Mock-Cinema
//
//  Created by Cntt36 on 6/14/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import Firebase
class NetworkViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnResetPasswordWithPassword(_ sender: Any) {
        //loginViewController.resetPassword(email: txtEmail.text!)
        let email = txtEmail.text!
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                print("dasdas")
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
