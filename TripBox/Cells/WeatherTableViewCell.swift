//
//  WeatherTableViewCell.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var iconCurrentLocation: UIImageView!
    @IBOutlet weak var minMaxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.weatherImage.layer.shadowColor = UIColor.black.cgColor
        self.weatherImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.weatherImage.layer.shadowRadius = 4
        self.weatherImage.layer.shadowOpacity = 0.4
        self.weatherImage.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInterface(_ object : WeatherInterface){
        self.nameLabel.text = object.title
        self.subtitleLabel.text = object.subtitle
        self.tempLabel.text = object.temperature
        self.minMaxTempLabel.text = object.temperatureMinMax
        
        if let imageUrl = object.imageUrl {
            let url = URL(string: imageUrl)
            self.weatherImage.kf.setImage(with: url)
        }
        else{
            self.weatherImage.image = nil
        }
        
        self.iconCurrentLocation.isHidden = !object.currentLocation
    }

}
