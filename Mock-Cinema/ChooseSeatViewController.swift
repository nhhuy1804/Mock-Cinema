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
    var dateShown: String?

    @IBOutlet weak var fllSeat: UICollectionViewFlowLayout!
    @IBOutlet weak var clvSeat: UICollectionView!
    @IBOutlet weak var btnScreen1: UIButton!
    @IBOutlet weak var btnScreen2: UIButton!
    @IBOutlet weak var btnScreen3: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clvSeat.dataSource = self
        self.clvSeat.delegate = self
        
        datePicker.minimumDate = Date()
        datePicker.maximumDate = getDate(releaseInformation: (movie?.releaseInformation)!).addingTimeInterval(1209000)
        
        if dateShown == nil {
            dateShown = "\(getDateTime()[0])-0\(getDateTime()[1])-0\(getDateTime()[2])"
        }
        getSeats()
        getShowTime()
        print(getDateToString(date: datePicker.date))
        print(getDateToString(date: Date()))
        
    }
    
    func getDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getDate(releaseInformation: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = DateFormatter.Style.short
        let date = dateFormat.date(from: releaseInformation)
        //date?.addTimeInterval(interval)
        return date!
    }
    
    func getShowTime() {
        if getDateToString(date: datePicker.date) == getDateToString(date: Date()) {
            if getDateTime()[3] < 9 {
                screenId = "screen1"
                time = "9:00"
                
                btnScreen1.backgroundColor = UIColor.brown
                btnScreen2.backgroundColor = UIColor.red
                btnScreen3.backgroundColor = UIColor.red
                btnScreen1.isEnabled = false
                btnScreen2.isEnabled = true
                btnScreen3.isEnabled = true
                getSeats()
                
            } else if getDateTime()[3] > 9 && getDateTime()[3] < 15 {
                screenId = "screen2"
                time = "15:00"
                
                btnScreen1.isHidden = true
                btnScreen2.backgroundColor = UIColor.brown
                btnScreen3.backgroundColor = UIColor.red
                btnScreen1.isEnabled = false
                btnScreen2.isEnabled = true
                btnScreen3.isEnabled = true
                getSeats()
                
            } else if getDateTime()[3] > 15 && getDateTime()[3] < 20  {
                screenId = "screen3"
                time = "20:00"
                
                btnScreen1.isHidden = true
                btnScreen2.isHidden = true
                btnScreen3.backgroundColor = UIColor.brown
                btnScreen1.isEnabled = false
                btnScreen2.isEnabled = false
                btnScreen3.isEnabled = true
                getSeats()
            } else {
                screenId = "screen1"
                time = "9:00"
                btnScreen1.isHidden = true
                btnScreen2.isHidden = true
                btnScreen3.isHidden = true
                btnScreen1.isEnabled = false
                btnScreen2.isEnabled = false
                btnScreen3.isEnabled = false
                clvSeat.isHidden = true
            }
        } else {
            btnScreen1.isHidden = false
            btnScreen2.isHidden = false
            btnScreen3.isHidden = false
            btnScreen1.isEnabled = false
            btnScreen2.isEnabled = true
            btnScreen3.isEnabled = true
            btnScreen1.backgroundColor = UIColor.brown
            btnScreen2.backgroundColor = UIColor.red
            btnScreen3.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func btnScreen1(_ sender: Any) {
        seats.removeAll()
        screenId = "screen1"
        time = "9:00"
        btnScreen1.backgroundColor = UIColor.brown
        btnScreen2.backgroundColor = UIColor.red
        btnScreen3.backgroundColor = UIColor.red
        btnScreen1.isEnabled = false
        btnScreen2.isEnabled = true
        btnScreen3.isEnabled = true
        getSeats()
        clvSeat.reloadData()
    }
    
    @IBAction func btnScreen2(_ sender: Any) {
        seats.removeAll()
        screenId = "screen2"
        time = "15:00"
        btnScreen1.backgroundColor = UIColor.red
        btnScreen2.backgroundColor = UIColor.brown
        btnScreen3.backgroundColor = UIColor.red
        btnScreen1.isEnabled = true
        btnScreen2.isEnabled = false
        btnScreen3.isEnabled = true
        getSeats()
        clvSeat.reloadData()
        
    }
    
    @IBAction func btnScreen3(_ sender: Any) {
        seats.removeAll()
        screenId = "screen3"
        time = "20:00"
        btnScreen3.backgroundColor = UIColor.brown
        btnScreen2.backgroundColor = UIColor.red
        btnScreen1.backgroundColor = UIColor.red
        btnScreen3.isEnabled = false
        btnScreen2.isEnabled = true
        btnScreen1.isEnabled = true
        getSeats()
        clvSeat.reloadData()
    }
    
    @IBAction func btnBuy(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        for seat in seats {
            if seat.status == 2 {
                let seatID = seat.id
                let currentDate = "\(getDateTime()[0])-\(getDateTime()[1])-\(getDateTime()[2]) \(getDateTime()[3]):\(getDateTime()[4]):\(getDateTime()[5])"
                if let movieId = movie?.id, let movieTitle = movie?.title {
                    databaseRef.child("movie").child("\(movieId)").child("bookTicket").child(dateShown!).child(screenId).child(seat.id!).setValue(["id": seat.id!, "status": 1])
                    databaseRef.child("users").child(userID!).child("carts").child(currentDate + seat.id!).setValue(["movieID": movieId, "title": movieTitle, "seat": seatID ?? String(), "time": time, "bookingDate": currentDate, "status": "Unpaid", "dateShown": dateShown!])
                }
            }
            
            if count == 0 {
                displayMyAlertMessage(userMessage: "Please choose your seats")
            }
            
        }
        
        seats.removeAll()
        getSeats()
        clvSeat.reloadData()
        
        let myAlert = UIAlertController(title: "Alert", message: "Choose seats successful", preferredStyle: UIAlertControllerStyle.alert)
        
        let payAction = UIAlertAction(title: "Pay", style: UIAlertActionStyle.default) { action in
            //self.dismiss(animated: true, completion: nil)
            let src = self.storyboard?.instantiateViewController(withIdentifier: "Carts") as! CartsViewController
            self.present(src, animated: true)
        }
        let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default) { action in
            //self.present(myAlert, animated: true, completion: nil)
        }
        myAlert.addAction(payAction)
        myAlert.addAction(continueAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func datePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateShown = dateFormatter.string(from: (sender as AnyObject).date)
        //print(dateShown)
        seats.removeAll()
        getShowTime()
        getSeats()
        self.clvSeat.reloadData()
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
            self.displayMyAlertMessage(userMessage: "Seat Unavailable")
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
            databaseRef.child("movie").child("\(movieId)").child("bookTicket").child(dateShown!).child(screenId).observe(.childAdded, with: {snapshot in
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
    
    func getDateTime() -> [Int] {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let result = [year, month, day, hour, minute, second]
        return result
    }
}
