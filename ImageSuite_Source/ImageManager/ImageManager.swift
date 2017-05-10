//  MIT License
//
//  Copyright (c) 2017 Tushar Mohan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

final class ImageManager: NSObject {
    
    private var baseAddress: String?
    
    // MARK: - Singleton Init and Manager Setup
    
    static let sharedInstance: ImageManager = {
        let instance = ImageManager()
        
        if let cacheDirectory = instance.getCacheDirectory() {
            let expirationValue = FileOperations.getCacheExpirationValue()
                
            ImageSuiteLogger.parse("Cache expiry value: \(expirationValue)")
            FileOperations.removeResourcesOlderThan(expirationValue, from:cacheDirectory)
        }
        
        return instance
    }()
    
    private override init() {}
    
    class func allowConsoleLogs(_ isAllowed:Bool) {
        ImageSuiteLogger.isLoggingEnabled = isAllowed
    }
    
    /// Set the base URL of the image manager to load image from. Not setting this will require full paths of resources
    ///
    /// - Parameter baseURL: base URL to access resource files
    func loadBaseURL() {
        baseAddress = FileOperations.getBaseAddress()
        ImageSuiteLogger.parse("Base Address Set to \(baseAddress!)")
    }
    
    func loadImage(from imageURL:String, onCompletion:@escaping DownloadImageCompletion) {
        let isResourceAtBaseAddress = !imageURL.isCompleteURL()
        let generatedResourceName = generateResourceName(with: imageURL, usingBaseAddress: isResourceAtBaseAddress)
        let isFileAlreadyInCache = fileExistsInCache(generatedResourceName)
        
        if isFileAlreadyInCache, let filePath = getCacheImagePathFor(generatedResourceName) {
            //send the path of file which is inside cache
            initiateCallBack(onCompletion,filePath: filePath)
            
        } else {
            guard let downloadRequest = ImageDownloader.buildImageDownloadRequest(url:(generatedResourceName)) else {
                return
            }
            
            ImageDownloader.sendRequest(downloadRequest, onCompletion: { (responseData, downloadError) in
                if let responseData = responseData, let filePath = self.getCacheImagePathFor(generatedResourceName) {
                    if FileOperations.saveImage(imageData: responseData, to: filePath) {
                        self.initiateCallBack(onCompletion,filePath: filePath)
                    } else {
                        self.initiateCallBack(onCompletion,filePath: nil)
                    }
                }
            })
        }
    }
    
    func clearCache() {
        guard let directory = getCacheDirectory() else {return}
        FileOperations.clearDiskCache(directory)
    }
    
    // MARK: - Private
    
    /// Sanitises string of any white spaces and newline characters and returns the corresponding resource path
    ///
    /// - Parameters:
    ///   - name: name of resource
    ///   - usingBaseAddress: true: uses the base address set in ImageManager
    /// - Returns: complete string with base address
    private func generateResourceName(with name:String, usingBaseAddress:Bool) -> String {
        var resourceName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if usingBaseAddress, let baseAddress = baseAddress {
            resourceName = baseAddress.appending(resourceName)
        }
        
        return resourceName
        
    }
    
    /// Searches cache to check if a file exists or not in cache
    ///
    /// - Parameter resourceName: name of the resource
    /// - Returns: true: if exists else false
    private func fileExistsInCache(_ resourceName:String) -> Bool {
        let filePath = getCacheImagePathFor(resourceName)
        var doesFileExist: Bool = false
        
        if let filePath = filePath {
           doesFileExist = FileManager.default.fileExists(atPath: filePath)
        }
        
        return doesFileExist
    }
    
    /// Get the full path for caching the image
    ///
    /// - Parameter resourceName: name of the resource
    /// - Returns: full path for image to be cached
    private func getCacheImagePathFor(_ resourceName:String) -> String? {
        guard let cacheDirectory = getCacheDirectory() else {return nil}
        
        let fileName = generateDiskFileNameFor(resourceName)
        
        return cacheDirectory.addPathComponent(fileName)
        
    }
    
    /// Generate name to store on disk
    ///
    /// - Parameter resourceName: name of resource to save
    /// - Returns: generated name
    private func generateDiskFileNameFor(_ resourceName:String) -> String {
        let baseAdd = baseAddress ?? ImageManagerConstants.emptyString
        let minifiedFileName = resourceName.isResourceFrom(baseAddress: baseAdd) ? resourceName.fileNameWithExtn() : resourceName.santisedFileName()
        
        return minifiedFileName
    }
    
    /// Returns Cache Base Directory
    ///
    /// - Returns: base directory
    private func getCacheDirectory() -> String? {
        let pathsArray = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        
        guard pathsArray.count > 0 else {return nil}
        
        return (pathsArray[0].addPathComponent(ImageManagerConstants.cacheRootName))
        
    }
    
    /// Helps to send the callbacks to the requesting object on main queue
    ///
    /// - Parameters:
    ///   - callback: the callback received by the caller
    ///   - filePath: file path obtained
    private func initiateCallBack(_ callback:@escaping DownloadImageCompletion, filePath:String?) {
        DispatchQueue.main.async {
            callback(filePath)
        }
    }
    
}
