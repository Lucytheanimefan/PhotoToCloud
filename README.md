# PhotoToCloud

An iOS app that automatically uploads your photos to the cloud. Made for people who only have 5 GB of iCloud storage and need to save their photos somewhere.

## Setup
You'll need a Constants.swift file to store your Flickr API key and secret.  
The file would look something like this: 
```
struct Flickr{
    static let APIKEY = "<API KEY>"
    static let APISECRET = "<API SECRET>"
}
```

## Current functionality
* Login/authentication with Flickr
* Any photo you take is automatically uploaded to Flickr
* Push notifications on successful upload
* Photo queue for photos that were not successfully uploaded to Flickr due to lack of network. Try uploading again later. 

## Future Features
* Uploading pictures automatically to: Google Drive, One Drive, Dropbox, etc. (And a settings view to configure all of this)
* Smarter detection of new photos vs. modified photos.
* It's pretty ugly right now.
