//
//  LogManager.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import XCGLogger

class LogManager: NSObject {

    let log: XCGLogger = {
        let log = XCGLogger.default
        return log
    }()
    
    // MARK: - Singleton Instance
    private static let _sharedManager = LogManager()
    
    class func sharedManager() -> LogManager {
        return _sharedManager
    }
    
    private override init() {
        super.init()
    }
    
    // MARK: - Setup methods
    class func setup(logLevel: XCGLogger.Level = .debug, showLogLevel: Bool = true, showFunctionName: Bool = true, showThreadName: Bool = false, showFileName: Bool = true, showLineNumber: Bool = true, writeToFile: Bool = false) {
        
        LogManager.sharedManager().setup(logLevel: logLevel, showLogLevel: showLogLevel, showFunctionName: showFunctionName, showThreadName: showThreadName, showFileName: showFileName, showLineNumber: showLineNumber, writeToFile: writeToFile)
    }
    
    func setup(logLevel: XCGLogger.Level = .debug, showLogLevel: Bool = true, showFunctionName: Bool = true, showThreadName: Bool = false, showFileName: Bool = true, showLineNumber: Bool = true, writeToFile _: Bool = false) {
        
        #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
            
            self.log.removeLogDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier)
            self.log.addLogDestination(XCGNSLogDestination(owner: self.log, identifier: XCGLogger.Constants.nslogDestinationIdentifier))
            self.log.logAppDetails()
            
        #else
            
            self.log.setup(level: logLevel, showFunctionName: showFunctionName, showThreadName: showThreadName, showLevel: showLogLevel, showFileNames: showFileName, showLineNumbers: showLineNumber, writeToFile: _slowPath)
            
        #endif
    }
    
    // MARK: - Write log
    func writeLog(logLevel: XCGLogger.Level, closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        
        log.logln(logLevel, functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
}

// MARK: - Helpers for Logging
extension LogManager {
    
    class func log(_ closure: @autoclosure () -> Any?, _ functionName: StaticString = #function, _ fileName: StaticString = #file, _ lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .none, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logDebug(_ closure: @autoclosure () -> Any?, _ functionName: StaticString = #function, _ fileName: StaticString = #file, _ lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .debug, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logInfo(_ closure: @autoclosure () -> Any?, _ functionName: StaticString = #function, _ fileName: StaticString = #file, _ lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .info, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logWarning(_ closure: @autoclosure () -> Any?, _ functionName: StaticString = #function, _ fileName: StaticString = #file, _ lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .warning, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logError(_ closure: @autoclosure () -> Any?, _ functionName: StaticString = #function, _ fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .error, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logSevere(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .severe, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logEntry(_ functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .debug, closure: "ENTRY", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logExit(_ functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(logLevel: .debug, closure: "EXIT", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}
