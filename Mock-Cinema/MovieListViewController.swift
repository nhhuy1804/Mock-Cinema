//
//  MovieListViewController.swift
//  Mock-Cinema
//
//  Created by Cntt35 on 6/7/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit
import Firebase

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loginLogoutBtn: UIButton!
    @IBOutlet weak var helloBtn: UIButton!
    @IBOutlet weak var tbvMovieList: UITableView!
    
    @IBOutlet weak var btnOldMovies: UIButton!
    @IBOutlet weak var btnPlayingNow: UIButton!
    @IBOutlet weak var btnComingSoon: UIButton!
    
    var movies = [Movie]()
    var moviesStatus = [Movie]()
    var posterImage: [Int:UIImage] = [:]
    var filteredMovie = [Movie]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovie = moviesStatus.filter { movie in
            return (movie.title?.lowercased().contains(searchText.lowercased()))!
        }
        tbvMovieList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tbvMovieList.tableHeaderView = searchController.searchBar
        
        //user is not login
        if Auth.auth().currentUser?.uid == nil {
            helloBtn.isHidden = true
            helloBtn.isEnabled = false
            loginLogoutBtn.setTitle("Login", for: .normal)
            
        } else {
            //user is login
            helloBtn.isHidden = false
            helloBtn.isEnabled = true
            loginLogoutBtn.setTitle("Logout", for: .normal)
            
        }
        
        btnOldMovies.isEnabled = true
        btnComingSoon.isEnabled = true
        btnPlayingNow.isEnabled = false
        btnPlayingNow.backgroundColor = UIColor.red
        btnComingSoon.backgroundColor = UIColor.white
        btnOldMovies.backgroundColor = UIColor.white
        btnPlayingNow.setTitleColor(UIColor.white, for: .normal)
        btnOldMovies.setTitleColor(UIColor.red, for: .normal)
        btnComingSoon.setTitleColor(UIColor.red, for: .normal)
        
        getMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginLogout(_ sender: Any) {
        searchController.dismiss(animated: true, completion: nil)
        if Auth.auth().currentUser?.uid != nil {
            // user is login
            do {
                try Auth.auth().signOut()
            } catch let logoutError {
                print(logoutError)
            }
            
            helloBtn.isHidden = true
            helloBtn.isEnabled = false
            loginLogoutBtn.setTitle("Login", for: .normal)
        
        } else {
            // user is not login
            let srcLogin = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(srcLogin, animated: true)
        }
    }

    @IBAction func btnHello(_ sender: Any) {
        let srcUserInfo = self.storyboard?.instantiateViewController(withIdentifier: "userProfile") as! UserProfileViewController
        self.present(srcUserInfo, animated: true)
    }
    
    @IBAction func btnOldMovies(_ sender: Any) {
        btnOldMovies.isEnabled = false
        btnComingSoon.isEnabled = true
        btnPlayingNow.isEnabled = true
        btnOldMovies.backgroundColor = UIColor.red
        btnComingSoon.backgroundColor = UIColor.white
        btnPlayingNow.backgroundColor = UIColor.white
        btnPlayingNow.setTitleColor(UIColor.red, for: .normal)
        btnOldMovies.setTitleColor(UIColor.white, for: .normal)
        btnComingSoon.setTitleColor(UIColor.red, for: .normal)
        
        getOldMovies()
    }
    
    @IBAction func btnPlayingNow(_ sender: Any) {btnOldMovies.isEnabled = false
        btnOldMovies.isEnabled = true
        btnComingSoon.isEnabled = true
        btnPlayingNow.isEnabled = false
        btnPlayingNow.backgroundColor = UIColor.red
        btnComingSoon.backgroundColor = UIColor.white
        btnOldMovies.backgroundColor = UIColor.white
        btnPlayingNow.setTitleColor(UIColor.white, for: .normal)
        btnOldMovies.setTitleColor(UIColor.red, for: .normal)
        btnComingSoon.setTitleColor(UIColor.red, for: .normal)
        
        getPlayingNowMovies()
    }
    
    @IBAction func btnComingSoon(_ sender: Any) {
        btnOldMovies.isEnabled = true
        btnComingSoon.isEnabled = false
        btnPlayingNow.isEnabled = true
        btnComingSoon.backgroundColor = UIColor.red
        btnOldMovies.backgroundColor = UIColor.white
        btnPlayingNow.backgroundColor = UIColor.white
        btnPlayingNow.setTitleColor(UIColor.red, for: .normal)
        btnOldMovies.setTitleColor(UIColor.red, for: .normal)
        btnComingSoon.setTitleColor(UIColor.white, for: .normal)
        
        getComingSoon()
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
    func getPlayingNowMovies() {
        moviesStatus.removeAll()
        let dateNow = Date()
        for movie in movies {
            // play 2 weeks
            if (getDate(releaseInformation: movie.releaseInformation!, interval: 0) <= dateNow && dateNow <= getDate(releaseInformation: movie.releaseInformation!, interval: 1209600)) {
                moviesStatus.append(movie)
            }
        }
        self.tbvMovieList.reloadData()
    }
    
    // get old movies
    func getOldMovies() {
        moviesStatus.removeAll()
        let dateNow = Date()
        for movie in movies {
            // release date < date now 2 weeks
            if (getDate(releaseInformation: movie.releaseInformation!, interval: 1209600) < dateNow) {
                moviesStatus.append(movie)
            }
        }
        tbvMovieList.reloadData()
    }
    
    // get coming soon movies
    func getComingSoon() {
        moviesStatus.removeAll()
        let dateNow = Date()
        for movie in movies {
            // release date > date now
            if (getDate(releaseInformation: movie.releaseInformation!, interval: 0) > dateNow) {
                moviesStatus.append(movie)
            }
        }
        tbvMovieList.reloadData()
    }
    
    // get list movies
    func getMovies() {
        let ref = Database.database().reference()
        ref.child("movie").observe(.childAdded, with: {snapshot in
            
            let snapshotValue = snapshot.value as? NSDictionary
            self.movies.append(Movie(json: snapshotValue as! [String : Any]))
            DispatchQueue.main.async {
                self.tbvMovieList.reloadData()
            }
            self.getPlayingNowMovies()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovie.count
        }
        return moviesStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieListTableViewCell
        let movie: Movie
        
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = filteredMovie[indexPath.row]
        } else {
            movie = moviesStatus[indexPath.row]
        }
        
        //movie = moviesStatus[indexPath.row]
        //movie = movies[indexPath.row]
        cell.imgPoster.image = #imageLiteral(resourceName: "loadingImage")
        OperationQueue().addOperation { () -> Void in
            if let img = Downloader.downloadImageWithURL(movie.posterURL) {
                OperationQueue.main.addOperation({
                    self.posterImage[self.moviesStatus[indexPath.row].id!] = img
                    cell.imgPoster?.image = img
                })
            }
        }
        
        cell.lblTitle?.text = movie.title
        cell.lblOverview?.text = movie.overview
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != nil {
            
            let movieDetailVC = segue.destination as! MovieDetailViewController
            if let indexPath = self.tbvMovieList.indexPathForSelectedRow {
                if searchController.isActive && searchController.searchBar.text != "" {
                    movieDetailVC.movie = filteredMovie[indexPath.row]
                } else {
                    movieDetailVC.movie = moviesStatus[indexPath.row]
                }
                
            }
        }
    }
    
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
