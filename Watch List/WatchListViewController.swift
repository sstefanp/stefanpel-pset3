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
    
    @IBOutlet var watchListTable: UITableView!
    
    // create watchlist for user
    let watchList = UserDefaults.standard
    
    // creating arrays for storing movie info
    var movieTitles = [String]()
    var movieYears = [String]()
    var movieImages = [String]()
    
    @IBAction func addButtonItemPressed(_ sender: UIBarButtonItem) {
        let viewController = SearchTableViewController(completion: self.favorite)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // Add movie to dictionary
    func addMovie(movieDictionary: NSDictionary) {
        self.movieTitles.append((movieDictionary["Title"] as? String)!)
        self.movieYears.append((movieDictionary["Year"] as? String)!)
        //self.moviePlots.append((movieDictionary["Plot"] as? String)!)
        self.movieImages.append((movieDictionary["Poster"] as? String)!)
    }
    
    func favorite(movie: [String : Any]) {
        // Do something.
        self.addMovie(movieDictionary: movie as NSDictionary)
        self.tableView.reloadData()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // Update watchlist
    func updateWatchlist() {
        self.watchList.set(self.movieTitles, forKey: "Title")
        self.watchList.set(self.movieYears, forKey: "Year")
        self.watchList.set(self.movieImages, forKey: "Poster")
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let watchCell = tableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath) as! WatchListCell
        
        watchCell.movieTitle.text = movieTitles[indexPath.row]
        watchCell.movieDescription.text = movieYears[indexPath.row]
        
        if movieImages[indexPath.row] == "N/A" {
            watchCell.moviePoster.image = #imageLiteral(resourceName: "no-image-icon")
        }
        else {
            watchCell.moviePoster.image = loadImage(poster: movieImages[indexPath.row])
        }
        
        return watchCell
    }
    
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexpath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            movieTitles.remove(at: indexpath.row)
            movieYears.remove(at: indexpath.row)
            movieImages.remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentIndex = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: currentIndex!) as! WatchListCell!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IMVC") as! IndividualMovieViewController
        
        viewController.movieTitle = (currentCell?.movieTitle.text)! as String
        viewController.movieYear = (currentCell?.movieDescription.text)! as String
        
        self.present(viewController, animated: true , completion: nil)
    }
}

