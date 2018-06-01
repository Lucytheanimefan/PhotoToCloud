//
//  AuthenticationViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/30/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    var selectedAuth:String = "Flickr"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authenticate(_ sender: Any) {
        selectedAuth = (sender as! UIButton).restorationIdentifier!
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    @IBAction func activateSwitch(_ sender: UISwitch) {
        let account = sender.restorationIdentifier!.components(separatedBy: "_")[0]
        print("Activated: \(account)")
        Settings.shared.current_accounts[account] = sender.isOn
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController{
            vc.selectedAuth = self.selectedAuth
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
