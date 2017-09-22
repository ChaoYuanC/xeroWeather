//
//  CitySearchTableViewCell.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

class CitySearchTableViewCell: UITableViewCell {

    @IBOutlet var cityIdLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ city: City) {
        self.cityIdLabel.text = "Id: \(city.id)"
        
        var string = ""
        if let city = city.city {
            string += "\(city), "
        }
        if let country = city.country {
            string += country
        }
        self.nameLabel.text = string
    }
}
