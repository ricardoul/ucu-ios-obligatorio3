//
//  HotItemCollectionViewCell.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 5/31/18.

//

import UIKit

class HotItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
}
