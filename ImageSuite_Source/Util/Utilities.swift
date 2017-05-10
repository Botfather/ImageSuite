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

extension String {
    
    /// To indentify if the string is a complete URL
    ///
    /// - Returns: true if it is a URL else false
    func isCompleteURL() -> Bool {
       let validateURL = NSPredicate(format: "SELF MATCHES %@", ImageManagerConstants.urlRegex)
        return validateURL.evaluate(with: self)
    }
    
    func addPathComponent(_ component:String) -> String {
        return (URL(string:self)?.appendingPathComponent(component).path)!
    }
    
    func fileNameWithExtn() -> String {
        return (URL(string:self)?.lastPathComponent)!
    }
    
    func santisedFileName() -> String {
        return (self.replacingOccurrences(of: "//", with: "").replacingOccurrences(of: ":", with:  "").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: ".", with: ""))
    }
    
    func deleteLastPathComponent() -> String {
        return (URL(string:self)?.deletingLastPathComponent().path)!
    }
    
    func isResourceFrom(baseAddress:String) -> Bool {
        return (self.lowercased().range(of:baseAddress) != nil)
    }
    
    mutating func deletePathExtension() -> String {
        return (URL(string:self)?.deletingPathExtension().path)!
    }
    
}
