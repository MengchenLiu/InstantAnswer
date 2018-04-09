//
//  BookmarkViewController.swift
//  Go_Ask_a_Duck
//
//  Created by Mengchen Liu on 2/16/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let defaults = UserDefaults.standard

    @IBAction func Mode(_ sender: Any) {
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
    weak var delegates: DetailBookmarkDelegate?
    var arr = [""]
    
    @IBOutlet weak var BookmarkTable: UITableView!
    @IBAction func CloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.preferredContentSize = CGSize(width: 500, height: 500)
       
        BookmarkTable.dataSource=self
        BookmarkTable.delegate=self
        
        let defaults = UserDefaults.standard
        
        self.arr = defaults.object(forKey:"bookmark") as? [String] ?? [String]()
//        print("........................................................")
//        print(arr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - TableView
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)
            //let object = objects[indexPath.row] as! NSDate
            let object = arr[indexPath.row]
            cell.textLabel!.text = object
            return cell
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            delegates?.bookmarkPassedURL(url: arr[indexPath.row])
            //print(arr[indexPath.row])
            self.dismiss(animated: true, completion: nil)
            
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let url = arr[indexPath.row]
                arr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                let defaults = UserDefaults.standard
                defaults.set(arr, forKey: "bookmark")
                delegates?.removeStar(url: url)
                

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
