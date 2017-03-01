//
//  IndividualMovieViewController.swift
//  Watch List
//
//  Created by Stefan Pel on 24-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class IndividualMovieViewController: UIViewController {
    
    // Variables from WatchListViewController
    var movieTitle: String!
    var movieYear: String!
    
    // Variables to store other information
    var moviePlot: String!
    var movieDirector: String!
    var movieImage: String!
    var urlString: String!
    
    // Outlets
    @IBOutlet weak var posterMovie: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var yearMovie: UILabel!
    @IBOutlet weak var genreMovie: UILabel!
    @IBOutlet weak var directorMovie: UILabel!
    @IBOutlet weak var imdbMovie: UILabel!
    @IBOutlet weak var plotMovie: UITextView!
    
    
    // Views
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!
    
    override func viewWillLayoutSubviews() {
        // App is in landscape view
        if self.view.bounds.width > self.view.bounds.height {
            // Lowerview
            self.lowerView.frame.size.width = 0.5 * self.view.bounds.width
            self.lowerView.frame.origin.x = 0.5 * self.view.bounds.width - 20
            self.lowerView.frame.origin.y = 12
            self.lowerView.frame.size.height = self.view.bounds.height - 8
            // Upperview
            self.upperView.frame.origin.x = 2
            self.upperView.frame.origin.y = 12
            self.upperView.frame.size.width = 0.5 * self.view.bounds.width
            self.upperView.frame.size.height = self.view.bounds.height - 20
        }
            // App is in portret view
        else {
            // Lower view
            self.lowerView.frame.size.height = 0.5 * self.view.bounds.height
            self.lowerView.frame.origin.x = 0
            self.lowerView.frame.origin.y = 0.5 * self.view.bounds.height
            self.lowerView.frame.size.width = self.view.bounds.width
            // Upperview
            self.upperView.frame.origin.x = 0
            self.upperView.frame.origin.y = 20
            self.upperView.frame.size.height = 0.5 * self.view.bounds.height - 20
            self.upperView.frame.size.width = self.view.bounds.width
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust for titles with multiple words
        // Adjust for years with (-) in them
        let newTitle = movieTitle.replacingOccurrences(of: " ", with: "+")
        let year = movieYear
        if (year?.characters.contains("-"))! {
            urlString = "https://www.omdbapi.com/?t="+newTitle+"&y=&plot=full&r=json"
        }
        else {
            urlString = "https://www.omdbapi.com/?t="+newTitle+"&y="+year!+"&plot=full&r=json"
        }
        
        // Get data from OMDB
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Guards data, account for errors
            guard let data = data, error == nil else {
                print ("error")
                self.plotMovie.text = ""
                self.genreMovie.text = ""
                self.movieImage = ""
                return
            }
            //
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let info = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if info["Error"] != nil {
                        return
                    }
                    else {
                        // Fill in labels
                        self.directorMovie.text = info["Director"] as! String?
                        self.plotMovie.text = info["Plot"] as! String?
                        self.genreMovie.text = info["Genre"] as! String?
                        self.imdbMovie.text = info["imdbRating"] as! String?
                        self.movieImage = info["Poster"] as! String?
                        
                        
                        // Getting poster from URL
                        if let tempUrl = info["Poster"] as? String {
                            if tempUrl == "N/A" {
                                self.posterMovie.image = #imageLiteral(resourceName: "no-image-icon")
                            }
                            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
                            if let poster = NSData(contentsOf: url as! URL) {
                                self.posterMovie.image = UIImage(data: poster as Data)
                            }
                        }
                    }
                } catch {
                    return
                }
            }
        }).resume()
        
        // Filling in title and year labels
        titleMovie.text = movieTitle
        yearMovie.text = movieYear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Backbutton to dismiss view
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
