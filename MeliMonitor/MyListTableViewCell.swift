//
//  MyListTableViewCell.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/3/18.

//

import UIKit

class MyListTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.button.layer.cornerRadius = 8
        self.button.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
