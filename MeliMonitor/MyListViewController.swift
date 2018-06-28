//
//  MyListViewController.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/3/18.

//

import UIKit
import Firebase
import AlamofireObjectMapper
import Alamofire

class MyListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var items = [Item]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var buttonGoToMl: UIButton!
    
    @IBOutlet weak var imageMlItem: UIView!
    
    var item:Item?;
    
    var activityIndicator: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        if let item = item{
            Database
                .database()
                .reference()
                .child("users")
                .child(Auth.auth().currentUser!.uid)
                .child("myalerts").child((item.id)).setValue(true)
        }
        
        
        Database
            .database()
            .reference()
            .child("users")
            .child(Auth.auth().currentUser!.uid)
            .child("myalerts")
            .observeSingleEvent(of: .value, with: { snapshot in
                if let data = snapshot.value as? [String: Any] {
                    let keys = Array(data.keys)
                    let URL = "items?ids=" + keys.joined(separator: ",")
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray) // Create the activity indicator
                    self.view.addSubview(activityIndicator) // add it as a  subview
                    activityIndicator.center = CGPoint(x: self.view.frame.size.width*0.5, y: self.view.frame.size.height * 0.5) // put in the middle
                    activityIndicator.startAnimating() // Start animating
                    self.activityIndicator = activityIndicator;
                    Synchronizer.sharedInstance.fetchItemsBySearchQuery(query: URL){
                            result, items in
                            self.items = items
                            self.tableView.reloadData()
                            self.activityIndicator!.stopAnimating()
                            self.activityIndicator!.removeFromSuperview()
                        }
                }
            })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    @IBAction func clickAction(_ sender: Any) {
        let webViewController = WebViewController()
        var buttonSender = sender as! UIButton
        webViewController.item = items[buttonSender.tag]
        self.navigationController?.pushViewController(webViewController, animated: true) //you can present it as wel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath) as! MyListTableViewCell
        cell.title.text = item.title
        cell.price.text = "$ \(item.price)"
        cell.button.tag = indexPath.row;
        
        ImageLoad.downloadImage(url: URL(string: item.thumbnail!)!, image: cell.mainImage)
        return cell
    }


}
