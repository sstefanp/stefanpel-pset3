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
    
    
    // create watchlist for user
    let watchlist = UserDefaults.standard
    
    
    //creating arrays for storing movie info
    var movieTitles = [String]()
    var movieYears = [String]()
    var moviePlots = [String]()
    var movieImages = [String]()
    var movieDirector = [String]()
    var movieActors = [String]()
    
    
    @IBAction func addButtonItemPressed(_ sender: UIBarButtonItem) {
        let viewController = SearchTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    let titles = ["The Godfather", "Shooter", "Inception", "Chaos"]
    let descriptions = [
        "The Godfather": "Maffia boss has hard decisions to make",
        "Shooter": "Man gets framed for murder of the president, has to prove he is innocent",
        "Inception": "Group of men perform actions in some people's dreams, have to escape",
        "Chaos": "Man explains chaos theory by solving a criminal case"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let url = URL(string: "https://www.omdbapi.com/?t=Shooter&y=&plot=short&r=json")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
        task.resume()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let watchCell = tableView.dequeueReusableCell(withIdentifier: "watchCell", for: indexPath) as! WatchListCell
        
        watchCell.movieTitle.text = titles[indexPath.row]
        
        if let storyline = descriptions[titles[indexPath.row]] {
            watchCell.movieDescription.text = storyline
        } else {
            watchCell.movieDescription.text = "No plot found"
        }
        
        if let image = UIImage(named: titles[indexPath.row]) {
            watchCell.moviePoster.image = image
        }
        
        return watchCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexpath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // remove from titles
        }
    }
    
    // prepare for seque -> title = movieTitle, image == Movie Image
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  if let individualMovieVC = segue.destination as? IndividualMovieViewController {
            //individualMovieVC.titleMovie = "Test"
            //individualMovieVC.plotMovie = "Test description, this is a long piece of text......"
        //}
    // }
     
}

