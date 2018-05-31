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
    
    static func uploadImage(image:UIImage){
        if (Settings.shared.current_accounts["Google"]!){
            uploadImageToGDrive(image: image)
        }
        if (Settings.shared.current_accounts["Flickr"]!){
            uploadImageToGDrive(image: image)
        }
    }
    
    static func uploadImageSync(image:UIImage){
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
    
    static func uploadImageToFlickr(image:UIImage, completion: (() -> ())? = nil){
        
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
    
    static func uploadImageToGDrive(image: UIImage, completion: (() -> ())? = nil){
        guard let fileData = UIImagePNGRepresentation(image) else { return }
        
        let mimeType = "image/png"
        let gFile = GTLRDrive_File()
        
        gFile.mimeType = mimeType
        
        // TODO: parent folder
        // gFile.parents =
        
        let uploadParams = GTLRUploadParameters(data: fileData, mimeType: mimeType)
        
        let driveService = GTLRDriveService()
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: gFile, uploadParameters: uploadParams)
        
        driveService.executeQuery(query, completionHandler:  { (ticket, insertedFile , error) -> Void in
            
            if error == nil, let myFile = insertedFile as? GTLRDrive_File {
                print("GDrive success: \(myFile.identifier)")
                Settings.shared.addLog(log: "Uploaded image \(myFile.identifier) to GDrive")
            } else {
                Settings.shared.addLog(log: error!.localizedDescription)
                print("An Error Occurred! \(error)")
            }
            completion?()
            
        })
        //        // define the mimeType
        //        NSString *mimeType = @"image/png";
        //
        //        // This is just because of unique name you can give it whatever you want
        //        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //        [df setDateFormat:@"dd-MMM-yyyy-hh-mm-ss"];
        //        NSString *fileName = [df stringFromDate:[NSDate date]];
        //        fileName = [fileName stringByAppendingPathExtension:@"png"];
        //
        //        // Initialize newFile like this
        //        GTLDriveFile *newFile = [[GTLDriveFile alloc] init];
        //        newFile.mimeType = mimeType;
        //        newFile.originalFilename = fileName;
        //        newFile.title = fileName;
        //
        //        // Query and UploadParameters
        //        GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:mimeType];
        //        GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:newFile uploadParameters:uploadParameters];
        //
        //        // This is for uploading into specific folder, I set it "root" for root folder.
        //        // You can give any "folderIdentifier" to upload in that folder
        //        GTLDriveParentReference *parentReference = [GTLDriveParentReference object];
        //        parentReference.identifier = @"root";
        //        newFile.parents = @[parentReference];
        //
        //        // And at last this is the method to upload the file
        //        [[self driveService] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        //
        //        if (error){
        //        NSLog(@"Error: %@", error.description);
        //        }
        //        else{
        //        NSLog(@"File has been uploaded successfully in root folder.");
        //        }
        //        }];
    }

}
