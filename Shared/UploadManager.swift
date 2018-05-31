//
//  UploadManager.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/31/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class UploadManager: NSObject {
    
    static func uploadImageToGDrive(image: UIImage){
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
                Settings.shared.addLog(log: "Added file \(myFile.identifier) to GDrive")
            } else {
                Settings.shared.addLog(log: error!.localizedDescription)
                print("An Error Occurred! \(error)")
            }
            
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
