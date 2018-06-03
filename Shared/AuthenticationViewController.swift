//
//  AuthenticationViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/30/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedAuth:String = "Flickr"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: Tableview delegate & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.shared.current_accounts.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! UITableViewCell
        cell.textLabel?.text = Array(Settings.shared.current_accounts.keys)[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = Array(Settings.shared.current_accounts.keys)[indexPath.row]
        selectedAuth = account
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }
}

