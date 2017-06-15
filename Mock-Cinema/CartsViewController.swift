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
        
        cell.lblDate.text = cart.date
        cell.lblSeat.text = "Seat: " + cart.seat!
        cell.lblTime.text = "Time: " + cart.time!
        cell.lblMovie.text = "Movie: " + cart.title!
        
        return cell
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
}
