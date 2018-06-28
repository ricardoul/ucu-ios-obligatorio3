//
//  VipViewController.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import UIKit
import WebKit

class VipViewController: UIViewController {

    @IBOutlet weak var titles: UILabel!
    @IBOutlet weak var buttonGoToML: UIButton!
    @IBOutlet weak var buttonAddToList: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var item: Item?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageLoad.downloadImage(url:  URL(string:(item?.thumbnail!)!)!, image: self.image)
        self.price.text = "$ \(item!.price)"
        self.titles.text = item?.title
        self.image.layer.cornerRadius = 10
        self.image.layer.masksToBounds = true
        self.image.layer.shadowColor = UIColor.gray.cgColor
        self.image.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.image.layer.shadowOpacity = 0.1
        self.image.layer.shadowPath = UIBezierPath(roundedRect: self.image.bounds , cornerRadius: 10).cgPath

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let myList = segue.destination as! MyListViewController
            myList.item = self.item;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToLIstToucn(_ sender: Any) {
    }
    
    @IBAction func goToMlTouch(_ sender: Any) {
        let webViewController = WebViewController()
            webViewController.item = self.item
        self.navigationController?.pushViewController(webViewController, animated: true) //you can present it as wel
    }

}
