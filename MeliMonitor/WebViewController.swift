//
//  WebViewController.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var item:Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item?.title!
        

        let webV    = UIWebView()
        webV.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webV.loadRequest(NSURLRequest(url: NSURL(string: (item?.permalink!)!)! as URL) as URLRequest)
        webV.delegate = self
        self.view.addSubview(webV)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
