/*
	Copyright (C) 2017 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Manages app lifecycle  split view.
 */


import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var fetchResult: PHFetchResult<PHAsset>!
    
  
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
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

