//
//  LogViewController.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/29/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    var log:String?
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logTextView.text = log!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
