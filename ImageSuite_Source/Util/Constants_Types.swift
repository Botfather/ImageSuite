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

/**********************************************Constants**************************************************************/

enum AsynImageViewConstants {
    static let emptyPlaceHolderString = ""
}

enum ImageManagerConstants {
    static let cacheRootName = "ImageCache"
    static let urlRegex = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    static let emptyString = ""
    static let baseAddressKey = "ImageSuiteBaseAddress"
    static let cacheTimeOutKey = "ImageSuiteCacheInvalidateValue"
    static let defaultCacheExpiryTime = 259200 //3 days
}

/**********************************************Types******************************************************************/

typealias SetImageCompletion = (Bool) -> ()
typealias DownloadImageCompletion = (String?) -> ()
typealias ImageDownloaderCallback = (Data?, Error?) -> Void
