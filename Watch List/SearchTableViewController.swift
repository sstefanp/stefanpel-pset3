//
//  SearchTableViewController.swift
//  Watch List
//
//  Created by Stefan Pel on 24-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    // Dictionary for search results
    var searchResults: [Dictionary<String, AnyObject>] = []
    let searchBar = UISearchBar()
    
    // To WatchListViewController
    let completion: (([String : Any]) -> Void)
    init(completion: @escaping (([String : Any]) -> Void)) {
        self.completion = completion
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initialize searchbar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search for movies"
        self.navigationItem.titleView = searchBar
        
        self.tableView.register(SearchViewCell.self, forCellReuseIdentifier: "Search View Cell")
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonItemPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonItemPressed))
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
    
    // Search started
    func searchButtonItemPressed(_sender: UIBarButtonItem) {
        let searching = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        movieSearch(movieTitle: searching!)
    }
    
    // Cancel search
    func cancelButtonItemPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        print ("clicked")
    }

    // Get information from OMDB
    func movieSearch(movieTitle: String) {
        let urlString = "https://www.omdbapi.com/?s="+movieTitle+"&y=&plot=short"
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                self.searchResults = []
                return
            }
            
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let info = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if info["Error"] != nil {
                        self.searchResults = []
                    }
                    else {
                        // Fill dictionary with results
                        self.searchResults = info["Search"]! as! [Dictionary<String, AnyObject>]
                    }
                } catch {
                    self.searchResults = []
                }
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Initialize table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // Fill cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search View Cell", for: indexPath) as! SearchViewCell
        
        let cellInfo =  searchResults[indexPath.row]

        cell.textLabel?.text = cellInfo["Title"] as? String
        cell.detailTextLabel?.text = cellInfo["Year"] as? String
        
        return cell
    }
    
    // Selected row to add to watchlist
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo =  searchResults[indexPath.row]
        self.completion(cellInfo)
    }
}
