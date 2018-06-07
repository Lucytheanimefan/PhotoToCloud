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
    var allPhotos: PHFetchResult<PHAsset>!
    
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
        getAllPhotos()
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
    
    func getAllPhotos(){
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        print("All photos count: \(allPhotos.count)")
        //print(allPhotos.enumerateObjects(<#T##block: (PHAsset, Int, UnsafeMutablePointer<ObjCBool>) -> Void##(PHAsset, Int, UnsafeMutablePointer<ObjCBool>) -> Void#>))
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
        
        if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
            // Update the cached fetch result.
            allPhotos = changeDetails.fetchResultAfterChanges
        }
        
        if let changes = changeInstance.changeDetails(for: fetchResult)
        {
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
                            UploadManager.shared.uploadImage(image: image)
                        }
                    }
                    
                }
                if let changed = changes.changedIndexes, changed.count > 0 {
                    
                }
                changes.enumerateMoves { fromIndex, toIndex in
                    
                }
            } else {
                // TODO: should this even go here, how to get all images?
                if UploadManager.shared.shouldUploadPastImages{
                    
                }
            }
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

