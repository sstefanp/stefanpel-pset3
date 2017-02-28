//
//  SearchTableViewController.swift
//  Watch List
//
//  Created by Stefan Pel on 24-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    // creating arrays for storing movie info
    var movieTitles = [String]()
    var movieYears = [String]()
    var moviePlots = [String]()
    var movieImages = [String]()
    var movieDirector = [String]()
    var movieActors = [String]()
    
    var searchResults: [Dictionary<String, AnyObject>] = []
    
    var searchID = ""
    
    let searchBar = UISearchBar()
    
    let completion: (([String : Any]) -> Void)
    
    init(completion: @escaping (([String : Any]) -> Void)) {
        self.completion = completion
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = .minimal
        // searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        self.tableView.register(SearchViewCell.self, forCellReuseIdentifier: "Search View Cell")
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonItemPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonItemPressed))
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //
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

    // Function to retrieve data
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
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["Error"] != nil {
                        self.searchResults = []
                    }
                    else {
                        // The list with results.
                        self.searchResults = json["Search"]! as! [Dictionary<String, AnyObject>]
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search View Cell", for: indexPath) as! SearchViewCell
        
        let cellInfo =  searchResults[indexPath.row]

        cell.textLabel?.text = cellInfo["Title"] as? String
        cell.detailTextLabel?.text = cellInfo["Year"] as? String
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo =  searchResults[indexPath.row]
        self.completion(cellInfo)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
