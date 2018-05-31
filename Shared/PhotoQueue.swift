//
//  PhotoQueue.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FlickrKit

class PhotoQueue: NSObject {
    
    static let shared = PhotoQueue()
    
    var queue:[UIImage] = [UIImage]()
    
    func isBacklog()->Bool{
        return self.queue.count > 0
    }
    
    func uploadBacklog(){
        Settings.shared.logs.append("\(Date()): Uploaded backlog of \(self.queue.count) images")
        for (i, image) in queue.enumerated(){
            guard Reachability.isConnectedToNetwork() else {
                continue
            }
            if (Settings.shared.current_accounts["Flickr"])!{
            FlickrKit.shared().uploadImage(image, args: Settings.shared.flickrArgs) { (result, error) in
                if (error != nil){
                    print("Error uploading image! \(error)")
                }
                else
                {
                    #if DEBUG
                    print(result)
                    #endif
                    self.queue.remove(at: (i-1))
                }
            }
            }
            if (Settings.shared.current_accounts["Google"])!{
                UploadManager.uploadImageToGDrive(image: image)
            }
        }
    }

}
