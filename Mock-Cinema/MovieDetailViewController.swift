//
//  MovieDetailViewController.swift
//  Mock-Cinema
//
//  Created by MrDummy on 6/10/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import FirebaseAuth

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblReleaseInformation: UILabel!
    @IBOutlet weak var lblOriginalLanguage: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblRunTime: UILabel!
    @IBOutlet weak var btnBookTicketNow: UIButton!
    
    var image: UIImage?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovieDetail()
        showButtonBook()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBookTicketNow(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            // No user is signed in.
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(loginVC, animated: true)
        }
    }

    func loadMovieDetail() {
        imgPoster.image = #imageLiteral(resourceName: "loadingImage")
        OperationQueue().addOperation { () -> Void in
            if let img = Downloader.downloadImageWithURL(self.movie?.posterURL) {
                OperationQueue.main.addOperation({
                    self.imgPoster.image = img
                })
            }
        }
        
        lblTitle.text = movie?.title?.uppercased()
        lblOverview.text = "Overview: " + (movie?.overview)!
        lblReleaseInformation.text = "Release Information: " + (movie?.releaseInformation)!
        lblOriginalLanguage.text = "Original Languege: " + (movie?.originalLanguage)!
        lblBudget.text = "Budget: " + (movie?.budget)!
        lblRunTime.text = "Run Time: " + (movie?.runTime)!
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "ChooseSeat":
                let seatsVC = segue.destination as! ChooseSeatViewController
                seatsVC.movie = movie
                seatsVC.screenId = "screen1"
                break
            case "ShowTrailer":
                let urlTrailerVC = segue.destination as! TrailerViewController
                urlTrailerVC.urlTrailer = movie?.urlTrailer
                break
            default:
                break
            }
        }

    }
    
    //get date from database
    func getDate(releaseInformation: String, interval: Double) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = DateFormatter.Style.short
        var date = dateFormat.date(from: releaseInformation)
        date?.addTimeInterval(interval)
        return date!
    }
    
    // get movies playing now
    func showButtonBook() {
        let dateNow = Date()
        if (getDate(releaseInformation: (movie?.releaseInformation!)!, interval: 0) <= dateNow && dateNow <= getDate(releaseInformation: (movie?.releaseInformation!)!, interval: 1209600)) {
            btnBookTicketNow.isHidden = false
        } else if (getDate(releaseInformation: (movie?.releaseInformation!)!, interval: 1209600) < dateNow) {
            btnBookTicketNow.isHidden = true
        } else if (getDate(releaseInformation: (movie?.releaseInformation!)!, interval: 0) > dateNow) {
            btnBookTicketNow.isHidden = true
        }
    }
}
