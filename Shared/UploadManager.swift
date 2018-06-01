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
            uploadImageToFlickr(image: image)
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
        
        guard driveService != nil else {
            print("Google drive service is nil")
            return
        }
        
        if !self.GDrivePhotoFolderExists(){
            print("Doesn't exist!")
            self.createGDrivePhotoFolder()
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
    
    func GDrivePhotoFolderExists()->Bool{
        var found:Bool = false
        
        let query = GTLRDriveQuery_FilesList.query()
        query.q = "mimeType='application/vnd.google-apps.folder' and name contains 'iPhonePhotos'"
        query.spaces = "drive"
        query.fields = "nextPageToken, files(id, name)"
        
        let sema = DispatchSemaphore(value: 1)
        self.driveService.executeQuery(query) { (ticket, folders, error) in
            if let error = error{
                Settings.shared.addLog(log: "Error finding GDrive folder: \(error.localizedDescription)")
            }
            else
            {
                if let folders = folders as? GTLRDrive_FileList{
                    Settings.shared.addLog(log: "Found GDrive folder")
                    for file in folders.files!{
                        print(file.name)
                        if file.name == "iPhonePhotos"{
                            found = true
                            break
                        }
                    }
                }
            }
            sema.signal()
        }
        sema.wait()
        return found


    }
    
    func createGDrivePhotoFolder(){
        let metadata = GTLRDrive_File()
        metadata.name = "iPhonePhotos"
        
        metadata.mimeType = "application/vnd.google-apps.folder"
        let querys = GTLRDriveQuery_FilesCreate.query(withObject: metadata, uploadParameters: nil)
        querys.fields = "id"
        
        let sema = DispatchSemaphore(value: 0)
        self.driveService.executeQuery(querys, completionHandler: {(ticket:GTLRServiceTicket, object:Any?, error:Error?) in
            
            if let error = error{
                print("\(self.description): \(error)")
                Settings.shared.addLog(log: "Error creating GDrive folder: \(error.localizedDescription)")
            }
            else{
                Settings.shared.addLog(log: "Created GDrive folder")
            }
            sema.signal()
        })
        sema.wait()
        
    }
    
}
