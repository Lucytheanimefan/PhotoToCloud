# PhotoToCloud

An iOS app that automatically uploads your photos to the cloud. Made for people who only have 5 GB of iCloud storage and need to save their photos somewhere.

## Setup
You'll need a Constants.swift file to store your Flickr API key and secret.  
The file would look something like this: 
```
import Foundation

struct Constants{
    struct Flickr{
        static let APIKEY = "<API KEY>"
        static let APISECRET = "<API SECRET>"


        static let safe = 1
        static let moderate = 2
        static let restricted = 3

    }

    struct Google{
        static let CLIENTID = <CLIENTID retrieved from credentials.plist from google app creation>
    }
}
```

## Current functionality
* Login/authentication with Flickr, Google Drive
* Any photo you take is automatically uploaded to Flickr, Google Drive
* Push notifications on successful upload
* Photo queue for photos that were not successfully uploaded to Flickr, Google Drive due to lack of network. Try uploading again later. 
* Be able to upload all previous photos and specify criteria based on location, creation date.
* Settings view to specify which account to upload images to.

## Future Features
* Uploading pictures automatically to: One Drive, Dropbox, etc. (And a settings view to configure all of this)
* Smarter detection of new photos vs. modified photos.
* It's pretty ugly right now.

## How it works
The bulk of the functionality of this app uses the Photos framework–specifically, the `PHPhotoLibraryChangeObserver`. `PHPhotoLibraryChangeObserver` allows us to determine when a new image is added to the Photos app. From the observer, we can fetch changes and convert this to an `UIImage` object. Furthermore, the app must be able to run in background mode in order to detect and upload newly taken photos while the user is using a different app. This is accomplished through registering the `PHPhotoLibrary` instance in the  `AppDelegate`'s `applicationDidEnterBackground`.
