//
//  MrMainSearchViewController.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 5/31/18.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import Firebase
import FirebaseAuthUI
import GoogleSignIn
import ImagePicker
import Lightbox
import MaterialComponents


class MrMainSearchViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate,UICollectionViewDelegateFlowLayout,  InviteDelegate {
    
  
    
     var items = [Item]()
     var filters = [Filters]()
     var actualFilters = [ActualFilters]()
     var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func invite(_ sender: Any) {
        if let invite = Invites.inviteDialog() {
            invite.setInviteDelegate(self)
            
            // NOTE: You must have the App Store ID set in your developer console project
            // in order for invitations to successfully be sent.
            
            // A message hint for the dialog. Note this manifests differently depending on the
            // received invitation type. For example, in an email invite this appears as the subject.
            invite.setMessage("Prueba esta app")
            // Title for the dialog, this is what the user sees before sending the invites.
            invite.setTitle("No pierdas una oferta mas")
            invite.setDeepLink("app_url")
            invite.setCallToActionText("Install!")
            invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
            invite.open()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mainFilter = self.uiSearchBar.text!;
        self.getMlItems()
    }
    
    @IBAction func filterButton(_ sender: Any) {
         performSegue(withIdentifier: "filterSegue", sender: "filter");
    }
    @IBOutlet weak var searchWithText: UIBarButtonItem!
    
    @IBOutlet weak var textSearchField: UITextField!
    
    @IBOutlet weak var uiSearchBar: UISearchBar!
    var mainFilter = "ipod"
    
    @IBAction func searchWithTheText(_ sender: Any) {
        mainFilter = self.textSearchField.text!;
        self.getMlItems()
    }
    
     let bottomBarView = MDCBottomAppBarView()
    
    lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var uid = Auth.auth().currentUser!.uid
    
    lazy var database = Database.database()
    
    
    @IBOutlet weak var carButton: UIButton!
    
    @IBAction func carButtonAction(_ sender: Any) {
        mainFilter = "autos"
        actualFilters.removeAll()
        self.getMlItems()
    }
    
    @IBAction func laptopButtonAction(_ sender: Any) {
        mainFilter = "laptop"
        actualFilters.removeAll()
        self.getMlItems()
    }
    
    @IBOutlet weak var phoneButtonAction: UIButton!
    
    @IBOutlet weak var tvButtonAction: UIButton!
    @IBAction func phoneButtonActions(_ sender: Any) {
         mainFilter = "celulares"
        actualFilters.removeAll()
        self.getMlItems()
    }
    
    @IBAction func motorbikeButtonAction(_ sender: Any) {
         mainFilter = "motos"
        actualFilters.removeAll()
        self.getMlItems()
    }
    
    @IBAction func tvActions(_ sender: Any) {
        mainFilter = "tele"
        actualFilters.removeAll()
        self.getMlItems()
    }
    
    @IBOutlet weak var button1: UIButton!{
        didSet{
            self.button1.layer.cornerRadius = self.button1.layer.frame.width/2
            self.button1.layer.masksToBounds = true
        }
        
    }
    
    @IBOutlet weak var button2: UIButton!{
        didSet{
            self.button2.layer.cornerRadius = self.button1.layer.frame.width/2
            self.button2.layer.masksToBounds = true
        }
        
    }
    
    @IBOutlet weak var button3: UIButton!{
        didSet{
            self.button3.layer.cornerRadius = self.button1.layer.frame.width/2
            self.button3.layer.masksToBounds = true
        }
        
    }
    @IBOutlet weak var button4: UIButton!{
        didSet{
            self.button4.layer.cornerRadius = self.button1.layer.frame.width/2
            self.button4.layer.masksToBounds = true
        }
        
    }
    @IBOutlet weak var button5: UIButton!{
        didSet{
            self.button5.layer.cornerRadius = self.button1.layer.frame.width/2
            self.button5.layer.masksToBounds = true
        }
        
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMlItems()
        
        self.uiSearchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currentUser = Auth.auth().currentUser  {
            self.uid = currentUser.uid
            Crashlytics.sharedInstance().setUserIdentifier(currentUser.uid)
        } else {
            let authViewController = FUIAuth.defaultAuthUI()?.authViewController()
            authViewController?.navigationBar.isHidden = true
            self.present(authViewController!, animated: true, completion: nil)
            return
        }
        MDCSnackbarManager.setBottomOffset(bottomBarView.frame.height)
        if let item = navigationItem.rightBarButtonItems?[0] {
            item.accessibilityLabel = ""
            item.accessibilityHint = "Double-tap to open your profile."
            if let photoURL = Auth.auth().currentUser?.photoURL {
                UIImage.circleButton(with: photoURL, to: item)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //DetailsViewControler
        if let vipViewController = segue.destination as? VipViewController {
        
            //Now simply set the title property of vc
            let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
            let item = items[(indexPath?.item)!]
            vipViewController.item = item
        }
        //DetailsViewControler
        else if let filterViewController = segue.destination as? FilterViewController {
            
            //Now simply set the title property of vc
            filterViewController.filters = self.filters;
            filterViewController.actualFilters = self.actualFilters;
            filterViewController.mainFilter = self.mainFilter
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! HotItemCollectionViewCell
        
        var aux = items[indexPath.item]
        cell.price.text = "$ \(aux.price)"
        cell.name.text = aux.title
        ImageLoad.downloadImage(url:  URL(string:aux.thumbnail!)!, image: cell.image)
        
        // Configure the cell
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width/2.2, height: 160)
    }
    
    func buildActualFilterString() -> String {
        var resultString = ""
        for filterActive in actualFilters{
            resultString += "&" + filterActive.id + "=" + filterActive.value
        }
        return resultString
    }
    
    func getMlItems(){
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray) // Create the activity indicator
        view.addSubview(activityIndicator) // add it as a  subview
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height * 0.5) // put in the middle
        activityIndicator.startAnimating() // Start animating
        self.activityIndicator = activityIndicator;
        let URL = "https://api.mercadolibre.com/sites/MLU/search?q=" + self.mainFilter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + self.buildActualFilterString().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        Alamofire.request(URL).responseObject { (response: DataResponse<MLResponse>) in
            
            let responseArray = response.result.value
            
            self.items = (responseArray?.results)!;
            self.filters = (responseArray?.availabeFilters)!;
            self.collectionView.reloadData()
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.removeFromSuperview()
            
        }
    }

}
