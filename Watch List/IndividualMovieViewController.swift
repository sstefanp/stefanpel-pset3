//
//  IndividualMovieViewController.swift
//  Watch List
//
//  Created by Stefan Pel on 24-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class IndividualMovieViewController: UIViewController {
    
    var movieTitle: String!
    var movieYear: String!
    
    var moviePlot: String!
    var movieDirector: String!
    var movieImage: String!
    
    var urlString: String!
    
    var currentIndex: Int?
    
    
    // outlets
    @IBOutlet weak var posterMovie: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var yearMovie: UILabel!
    @IBOutlet weak var actorsMovie: UILabel!
    @IBOutlet weak var directorMovie: UILabel!
    
    @IBOutlet weak var plotMovie: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTitle = movieTitle.replacingOccurrences(of: " ", with: "+")
        let year = movieYear //.replacingOccurrences(of: "-", with: "%E2%80%93")
        if (year?.characters.contains("-"))! {
            urlString = "https://www.omdbapi.com/?t="+newTitle+"&y=&plot=full&r=json"
        }
        else {
            urlString = "https://www.omdbapi.com/?t="+newTitle+"&y="+year!+"&plot=full&r=json"
        }
        print (urlString)
        
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                print ("error")
                self.plotMovie.text = ""
                self.actorsMovie.text = ""
                self.movieImage = ""
                return
            }
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["Error"] != nil {
                        return
                    }
                    else {
                        self.directorMovie.text = json["Director"] as! String?
                        self.plotMovie.text = json["Plot"] as! String?
                        self.actorsMovie.text = json["Genre"] as! String?
                        self.movieImage = json["Poster"] as! String?
                        
                        // to retrieve poster
                        if let tempUrl = json["Poster"] as? String {
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
        
        titleMovie.text = movieTitle
        yearMovie.text = movieYear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let viewController = storyboard.instantiateViewController(withIdentifier: "IMVC") as! IndividualMovieViewController
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
