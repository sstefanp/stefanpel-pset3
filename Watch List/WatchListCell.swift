//
//  WatchListCell.swift
//  Watch List
//
//  Created by Stefan Pel on 23-02-17.
//  Copyright © 2017 Stefan Pel. All rights reserved.
//

import UIKit

class WatchListCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
