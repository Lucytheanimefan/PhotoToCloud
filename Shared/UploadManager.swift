//
//  UploadManager.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/31/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FlickrKit
import GoogleSignIn
import GoogleAPIClientForREST

class UploadManager: NSObject {
    
    var driveService:GTLRDriveService!
    
    static let shared = UploadManager()
    
    func uploadImage(image:UIImage){
        if (Settings.shared.current_accounts["Google"]!){
            uploadImageToGDrive(image: image)
        }
        if (Settings.shared.current_accounts["Flickr"]!){
            uploadImageToGDrive(image: image)
        }
    }
    
    func uploadImageSync(image:UIImage){
        if (Settings.shared.current_accounts["Google"]!){
            let sema0 = DispatchSemaphore(value: 0)
            uploadImageToGDrive(image: image) {
                sema0.signal()
            }
            sema0.wait()
        }
    
        if (Settings.shared.current_accounts["Flickr"]!){
            let sema1 = DispatchSemaphore(value: 1)
            uploadImageToFlickr(image: image) {
                sema1.signal()
            }
            sema1.wait()
        }
        
    }
    
    func uploadImageToFlickr(image:UIImage, completion: (() -> ())? = nil){
        
        print("Upload Flickr image with settings: \(Settings.shared.flickrArgs)")
        FlickrKit.shared().uploadImage(image, args: Settings.shared.flickrArgs) { (result, error) in
            if (error != nil){
                Settings.shared.logs.append("\(Date()): Error uploading image: \(error!.localizedDescription)")
                print("Error uploading image: \(error!.localizedDescription)")
            }
            else
            {
                #if DEBUG
                print(result.debugDescription)
                #endif
                Settings.shared.logs.append("\(Date()): Uploaded image to Flickr")
            }
            
            completion?()
        }
    }
    
    func uploadImageToGDrive(image: UIImage, progressBlock: ((_ bytesRead:UInt64, _ dataLength: UInt64) -> ())? = nil, completion: (() -> ())? = nil){
        print("\(self.description): Start upload image to GDrive")
        guard let fileData = UIImagePNGRepresentation(image) else {
            print("No image data")
            return
        }
        
        let mimeType = "image/png"
        let gFile = GTLRDrive_File()
        
        gFile.mimeType = mimeType
        
        // TODO: parent folder
        // gFile.parents =
        
        let uploadParams = GTLRUploadParameters(data: fileData, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: gFile, uploadParameters: uploadParams)
        
        query.executionParameters.uploadProgressBlock = { (ticket, numBytesRead, dataLength) -> Void in
            if let block = progressBlock{
                block(numBytesRead, dataLength)
            }
        }
        
        self.driveService.executeQuery(query, completionHandler:  { (ticket, insertedFile , error) -> Void in
            print(error?.localizedDescription)
            //print(ticket.description)
            print(ticket.fetchError?.localizedDescription)
            print(insertedFile)
            if error == nil, let myFile = insertedFile as? GTLRDrive_File {
                print("GDrive success: \(myFile.identifier)")
                Settings.shared.addLog(log: "Uploaded image \(myFile.identifier) to GDrive")
            } else {
                Settings.shared.addLog(log: error!.localizedDescription)
                print("An Error Occurred! \(error)")
            }
            completion?()
            
        })

    }

}
