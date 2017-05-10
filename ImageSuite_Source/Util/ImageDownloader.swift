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

import Foundation

class ImageDownloader {
    
    private init() {}
    
    /// Makes a URL request to download the resource
    ///
    /// - Parameter resourceURL: complete URI of resource
    /// - Returns: request to download the image
    class func buildImageDownloadRequest(url resourceURL:String) -> URLRequest? {
        guard let imageURL = URL(string: resourceURL) else {return nil}
        
        let request = URLRequest(url: imageURL)
        
        ImageSuiteLogger.info("Request:\(request)")
        
        return request
    }
    
    /// Send request to download the File from server
    ///
    /// - Parameters:
    ///   - request: request built for downloading the respurce
    ///   - handler: on completion handler
    class func sendRequest(_ request : URLRequest, onCompletion handler:@escaping ImageDownloaderCallback) {
        URLSession.shared.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
    
            if let HTTPResponse = response as? HTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                
                if statusCode == 200 {
                    handler(data,error)
                }
                else {
                    ImageSuiteLogger.error("Status Code: \(statusCode):Message:\(error!)")
                    handler(nil,error)
                }
            } else {
                ImageSuiteLogger.error("Message:\(error!)")
            }
            }.resume()
    }
}
