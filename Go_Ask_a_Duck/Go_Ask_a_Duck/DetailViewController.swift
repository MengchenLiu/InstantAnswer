//
//  DetailViewController.swift
//  Go_Ask_a_Duck
//
//  Created by Mengchen Liu on 2/15/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController ,UIPopoverPresentationControllerDelegate,UIWebViewDelegate{
    let defaults = UserDefaults.standard
    
    @IBAction func ModeButton(_ sender: Any) {
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
    @IBOutlet var LoadView: UIView!
    @IBOutlet weak var StarView: UIImageView!
    var detailItem: result? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


    //bookmark button
    @IBAction func BookmarkButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "popOver", sender: self)
        loadDismiss()
    }
    
    //
    @IBAction func FavoriteButton(_ sender: Any) {

        self.StarView?.isHidden = false
        var newurl = self.detailItem?.url
        if(newurl==nil){newurl = defaults.object(forKey: "lastURL") as! String?}
        if(newurl==nil){newurl = "https://www.apple.com"}
        var newarray = defaults.object(forKey:"bookmark") as? [String] ?? [String]()
        newarray.append(newurl!)
        defaults.set(newarray, forKey: "bookmark")
        defaults.synchronize()
    }
    
    @IBOutlet weak var webView: UIWebView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert()
        }


        self.configureView()

    }

    func configureView( ) {
        // Update the user interface for the detail item.
        if let strURL = detailItem?.url{
            let url = URL(string:strURL)
            let urlreq = URLRequest(url:url!)
            webView?.loadRequest(urlreq)
            let lastURL = strURL
            defaults.set(lastURL, forKey: "lastURL")
            defaults.synchronize()
            let newarray = defaults.object(forKey:"bookmark") as? [String] ?? [String]()
            if(newarray.contains(strURL)){
                self.StarView?.isHidden = false
            }
        }else{
            
            var str = defaults.object(forKey: "lastURL") as? String ?? ""
            if(str == ""){str = "https://www.apple.com"}
            let url = URL(string:str )
            let urlreq = URLRequest(url:url!)
            webView?.loadRequest(urlreq)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadIn(){

        //show the view
        self.view.addSubview(LoadView)
        LoadView.center = self.view.center
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseIn, animations:{},completion: nil)
    }
    
    //click for new game
    func loadDismiss(){
        UIView.animate(withDuration: 0.3, animations:{}){(success:Bool) in self.LoadView.removeFromSuperview()}

    }

    
    
    //popOver bookmark view
    //- Attribution:https://www.youtube.com/watch?v=48UA06EwfrM
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popOver"{
            let vc = segue.destination as! BookmarkViewController
            vc.delegates = self
            vc.preferredContentSize = CGSize(width: 500, height: 500)
            let controller = vc.popoverPresentationController
            if controller != nil{
                controller?.delegate = self
            }
            
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    //- Attribution:http://stackoverflow.com/questions/28149097/determinate-finish-loading-website-in-webview-with-swift-in-xcode
    //- Attribution:https://www.youtube.com/watch?v=UFKBTiylaN4
    func webViewDidFinishLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadDismiss()
    }
    func webViewDidStartLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadIn()
        if NetReach.isConnectedToNetwork() == false{
            self.showAlert()
        }

    }
    
    func didFailLoadWithError(_ webView: UIWebView){
        self.showAlert()
        
    }
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
}

extension DetailViewController : DetailBookmarkDelegate{
    func bookmarkPassedURL(url: String) {
        let url1 = URL(string:url)
        let urlreq = URLRequest(url:url1!)
        self.webView?.loadRequest(urlreq)
        let newarray = defaults.object(forKey:"bookmark") as? [String] ?? [String]()
        if(newarray.contains(url)){
            self.StarView?.isHidden = false
        }

    }
    func removeStar(url: String){
        if( self.detailItem?.url == url){
            let newarray = defaults.object(forKey:"bookmark") as? [String] ?? [String]()
            if(!newarray.contains(url)){
                self.StarView?.isHidden = true
            }
            
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
        //- Attribution:https://ngs.io/2014/10/26/refresh-ui-appearance/
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

