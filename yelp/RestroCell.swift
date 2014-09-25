//
//  RestroCell.swift
//  yelp
//
//  Created by Erin Chuang on 9/20/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class RestroCell: UITableViewCell {

    @IBOutlet weak var restroImage: UIImageView!
    @IBOutlet weak var restroNameLabel: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
