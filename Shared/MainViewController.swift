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
        
        // updateLoginStatus()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLoginStatus()
    }
    
    func updateLoginStatus(){
        FlickrKit.shared().checkAuthorization { (username, auth, name, error) in
            DispatchQueue.main.async {
                var loginMessage:String = ""
                if let error = error{
                    loginMessage += error.localizedDescription
                }
                else{
                    loginMessage += "Logged in on Flickr with username \(username!) as \(name!)"
                }
                
                loginMessage += "\n"
                
                loginMessage += ((GIDSignIn.sharedInstance().hasAuthInKeychain()) ? "Logged into Google" : "Not logged into Google")

                self.loginStatusTextView.text = loginMessage
            }
        }
    }
    
    @IBAction func uploadPhotoBacklog(_ sender: UIButton) {
        PhotoQueue.shared.uploadBacklog()
    }
    
    @IBAction func testUpload(_ sender: UIButton) {
        let image = #imageLiteral(resourceName: "penguinOctopus")
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
