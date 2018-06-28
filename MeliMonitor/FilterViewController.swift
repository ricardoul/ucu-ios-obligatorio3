//
//  Filter.swift
//  Created by Ricardo Umpierrez on 6/24/18.
//

import UIKit
import Firebase

class FilterViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var filterTableView: UITableView!
    var filters = [Filters]()
    var actualFilters = [ActualFilters]()
    var filtersMain = [0];
    var filterCount = -1;
    var filterValueCount = 0;
    var mainFilter = ""
    
    
    @IBOutlet var filterDelete: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.delegate = self as UITableViewDelegate
        filterTableView.dataSource = self as UITableViewDataSource
    }
    
    @IBAction func clickAction(_ sender: Any) {
        let button = sender as! UIButton
        let rowIndex = button.tag
        let lastMainFilter = self.getLastMainFilter(nearNumber: rowIndex)
        var filterValue = filters[filtersMain.index(of: lastMainFilter)!].values
        var activeFilter = ActualFilters()
        activeFilter.id = filters[filtersMain.index(of: lastMainFilter)!].id
        activeFilter.name = filters[filtersMain.index(of: lastMainFilter)!].name!
        activeFilter.value = filterValue![rowIndex - 1 - lastMainFilter].id
        activeFilter.valueName = filterValue![rowIndex - 1 - lastMainFilter].name!
        actualFilters.append(activeFilter)
        performSegue(withIdentifier: "mrMainViewSegue", sender: sender);
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Here we set the quantity of cells to be created
        var rowCount = 0
        for filter in filters {
            filtersMain.append(rowCount)
            rowCount += (filter.values?.count)! + 1
        }
        filtersMain = Array(NSOrderedSet(array: filtersMain)) as! [Int]
        return rowCount + self.actualFilters.count
    }
    
    func getLastMainFilter(nearNumber: Int) -> Int {
        var maxLowerNumber = 0;
        for filterNum in filtersMain {
            if(filterNum <= nearNumber){
                maxLowerNumber = filterNum
            }
        }
        return maxLowerNumber
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let mrMain = segue.destination as! MrMainSearchViewController
        //Cast with your DestinationController
        //Now simply set the title property of vc
        let button = sender as! UIButton
        mrMain.actualFilters = self.actualFilters
        mrMain.mainFilter = self.mainFilter
    }
    @IBAction func activeFilterDeleteButton(_ sender: Any) {
        let button = sender as! UIButton
        let rowIndex = button.tag
        actualFilters.remove(at: rowIndex)
        performSegue(withIdentifier: "mrMainViewSegue", sender: sender);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Here we create the cells with information of the match
        if(indexPath.row < self.actualFilters.count){
            var identifier = "activeFilterID"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ActiveFilterCell
            cell.activeFilterLabel.text = self.actualFilters[indexPath.row].name + "-" + self.actualFilters[indexPath.row].valueName
            cell.deleteFiterButton.tag = indexPath.row
            return cell
        }
        let rowIndex = indexPath.row - self.actualFilters.count
        let lastMainFilter = self.getLastMainFilter(nearNumber: rowIndex)
        
        var isMainFilter = false
        if filtersMain.contains(rowIndex) {
            isMainFilter = true
        }
        
        var identifier = "valueID"
        if(isMainFilter){
            identifier = "filterID"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FilterCell
            cell.filterLabel.text = filters[filtersMain.index(of: lastMainFilter)!].name
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FilterValueCell
            
            var filterValue = filters[filtersMain.index(of: lastMainFilter)!].values
            cell.filterValueButton.setTitle(filterValue![rowIndex - 1 - lastMainFilter].name , for: UIControlState.normal)
             cell.filterValueButton.tag = rowIndex
            
            return cell
            
        }
    }
    
    
    func buildActualFilterString() -> String {
        var resultString = ""
        for filterActive in actualFilters{
            resultString += "&" + filterActive.id + "=" + filterActive.value
        }
        return resultString
    }
    
    @IBAction func saveAlertClick(_ sender: Any) {
        saveAlert()
        // create the alert
        let alert = UIAlertController(title: "Alerta Creada", message: "Se le notificara cuando aparezcan nuevos articulos.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
       
    }
    
    func saveAlert(){
        
        let URL = "" + self.mainFilter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + self.buildActualFilterString().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        Database
            .database()
            .reference()
            .child("users")
            .child(Auth.auth().currentUser!.uid)
            .child("myfilters").child(URL).setValue(true)
    }
    
    



    
}
