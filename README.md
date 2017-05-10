
# Utility for downloading and caching images in iOS Application

Download and Cache Images to avoid making multiple requests to the web server 

## Functionalities

* Uses an AsynImageView (subclass of ImageView) to asynchronously load resources
* Ability to show activity indicator, over the image view while the image is not set 
* Supports Placeholder images to be set (from the bundle)
* Supports Callback if image is set/failed to set
* Automatic clearing of cache elements older than 3 days (can be altered)
* Ability to set base URL as default configuration to fetch images from

## Setup and Usage
* Import the source folder in your project 
> Set the base URL (if required) in your _Info.plist_ to a string with key _ImageSuiteBaseAddress_
> 
> Override the cache time out (if required) in your _Info.plist_ to a string with key _ImageSuiteCacheInvalidateValue_

* Add following code in _AppDelegate.swift_

``` swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
//add this only if you want logs to appear. Passing false will explicitly prevent logging. Default set to false
        ImageManager.allowConsoleLogs(true)
        
//if the base URL is set  in plist file, load it from there to our image manager
        ImageManager.sharedInstance.loadBaseURL()
    }
```
* Assing UIImageViews the class of AsynImageView and then use the available methods to set images
        
``` swift
class DemoViewController: UIViewController {

    @IBOutlet var imageV: AsynImageView! //an outlet from storyboard
    
   ...
   
 //if the base URL is set, then we only supply the resource name/sub path to the function calls
 //adding no base URL will require the full resource address to be passed
 //even if the base URL is set and we pass a valid URL, the URL passed will be used to fetch the resource
 imageV.loadImage(from: "tests/image", placeHolderName: "placeholderImage", completion: { isSuccess in print("Status: \(isSuccess)")})
 
 ...

}

```
