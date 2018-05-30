/*
	Copyright (C) 2017 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Manages app lifecycle  split view.
 */


import UIKit
import Photos
import UserNotifications
import FlickrKit
import GoogleSignIn
import GoogleAPIClientForREST
import GoogleToolboxForMac

// import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var fetchResult: PHFetchResult<PHAsset>!
    
    func uploadImageToFlickr(image:UIImage){
        
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
                self.doNotifications(title: "Successful upload", body: "Uploaded image to Flickr")
                #endif
                Settings.shared.logs.append("\(Date()): Uploaded image to Flickr")
            }
        }
    }
    
    func uploadImageToGDrive(image: UIImage){
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
    
    func tryBacklog(){
        guard PhotoQueue.shared.isBacklog() else {return}
        #if DEBUG
        self.doNotifications(title: "Upload backlog", body: "Uploaded \(PhotoQueue.shared.queue.count) backlog images")
        #endif
        PhotoQueue.shared.uploadBacklog()
    }
    
    func setUpFlickr(){
        FlickrKit.shared().initialize(withAPIKey: Constants.Flickr.APIKEY, sharedSecret: Constants.Flickr.APISECRET)
    }
    
    func setupDropbox(){
        // DropboxClientsManager.setupWithAppKey("<APP_KEY>")
    }
    
    func setupGDrive(){
        GIDSignIn.sharedInstance().clientID = Constants.Google.CLIENTID
    }
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setUpFlickr()
        setupGDrive()
        registerForPushNotifications()
        updateFetchResult()
        PHPhotoLibrary.shared().register(self)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            
        })

        if (bgTask == UIBackgroundTaskInvalid) {
            print("This application does not support background mode");
        } else {
            //if application supports background mode, we'll see this log.
            print("Application will continue to run in background");
            PHPhotoLibrary.requestAuthorization { (status) in
                if (status == .authorized) {
                    PHPhotoLibrary.shared().register(self)
                }
            }
            
            PHPhotoLibrary.shared().register(self)
        }
    }
    
    func applicationSignificantTimeChange(_ application: UIApplication) {
        updateFetchResult()
        tryBacklog()
    }
    
    func updateFetchResult(){
        guard fetchResult == nil else { return }
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func doNotifications(title:String, body:String) {
        
        // START NOTIFICATION
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        //let options: UNAuthorizationOptions = [.alert, .sound]
        
        // content 1
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        
        // content one actions
        let snoozeAction = UNNotificationAction(identifier: "Yes",
                                                title: "Yes", options: [])
        let deleteAction = UNNotificationAction(identifier: "No",
                                                title: "No", options: [.destructive])
        

        content.categoryIdentifier = "UYLReminderCategory"
        
        // content one category
        let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                              actions: [snoozeAction,deleteAction],
                                              intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        
    }


}

// MARK: PHPhotoLibraryChangeObserver
extension AppDelegate: PHPhotoLibraryChangeObserver {
    
    // Change notifications may be made on a background queue.
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        fetchResult = changes.fetchResultAfterChanges
        if changes.hasIncrementalChanges {
            // If we have incremental diffs
            if let removed = changes.removedIndexes, removed.count > 0 {
                
            }
            if let inserted = changes.insertedIndexes, inserted.count > 0 {
                // New photos are added, upload to cloud
                print("\(self.description): Added photos: \(inserted.count)")
                Settings.shared.logs.append("\(Date()): New photo detected")
                
                changes.insertedObjects.forEach { (asset) in
                    if let image = getUIImage(asset: asset){
                        guard Reachability.isConnectedToNetwork() else {
                            PhotoQueue.shared.queue.append(image)
                            return
                        }
                        //uploadImageToFlickr(image: image)
                        uploadImageToGDrive(image: image)
                    }
                }
                
            }
            if let changed = changes.changedIndexes, changed.count > 0 {
                
            }
            changes.enumerateMoves { fromIndex, toIndex in
                
            }
        } else {
            // incremental diffs are not available, do nothing
        }
        // resetCachedAssets()
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }

}

