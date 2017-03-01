//
//  WatchListViewController.swift
//  Watch List
//
//  Created by Stefan Pel on 23-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit
import Foundation

@objc class WatchListViewController: UITableViewController {
    
    // Tableview
    @IBOutlet var watchListTable: UITableView!
    
    // Create watchlist for user
    let watchList = UserDefaults.standard
    
    // Creating arrays for storing movie info
    var movieTitles = [String]()
    var movieYears = [String]()
    var movieImages = [String]()
    
    // Present SearchViewController
    @IBAction func addButtonItemPressed(_ sender: UIBarButtonItem) {
        let viewController = SearchTableViewController(completion: self.favorite)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // Add movie to dictionary
    func addMovie(movieDictionary: NSDictionary) {
        self.movieTitles.append((movieDictionary["Title"] as? String)!)
        self.movieYears.append((movieDictionary["Year"] as? String)!)
        self.movieImages.append((movieDictionary["Poster"] as? String)!)
    }
    
    func favorite(movie: [String : Any]) {
        // From SearchViewController to WatchlistViewController
        self.addMovie(movieDictionary: movie as NSDictionary)
        self.tableView.reloadData()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

//    // Update watchlist
//    func updateWatchlist() {
//        self.watchList.set(self.movieTitles, forKey: "Title")
//        self.watchList.set(self.movieYears, forKey: "Year")
//        self.watchList.set(self.movieImages, forKey: "Poster")
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // set watchlist
        movieTitles = (self.watchList.array(forKey: "Title") as? [String]) ?? []
        movieImages = (self.watchList.array(forKey: "Poster") as? Array<String>) ?? []
        movieYears = (self.watchList.array(forKey: "Year") as? Array<String>) ?? []
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Amount of movieTitles in search
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTitles.count
    }
    
    // Initialize watchCell to store search results in
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let watchCell = tableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath) as! WatchListCell
        
        watchCell.movieTitle.text = movieTitles[indexPath.row]
        watchCell.movieDescription.text = movieYears[indexPath.row]
        
        // No poster available
        if movieImages[indexPath.row] == "N/A" {
            watchCell.moviePoster.image = #imageLiteral(resourceName: "no-image-icon")
        }
        // Get poster from URL
        else {
            watchCell.moviePoster.image = loadImage(poster: movieImages[indexPath.row])
        }
        
        return watchCell
    }
    
    // Loading poster image
    func loadImage(poster: String) -> UIImage {
        
        if let tempUrl = poster as? String {
            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
            let data = NSData(contentsOf: url as! URL)
            let image = UIImage(data: data as! Data)
            return image!
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Removing rows from table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexpath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            movieTitles.remove(at: indexpath.row)
            movieYears.remove(at: indexpath.row)
            movieImages.remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .fade)
        }
    }
    
    // To IndividualMovieViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Getting information from labels
        let currentIndex = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: currentIndex!) as! WatchListCell!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IMVC") as! IndividualMovieViewController
        
        viewController.movieTitle = (currentCell?.movieTitle.text)! as String
        viewController.movieYear = (currentCell?.movieDescription.text)! as String
        
        // Present IndividualMovieViewController
        self.present(viewController, animated: true , completion: nil)
    }
}

