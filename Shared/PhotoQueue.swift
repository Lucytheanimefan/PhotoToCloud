//
//  PhotoQueue.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class PhotoQueue: NSObject {
    
    static let shared = PhotoQueue()
    
    var queue:[UIImage] = [UIImage]()
    
    func uploadBacklog(){
        for (i, image) in queue.enumerated(){
            guard Reachability.isConnectedToNetwork() else {
                continue
            }
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
    }

}
