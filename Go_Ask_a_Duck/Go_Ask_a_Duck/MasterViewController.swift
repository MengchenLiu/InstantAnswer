//
//  MasterViewController.swift
//  Go_Ask_a_Duck
//
//  Created by Mengchen Liu on 2/15/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController , UISearchBarDelegate {

    @IBAction func modeButton(_ sender: Any) {
        let mode = defaults.object(forKey: "mode") as? Int ?? 0
        if(mode == 1){
            defaults.set(0, forKey: "mode")
            self.changeMode()
        }
        else{
            defaults.set(1, forKey: "mode")
            self.changeMode()
        }
    }
    @IBOutlet weak var SearchBar: UISearchBar!
    var detailViewController: DetailViewController? = nil
    var objects = [result]()
    let defaults = UserDefaults.standard
    //var results = [result]()

    let net = SharedNetworking()

    func showAlert() {
        let alert = UIAlertController(title: "Connect Error", message: "Something wrong with network...", preferredStyle:.alert)
        let ok = UIAlertAction(title: "ok", style: .default) { (ok) -> Void in
            print("ok")
        }
        alert.addAction(ok)
        self.present(alert, animated: true) { () -> Void in
            print("present")
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.changeMode()

        
        self.SearchBar.delegate = self
        
        //- Attribution:https://www.raywenderlich.com/129059/self-sizing-table-view-cells
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //lanuch last inquery
        var query = defaults.object(forKey:"lastInquery") as? String ?? ""
        if(query == ""){query = "apple"}
        let searchURL = "https://api.duckduckgo.com/?q="+query+"&format=json&pretty=1"
        net.hhh(searchURL,resultHandler)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.SearchBar.text = query
        
        
        //- Attribution:http://nshipster.com/uiappearance/
        //Use UIAppearance proxy to customize the appearance
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert()
        }
    }
    //- Attribution:http://stackoverflow.com/questions/30058311/get-searchbar-text-in-swift
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert()
        }

        print("searchText \(searchBar.text)")
        let searchURL = "https://api.duckduckgo.com/?q="+searchBar.text!+"&format=json&pretty=1"
        net.hhh(searchURL,resultHandler)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        defaults.set(searchBar.text!, forKey: "lastInquery")
        defaults.synchronize()
    }

    //- Attribution:http://www.appcoda.com.tw/json-data-taipei-tutorial/
    //- Attribution:http://stackoverflow.com/questions/26794701/how-to-get-data-to-return-from-nsurlsessiondatatask-in-swift?noredirect=1&lq=1
    func resultHandler(res:[result]?)->Void
    {
        self.objects = res!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCell", for: indexPath) as! MasterCell
        //let object = objects[indexPath.row] as! NSDate
        let object = objects[indexPath.row]
        cell.TextLabel!.text = object.text
        cell.FirstURLLabel!.text = object.url
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func changeMode(){
        let mode = defaults.object(forKey: "mode") as? Int ?? 0
        if(mode == 1){
            UITableView.appearance().backgroundColor = UIColor.black
            UITableViewCell.appearance().backgroundColor = UIColor.black
            UITableView.appearance().tintColor = UIColor.black
            
            UILabel.appearance().textColor = UIColor.white
            
            
            UINavigationBar.appearance().backgroundColor = UIColor.black
            UINavigationBar.appearance().barTintColor = UIColor.black
            
            UIButton.appearance().backgroundColor = UIColor.black
            UIToolbar.appearance().barTintColor = UIColor.black
            UIToolbar.appearance().backgroundColor = UIColor.black

        }
        else{
            UITableView.appearance().backgroundColor = UIColor.white
            UITableView.appearance().tintColor = UIColor.white
            UITableViewCell.appearance().backgroundColor = UIColor.white
            
            UILabel.appearance().textColor = UIColor.black
            
            UINavigationBar.appearance().backgroundColor = UIColor.init(red: 0.64, green: 0.95, blue: 0.52, alpha: 1)
            UINavigationBar.appearance().barTintColor = UIColor.init(red: 0.64, green: 0.95, blue: 0.52, alpha: 1)

            UIButton.appearance().backgroundColor = UIColor.init(red: 0.64, green: 0.95, blue: 0.52, alpha: 1)
            UIToolbar.appearance().barTintColor = UIColor.init(red: 0.64, green: 0.95, blue: 0.52, alpha: 1)
            UIToolbar.appearance().backgroundColor = UIColor.init(red: 0.64, green: 0.95, blue: 0.52, alpha: 1)
        }
        
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                v.removeFromSuperview()
                window.addSubview(v)
            }
        }
    }

}

