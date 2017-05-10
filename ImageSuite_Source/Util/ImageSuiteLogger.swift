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
import Foundation

enum LogLevel {
    case LogLevelInfo, LogLevelWarn, LogLevelParse, LogLevelError
    
    func getLevel() -> String {
        let refLevel: String
        
        switch self {
        case .LogLevelInfo:
            refLevel = "[INFO]"
        case .LogLevelWarn:
            refLevel = "[WARN]"
        case .LogLevelParse:
            refLevel = "[PARSE]"
        case .LogLevelError:
            refLevel = "[ERROR]"
        }
        
        return refLevel
    }
}

class ImageSuiteLogger {
    
    static var isLoggingEnabled = false
    
    private init() {}
    
    private static let loggingQueue = DispatchQueue(label:"loggingQueue", qos:.background)
    
    class func info(_ items: Any, file: String = #file, line: Int = #line, function: String = #function) {
        buildLogStatement(items, file: file, line: line, function: function,level:LogLevel.LogLevelInfo)
    }
    
    class func warn(_ items: Any, file: String = #file, line: Int = #line, function: String = #function) {
        buildLogStatement(items, file: file, line: line, function: function,level:LogLevel.LogLevelWarn)
    }
    
    class func parse(_ items: Any, file: String = #file, line: Int = #line, function: String = #function) {
        buildLogStatement(items, file: file, line: line, function: function,level:LogLevel.LogLevelParse)
    }
    
    class func error(_ items: Any, file: String = #file, line: Int = #line, function: String = #function) {
        buildLogStatement(items, file: file, line: line, function: function,level:LogLevel.LogLevelError)
    }
    
    // MARK: - Private
    
    /// Generates the log statements with time and log level stampings
    class private func buildLogStatement(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function, level:LogLevel) {
        
        if !isLoggingEnabled {
            return
        }
        
        loggingQueue.sync {
            let dateStamp = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let loggerText = "[\(dateFormatter.string(from: dateStamp))]: \(level.getLevel())-ImageSuite: \(function):- \(items.map({ String(describing: $0) }).joined(separator: ""))"
            
            logToConsole(loggerText)
            
        }
        
    }
    
    class private func logToConsole(_ text: String) {
        print(text,separator: "", terminator: "\n")
    }
}
