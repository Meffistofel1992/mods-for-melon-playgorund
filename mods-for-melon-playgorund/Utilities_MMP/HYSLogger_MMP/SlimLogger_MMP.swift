//
//  LogDestination.swift
//  FishWorld
//
//  Created by Yurii Hranchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//
import Foundation

enum SourceFilesThatShouldLog {
    case all
    case none
    case enabledSourceFiles([String])
}

enum LogLevel_MMP: Int {
    case trace  = 100
    case debug  = 200
    case info   = 300
    case warn   = 400
    case error  = 500
    case fatal  = 600
    var string: String {
        switch self {
        case .trace:
            return "TRACE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO "
        case .warn:
            return "WARN "
        case .error:
            return "ERROR"
        case .fatal:
            return "FATAL"
        }
    }
}

protocol LogDestination {
    func log<T>(_ message: @autoclosure () -> T,
                level: LogLevel_MMP,
                filename: String,
                line: Int)
}

private let slim = Slim()

class Slim {
    private var logDestinations: [LogDestination] = []
    private var cleanedFilenamesCache: NSCache = NSCache<NSString, AnyObject>()
    init() {
        if SlimConfig.enableConsoleLogging {
            logDestinations.append(ConsoleDestination())
        }
    }
    class func addLogDestination_MMP(_ destination: LogDestination) {
        slim.logDestinations.append(destination)
    }
    class func trace_MMP<T>(_ message: @autoclosure () -> T,
                             filename: String = #file,
                             line: Int = #line) {
        slim.logInternal_MMP(message(), level: LogLevel_MMP.trace, filename: filename, line: line)
    }
    class func debug_MMP<T>(_ message: @autoclosure () -> T,
                             filename: String = #file,
                             line: Int = #line) {
        slim.logInternal_MMP(message(), level: LogLevel_MMP.debug, filename: filename, line: line)
    }
    class func info_MMP<T>(_ message: @autoclosure () -> T,
                            filename: String = #file,
                            line: Int = #line) {
        slim.logInternal_MMP(message(), level: LogLevel_MMP.info, filename: filename, line: line)
    }
    class func warn_MMP<T>(_ message: @autoclosure () -> T,
                            filename: String = #file,
                            line: Int = #line) {
        slim.logInternal_MMP(message(), level: LogLevel_MMP.warn, filename: filename, line: line)
    }
    class func error_MMP<T>(_ message: @autoclosure () -> T,
                             filename: String = #file,
                             line: Int = #line) {
        slim.logInternal_MMP(message(), level: LogLevel_MMP.error, filename: filename, line: line)
    }
    class func fatal_MMP<T>(_ message: @autoclosure () -> T,
                             filename: String = #file,
                             line: Int = #line) {
        slim.logInternal_MMP(message(), level: LogLevel_MMP.fatal, filename: filename, line: line)
    }
    fileprivate func logInternal_MMP<T>(_ message: @autoclosure () -> T, level: LogLevel_MMP,
                                    filename: String,
                                    line: Int) {
        let cleanedfile = cleanedFilename(filename)
        if isSourceFileEnabled(cleanedfile) {
            for dest in logDestinations {
                dest.log(message(), level: level, filename: cleanedfile, line: line)
            }
        }
    }
    fileprivate func cleanedFilename(_ filename: String) -> String {
        if let cleanedfile: String = cleanedFilenamesCache.object(forKey: filename as NSString) as? String {
            return cleanedfile
        } else {
            var retval = ""
            let items = filename.split(omittingEmptySubsequences: true,
                                       whereSeparator: { $0 == "/" }).map { String($0) }
            if !items.isEmpty {
                retval = items.last!
            }
            cleanedFilenamesCache.setObject(retval as AnyObject, forKey: filename as NSString)
            return retval
        }
    }
    fileprivate func isSourceFileEnabled(_ cleanedFile: String) -> Bool {
        switch SlimConfig.sourceFilesThatShouldLog {
        case .all:
            return true
        case .none:
            return false
        case .enabledSourceFiles(let enabledFiles):
            if enabledFiles.contains(cleanedFile) {
                return true
            } else {
                return false
            }
        }
    }
}

final class ConsoleDestination: LogDestination {
    private let dateFormatter = DateFormatter()
    private let serialLogQueue = DispatchQueue(label: "ConsoleDestinationQueue", attributes: [])
    init() {
        dateFormatter.dateFormat = "HH:mm:ss:SSS"
    }
    func log<T>(_ message: @autoclosure () -> T, level: LogLevel_MMP,
                       filename: String,
                       line: Int) {
        if level.rawValue >= SlimConfig.consoleLogLevel.rawValue {
            let msg = message()
            self.serialLogQueue.async {
                print("\(self.dateFormatter.string(from: Date())):\(level.string):" +
                    "\(filename):\(line) - \(msg)")
            }
        }
    }
}
