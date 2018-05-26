/*
	Copyright (C) 2017 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Manages app lifecycle  split view.
 */


import UIKit
import Photos
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var fetchResult: PHFetchResult<PHAsset>!
    
  
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications()
        updateFetchResult()
        PHPhotoLibrary.shared().register(self)
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        #if os(iOS)
            let navigationController = splitViewController.viewControllers.last! as! UINavigationController
            navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        #endif
        splitViewController.delegate = self
        return true
    }
    
    func applicationSignificantTimeChange(_ application: UIApplication) {
        updateFetchResult()
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
    
    func doNotifications(numPhotos:Int) {
        
        // START NOTIFICATION
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        //let options: UNAuthorizationOptions = [.alert, .sound]
        
        // content 1
        let content = UNMutableNotificationContent()
        content.title = "Photo added"
        content.body = "Added \(numPhotos) photos"
        content.sound = UNNotificationSound.default()
        
        
        // content one actions
        let snoozeAction = UNNotificationAction(identifier: "Yes",
                                                title: "Yes", options: [])
        let deleteAction = UNNotificationAction(identifier: "No",
                                                title: "No", options: [.destructive])
        
        // content2 actions
        let emailAction = UNNotificationAction(identifier: "emailAction", title: "Email Provider", options: [.foreground])
        let textAction = UNNotificationAction(identifier: "textAction", title: "Text Provider", options: [.foreground])
        let callAction = UNNotificationAction(identifier: "callAction", title: "Call Provider", options: [.foreground])
        
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


    // MARK: Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? AssetGridViewController else { return false }
        if topAsDetailController.fetchResult == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        // Let the storyboard handle the segue for every case except going from detail:assetgrid to detail:asset.
        guard !splitViewController.isCollapsed else { return false }
        guard !(vc is UINavigationController) else { return false }
        guard let detailNavController =
            splitViewController.viewControllers.last! as? UINavigationController,
            detailNavController.viewControllers.count == 1
            else { return false }

        detailNavController.pushViewController(vc, animated: true)
        return true
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
                
                print("\(self.description): Added photos: \(inserted.count)")
                doNotifications(numPhotos: inserted.count)
                // New photos are added, upload to cloud
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
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }

}

