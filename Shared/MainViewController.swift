//
//  MainViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FlickrKit
import GoogleSignIn

class MainViewController: UIViewController {
    @IBOutlet weak var loginStatusTextView: UITextView!
    
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLoginStatus()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
        Settings.shared.logs.append("\(Date()): Accessed main view")
        #endif
    }
    
    func updateLoginStatus(){
        
        // Flickr
        FlickrKit.shared().checkAuthorization { (username, auth, name, error) in
            DispatchQueue.main.async {
                if (error != nil){
                    self.loginStatusTextView.text = error?.localizedDescription
                }
                else{
                    self.loginStatusTextView.text = "Logged in on Flickr with username \(username!) as \(name!)"
                }
            }
        }
        
        // Google
        print(GIDSignIn.sharedInstance().hasAuthInKeychain())
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            self.loginStatusTextView.text = self.loginStatusTextView.text + "\nLogged in as \(GIDSignIn.sharedInstance().currentUser.profile.email)"
        }
        
    }
    @IBAction func uploadPhotoBacklog(_ sender: UIButton) {
        PhotoQueue.shared.uploadBacklog()
    }
    
    @IBAction func testUpload(_ sender: UIButton) {
        let image = #imageLiteral(resourceName: "penguinOctopus")
//        UploadManager.shared.uploadImageToGDrive(image: image, progressBlock: { (bytesRead, dataLength) in
//            self.progressView.setProgress(Float(bytesRead/dataLength), animated: true)
//        }) {
//            print("DONE")
//        }
        UploadManager.shared.uploadImage(image: image)
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
