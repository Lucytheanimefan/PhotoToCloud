//
//  LogTableViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {
    
    var selectedLog:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        Settings.shared.logDelegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (Settings.shared.logs.count > 50){
            Settings.shared.logs.removeAll(keepingCapacity: false)
        }
    }
    
    @IBAction func onRefresh(_ sender: UIRefreshControl) {
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Settings.shared.logs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = Settings.shared.logs.count - indexPath.row - 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "logId", for: indexPath)

        cell.textLabel?.text = Settings.shared.logs[index]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toSingleLogView", sender: self)
    }
    

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let index = Settings.shared.logs.count - indexPath.row - 1
        self.selectedLog = Settings.shared.logs[index]
        return indexPath
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? LogViewController{
            vc.log = selectedLog
        }
    }
    

}

extension LogTableViewController: LogDelegate{
    func onAddLog() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
