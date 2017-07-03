//
//  CartsViewController.swift
//  Mock-Cinema
//
//  Created by Cntt35 on 6/14/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CartsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tbvCart: UITableView!
    
    var carts = [Carts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCarts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCellTableView
        let cart: Carts
        
        cart = carts[indexPath.row]
        
        cell.lblDate.text = cart.bookingDate
        cell.lblSeat.text = "Seat: " + cart.seat!
        cell.lblTime.text = "Time: " + cart.time!
        cell.lblMovie.text = "Movie: " + cart.title!
        cell.lblStatus.text = "Status: " + cart.status!
        cell.lblDateShown.text = "dateShown: " + cart.dateShown!
        
        return cell
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        var count = 0
        
        for cart in carts {
            if cart.status == "Unpaid" {
                databaseRef.child("users").child(userID!).child("carts").child(cart.bookingDate! + cart.seat!).setValue(["seat": cart.seat!, "status": "Paid", "time": cart.time, "bookingDate": cart.bookingDate, "title": cart.title!, "dateShown": cart.dateShown])
                count += 1
            }
        }
        
        if count == 0 {
            displayMyAlertMessage(userMessage: "You already paid")
        } else {
            
            displayMyAlertMessage(userMessage: "The amout paid is \(count * 50000)")
        }
        carts.removeAll()
        getCarts()
        tbvCart.reloadData()
    }
    
    // get cart
    func getCarts() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).child("carts").observe(.childAdded, with: {snapshot in
            
            let snapshotValue = snapshot.value as? NSDictionary
            self.carts.append(Carts(json: snapshotValue as! [String : Any]))
            DispatchQueue.main.async {
                self.tbvCart.reloadData()
            }
        })
    }
    
    // Function Alert message
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
