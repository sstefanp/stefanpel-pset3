//
//  ViewController.swift
//  Watch List
//
//  Created by Stefan Pel on 23-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    let url = URL(string: "https://httpbin.org/ip")
    
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
    
    
    
    @IBOutlet weak var tableView: UITableView!

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
}

