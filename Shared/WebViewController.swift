//
//  WebViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func authenticate(_ sender: UIButton) {
        setUpFlickr()
    }
    
    func setUpFlickr(){
        FlickrKit.shared().initialize(withAPIKey: Flickr.APIKEY, sharedSecret: Flickr.APISECRET)
        
        FlickrKit.shared().checkAuthorization(onCompletion: { (a, b, c, error) in
            print("Check auth:")
            if (error != nil){
                print (error)
                self.auth()
            }
            else{
                print("\(a), \(b), \(c)")
            }
        })
    }
    
    private func auth(){
        
        let callbackURLString = "flickrkit://auth"
        let url = URL(string: callbackURLString)
        FlickrKit.shared().beginAuth(withCallbackURL: url!, permission: FKPermission.delete, completion: { (url, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let error = error?.localizedDescription{
                    print(error)
                }else{
                    let urlRequest = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30)
                    self.webView.load(urlRequest as URLRequest)
                }
            });
        })
        
    }
    
}


extension WebViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = webView.url else {return}
        print("URL HERE:")
        print(url)
        let scheme = url.scheme!
        
        print("Scheme: \(scheme)")
        //If URL scheme matches then try to do the Auth process
        if "flickrkit" == scheme{
            
            FlickrKit.shared().completeAuth(with: url) { (a, b, c, error) in
                print("Complete auth:")
                if (error != nil){
                    print (error)
                }
                else{
                    print("\(a), \(b), \(c)")
                }
                decisionHandler(.allow)
            }
        }//else navigate to login
        else{
           print("Not right url")
            decisionHandler(.allow)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
//                _ = self.navigationController?.popToRootViewController(animated: true)
//            })
        }
    }
    
}
