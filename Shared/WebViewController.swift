//
//  WebViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit
import FlickrKit
import GoogleAPIClientForREST
import GoogleSignIn

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var selectedAuth:String!
    
    // Google
    let signInButton = GIDSignInButton()
    let output = UITextView()
    
    let scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeDriveFile, kGTLRAuthScopeDriveAppdata]
    
    let service = GTLRDriveService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
         setupGoogle()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (selectedAuth == "Flickr"){
            webView.isHidden = false
            setUpFlickr()
        }
        else if (selectedAuth == "Google"){
            webView.isHidden = true
            
            GIDSignIn.sharedInstance().signIn()
            
            output.isEditable = false
            output.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
            output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            output.isHidden = true
            view.addSubview(output);
        }
    }
    
    func setUpFlickr(){
        //FlickrKit.shared().initialize(withAPIKey: Constants.Flickr.APIKEY, sharedSecret: Constants.Flickr.APISECRET)
        
        FlickrKit.shared().checkAuthorization(onCompletion: { (username, b, c, error) in
            print("Check auth:")
            if (error != nil){
                self.auth()
            }
            else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Already authenticated",
                                                  message: "Logged in as \(username!)",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: {
                            print("Dismissed")
                        })
                    })
                    
                    let loginAction = UIAlertAction(title: "Continue with login", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: {
                            self.auth()
                        })
                    })
                    // TODO: continue to login anyway action
                    alert.addAction(okAction)
                    alert.addAction(loginAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    func setupGoogle(){
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().scopes = scopes
    }
    
    private func auth(){
        
        let callbackURLString = "flickrkit://auth"
        let url = URL(string: callbackURLString)
        
        FlickrKit.shared().beginAuth(withCallbackURL: url!, permission: FKPermission.delete, completion: { (url, error) -> Void in
            
            if let error = error{
                print("\(self.description): \(error)")
                Settings.shared.logs.append("\(Date()): Error authenticating: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.showAlert(title: "Error authenticating", message: error.debugDescription)
//                }
            } else if let url = url{
                print(url)
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let urlRequest = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30)
                    self.webView.load(urlRequest as URLRequest)
                    
                })
            }
        })
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension WebViewController: GIDSignInUIDelegate, GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.showAlert(title: "Authentication Error", message: error.localizedDescription)
            print("ERROR AUTHENTICATING: \(error.localizedDescription)")
            Settings.shared.logs.append("\(Date()): Google auth error: \(error.localizedDescription)")
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            listFiles()
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    // List up to 10 files in Drive
    func listFiles() {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 10
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRDrive_FileList,
                                 error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var text = "";
        if let files = result.files, !files.isEmpty {
            text += "10 most recent files:\n"
            for file in files {
                text += "\(file.name!) (\(file.identifier!))\n"
            }
            print(files)
        } else {
            text += "No files found."
        }
        output.text = text
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
            
            FlickrKit.shared().completeAuth(with: url) { (username, b, c, error) in
                print("Complete auth:")
                if let error = error{
                    print(error)
                    Settings.shared.logs.append("\(Date()): Error completing auth: \(error.localizedDescription)")
                    decisionHandler(.cancel)
                }
                else if let username = username{
                    Settings.shared.logs.append("\(Date()): Successfully authenticated \(username)'s Flickr account")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success",
                                                      message: "Successfully authenticated your Flickr account",
                                                      preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                            //self.performSegue(withIdentifier: "toMainView", sender: self)
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }//else navigate to login
        else{
            decisionHandler(.allow)
            
        }
    }

}

