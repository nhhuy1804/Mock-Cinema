//
//  ChooseSeatViewController.swift
//  Mock-Cinema
//
//  Created by MrDummy on 6/12/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChooseSeatViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var screenId = "screen1"
    var time = "9:00"
    var movie: Movie?
    var count = 0
    var seats = [Seat]()

    @IBOutlet weak var clvSeat: UICollectionView!
    @IBOutlet weak var btnScreen1: UIButton!
    @IBOutlet weak var btnScreen2: UIButton!
    @IBOutlet weak var btnScreen3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clvSeat.dataSource = self
        self.clvSeat.delegate = self
        screenId = "screen1"
        getSeats()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnScreen1(_ sender: Any) {
        seats.removeAll()
        screenId = "screen1"
        time = "9:00"
        getSeats()
        clvSeat.reloadData()
    }
    
    @IBAction func btnScreen2(_ sender: Any) {
        seats.removeAll()
        screenId = "screen2"
        time = "15:00"
        getSeats()
        clvSeat.reloadData()
    }
    
    @IBAction func btnScreen3(_ sender: Any) {
        seats.removeAll()
        screenId = "screen3"
        time = "20:00"
        getSeats()
        clvSeat.reloadData()
    }
    
    @IBAction func btnBuy(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        for seat in seats {
            if seat.status == 2 {
                let seatID = seat.id
                let currentDate = Date()
                if let movieId = movie?.id, let movieTitle = movie?.title {
                    databaseRef.child("movie").child("\(movieId)").child("bookTicket").child(screenId).child(seat.id!).setValue(["id": seat.id!, "col": seat.col!, "row": seat.row!, "status": 1])
                    databaseRef.child("users").child(userID!).child("carts").childByAutoId().setValue(["movieID": movieId, "title": movieTitle, "seat": seatID ?? String(), "time": time, "date": String(describing: currentDate)])
                }
                
            }
        }
        //screenId = "screen3"
        seats.removeAll()
        getSeats()
        clvSeat.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Seat Cell", for: indexPath) as! SeatCellCollectionView
        let seat: Seat
        seat = seats[indexPath.row]
        cell.setColorCell(id: seat.id!, status: seat.status!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seat: Seat
        seat = seats[indexPath.row]
        if (seat.status == 0) {
            seat.status = 2
            count += 1
        } else if (seat.status == 1) {
            self.displayMyAlertMessage(userMessage: "Seat was reserved by the other!")
        }
        else if (seat.status == 2) {
            seat.status = 0
            count -= 1
        }
        clvSeat.reloadItems(at: [indexPath])
    }
    
    func getSeats() {
        let databaseRef = Database.database().reference()
        if let movieId = movie?.id {
            databaseRef.child("movie").child("\(movieId)").child("bookTicket").child(screenId).observe(.childAdded, with: {snapshot in
                let snapshotValue = snapshot.value as? NSDictionary
                self.seats.append(Seat(json: snapshotValue as! [String : Any]))
                DispatchQueue.main.async {
                    self.clvSeat.reloadData()
                }
            })
        }
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
