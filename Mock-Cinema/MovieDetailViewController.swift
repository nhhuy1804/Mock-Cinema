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
    
    var image: UIImage?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovieDetail()
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
        /*if let img = Downloader.downloadImageWithURL(movie?.posterURL) {
            DispatchQueue.main.async {
                self.imgPoster.image = img
                
            }
        }*/
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
        dismiss(animated: true, completion: nil )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
                let seatsVC = segue.destination as! ChooseSeatViewController
                seatsVC.movie = movie
                seatsVC.screenId = "screen1"
        
    }
    
}