//
//  HotItemCollectionViewCell.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 5/31/18.

//

import UIKit

class FilterValueCell: UITableViewCell {
    
    
    @IBOutlet weak var filterValueButton: UIButton!
    
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
}
