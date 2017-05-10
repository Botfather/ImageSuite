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

class FileOperations {
    
    private init() {}
    
    ///  Writes the Data to Disk
    ///
    /// - Parameters:
    ///   - fileData: data to Write
    ///   - path: Path to write to
    /// - Returns: true if write was successful else false
    fileprivate class func saveFile(fileData:Data, to path:String) -> Bool {
        let defaultFileManager = FileManager.default
        let dirPath = path.deleteLastPathComponent()
        if !defaultFileManager.fileExists(atPath: dirPath) {
            try? defaultFileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        do{
            try fileData.write(to:URL(fileURLWithPath:path),options:.atomic)
        }
        catch {
            ImageSuiteLogger.error("\(error)")
            return false
        }
        
        return true
    }
}

extension FileOperations {
    class func saveImage(imageData: Data, to generatedFilePath:String) -> Bool {
        return saveFile(fileData: imageData, to: generatedFilePath)
    }
    
    class func loadImage(from fileName: String) -> UIImage? {
        guard let requiredData = try? Data(contentsOf: URL(fileURLWithPath: fileName)) else { return nil }
        
        return UIImage(data: requiredData)
        
    }
    
    class func getBaseAddress() -> String? {
        guard let baseAddress = Bundle.main.object(forInfoDictionaryKey: ImageManagerConstants.baseAddressKey) else {
            return nil }
        
        return (baseAddress as! String)
    }
    
    class func getCacheExpirationValue() -> Double {
        let expiryTime = Bundle.main.object(forInfoDictionaryKey: ImageManagerConstants.cacheTimeOutKey) ?? ImageManagerConstants.defaultCacheExpiryTime
        
        return expiryTime as! Double
    }
    
    class func clearDiskCache(_ path:String) {
        try? FileManager.default.removeItem(atPath: path)
    }
    
    class func removeResourcesOlderThan(_ limit:Double, from path:String) {
        let currentDate = Date()
        
        DispatchQueue.global(qos:.utility).async {
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: path)
            while let element = enumerator?.nextObject() as? String {
                let candidateFile = path.addPathComponent(element)
                let candidateAttributes = try? fileManager.attributesOfItem(atPath: candidateFile)
                
                if let candidateAttributes = candidateAttributes {
                    let dict = candidateAttributes as Dictionary
                    let dateInfo = dict[FileAttributeKey.creationDate] as! Date
                    
                    if currentDate.timeIntervalSince(dateInfo) > limit {
                        ImageSuiteLogger.info("Deleting: \(element)")
                       try? fileManager.removeItem(atPath: candidateFile)
                    }
                    
                }
                
            }
            
        }
        
    }

}
